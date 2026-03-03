from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.auth import require_roles
from app.controllers.driver_controller import create_trip_notification, scan_student
from app.database import get_db
from app.models.user import User, UserRoleEnum
from app.schemas.driver import ScanRequest, ScanResponse, TripNotificationCreate, TripNotificationOut

router = APIRouter(tags=["Drivers"])


@router.post("/scan/{student_id}", response_model=ScanResponse)
async def scan(
    student_id: int,
    payload: ScanRequest,
    db: Session = Depends(get_db),
    driver: User = Depends(require_roles(UserRoleEnum.DRIVER)),
) -> ScanResponse:
    presence = scan_student(db, driver, student_id, payload.qr_payload)
    return ScanResponse(message="Presença registrada com sucesso", scanned_at=presence.scanned_at)


@router.post("/notificar-status", response_model=TripNotificationOut)
async def notify_status(
    payload: TripNotificationCreate,
    db: Session = Depends(get_db),
    driver: User = Depends(require_roles(UserRoleEnum.DRIVER)),
) -> TripNotificationOut:
    return create_trip_notification(db, driver, payload)
