from datetime import time

from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from app.models.feedback import Feedback
from app.models.presence_log import PresenceLog
from app.models.student_form import StudentForm
from app.models.user import User
from app.schemas.feedback import FeedbackCreate
from app.schemas.student import StudentFormCreate, StudentFormUpdate
from app.utils import build_qr_payload, generate_qr_base64


def create_or_get_form(db: Session, user: User, payload: StudentFormCreate) -> StudentForm:
    if user.student_form:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Você já possui formulário ativo. Utilize PUT /formulario para atualizar.",
        )

    form = StudentForm(
        user_id=user.id,
        university=payload.university,
        route=payload.route,
        schedule=time.fromisoformat(payload.schedule),
    )
    db.add(form)
    db.commit()
    db.refresh(form)
    return form


def get_my_form(db: Session, user: User) -> StudentForm:
    form = db.query(StudentForm).filter(StudentForm.user_id == user.id).first()
    if not form:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Formulário não encontrado")
    return form


def update_form(db: Session, user: User, payload: StudentFormUpdate) -> StudentForm:
    form = get_my_form(db, user)
    form.university = payload.university
    form.route = payload.route
    form.schedule = time.fromisoformat(payload.schedule)
    db.commit()
    db.refresh(form)
    return form


def get_or_generate_qr(db: Session, user: User) -> tuple[str, str]:
    form = get_my_form(db, user)
    payload = build_qr_payload(form_id=form.id, user_id=user.id)
    if form.qr_code_hash != payload:
        form.qr_code_hash = payload
        db.commit()
    qr_b64 = generate_qr_base64(payload)
    return qr_b64, payload


def create_feedback(db: Session, user: User, payload: FeedbackCreate) -> Feedback:
    feedback = Feedback(user_id=user.id, message=payload.message)
    db.add(feedback)
    db.commit()
    db.refresh(feedback)
    return feedback


def get_student_trip_history(db: Session, student_id: int) -> list[PresenceLog]:
    return (
        db.query(PresenceLog)
        .filter(PresenceLog.student_id == student_id)
        .order_by(PresenceLog.scanned_at.desc())
        .all()
    )
