from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.auth import require_roles
from app.controllers.student_controller import (
    create_feedback,
    create_or_get_form,
    get_my_form,
    get_or_generate_qr,
    get_student_trip_history,
    update_form,
)
from app.database import get_db
from app.models.user import User, UserRoleEnum
from app.schemas.feedback import FeedbackCreate, FeedbackOut
from app.schemas.student import QRCodeOut, StudentFormCreate, StudentFormOut, StudentFormUpdate

router = APIRouter(tags=["Students"])


@router.post("/formulario", response_model=StudentFormOut)
async def create_form(
    payload: StudentFormCreate,
    db: Session = Depends(get_db),
    student: User = Depends(require_roles(UserRoleEnum.STUDENT)),
) -> StudentFormOut:
    return create_or_get_form(db, student, payload)


@router.get("/formulario/meu", response_model=StudentFormOut)
async def my_form(
    db: Session = Depends(get_db),
    student: User = Depends(require_roles(UserRoleEnum.STUDENT)),
) -> StudentFormOut:
    return get_my_form(db, student)


@router.put("/formulario", response_model=StudentFormOut)
async def edit_form(
    payload: StudentFormUpdate,
    db: Session = Depends(get_db),
    student: User = Depends(require_roles(UserRoleEnum.STUDENT)),
) -> StudentFormOut:
    return update_form(db, student, payload)


@router.get("/formulario/qrcode", response_model=QRCodeOut)
async def my_qr(
    db: Session = Depends(get_db),
    student: User = Depends(require_roles(UserRoleEnum.STUDENT)),
) -> QRCodeOut:
    qr_code_base64, validation_payload = get_or_generate_qr(db, student)
    return QRCodeOut(qr_code_base64=qr_code_base64, validation_payload=validation_payload)


@router.post("/feedback", response_model=FeedbackOut)
async def send_feedback(
    payload: FeedbackCreate,
    db: Session = Depends(get_db),
    student: User = Depends(require_roles(UserRoleEnum.STUDENT)),
) -> FeedbackOut:
    return create_feedback(db, student, payload)


@router.get("/alunos/historico", response_model=list[dict])
async def my_history(
    db: Session = Depends(get_db),
    student: User = Depends(require_roles(UserRoleEnum.STUDENT)),
) -> list[dict]:
    logs = get_student_trip_history(db, student.id)
    return [
        {
            "presence_id": log.id,
            "driver_id": log.driver_id,
            "trip_log_id": log.trip_log_id,
            "scanned_at": log.scanned_at,
        }
        for log in logs
    ]
