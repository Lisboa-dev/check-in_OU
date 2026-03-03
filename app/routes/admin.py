from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.auth import require_roles
from app.controllers.admin_controller import dashboard_stats, list_feedbacks
from app.controllers.student_controller import get_student_trip_history
from app.database import get_db
from app.models.user import User, UserRoleEnum
from app.schemas.admin import DashboardOut
from app.schemas.feedback import FeedbackOut

router = APIRouter(prefix="/admin", tags=["Admin"])


@router.get("/dashboard", response_model=DashboardOut)
async def dashboard(
    db: Session = Depends(get_db),
    _: User = Depends(require_roles(UserRoleEnum.ADMIN)),
) -> DashboardOut:
    return DashboardOut(**dashboard_stats(db))


@router.get("/feedbacks", response_model=list[FeedbackOut])
async def feedbacks(
    db: Session = Depends(get_db),
    _: User = Depends(require_roles(UserRoleEnum.ADMIN)),
) -> list[FeedbackOut]:
    return list_feedbacks(db)


@router.get("/alunos/{student_id}/historico", response_model=list[dict])
async def student_history(
    student_id: int,
    db: Session = Depends(get_db),
    _: User = Depends(require_roles(UserRoleEnum.ADMIN)),
) -> list[dict]:
    logs = get_student_trip_history(db, student_id)
    return [
        {
            "presence_id": log.id,
            "driver_id": log.driver_id,
            "trip_log_id": log.trip_log_id,
            "scanned_at": log.scanned_at,
        }
        for log in logs
    ]
