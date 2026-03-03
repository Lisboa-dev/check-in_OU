from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from app.models.presence_log import PresenceLog
from app.models.student_form import StudentForm
from app.models.trip_log import TripLog, TripStatusEnum
from app.models.user import User, UserRoleEnum
from app.schemas.driver import TripNotificationCreate
from app.utils import validate_qr_payload


def scan_student(db: Session, driver: User, student_id: int, qr_payload: str) -> PresenceLog:
    student = db.query(User).filter(User.id == student_id, User.role == UserRoleEnum.STUDENT).first()
    if not student:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Aluno não encontrado")

    form = db.query(StudentForm).filter(StudentForm.user_id == student.id).first()
    if not form or not form.qr_code_hash:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Aluno sem QR Code válido")

    if not validate_qr_payload(qr_payload, form_id=form.id, user_id=student.id):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="QR Code inválido")

    active_trip = (
        db.query(TripLog)
        .filter(TripLog.driver_id == driver.id, TripLog.status == TripStatusEnum.ACTIVE)
        .order_by(TripLog.created_at.desc())
        .first()
    )

    presence = PresenceLog(student_id=student.id, driver_id=driver.id, trip_log_id=active_trip.id if active_trip else None)
    db.add(presence)
    db.commit()
    db.refresh(presence)
    return presence


def create_trip_notification(db: Session, driver: User, payload: TripNotificationCreate) -> TripLog:
    trip = TripLog(driver_id=driver.id, status=payload.status, message=payload.message)
    db.add(trip)
    db.commit()
    db.refresh(trip)
    return trip
