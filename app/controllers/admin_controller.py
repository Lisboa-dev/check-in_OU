from sqlalchemy import func
from sqlalchemy.orm import Session

from app.models.feedback import Feedback
from app.models.student_form import StudentForm


def dashboard_stats(db: Session) -> dict[str, list[dict[str, int | str]]]:
    by_university_q = (
        db.query(StudentForm.university, func.count(StudentForm.id))
        .group_by(StudentForm.university)
        .order_by(func.count(StudentForm.id).desc())
        .all()
    )
    by_route_q = (
        db.query(StudentForm.route, func.count(StudentForm.id))
        .group_by(StudentForm.route)
        .order_by(func.count(StudentForm.id).desc())
        .all()
    )

    return {
        "by_university": [{"key": university, "total": total} for university, total in by_university_q],
        "by_route": [{"key": str(route.value), "total": total} for route, total in by_route_q],
    }


def list_feedbacks(db: Session) -> list[Feedback]:
    return db.query(Feedback).order_by(Feedback.created_at.desc()).all()
