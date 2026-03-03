import enum
from datetime import time

from sqlalchemy import Enum, ForeignKey, Integer, String, Time, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class RouteEnum(str, enum.Enum):
    CENTRO = "centro"
    BR = "br"


class StudentForm(Base):
    __tablename__ = "student_forms"
    __table_args__ = (UniqueConstraint("user_id", name="uq_student_forms_user_id"),)

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"), nullable=False, unique=True)
    university: Mapped[str] = mapped_column(String(255), nullable=False)
    route: Mapped[RouteEnum] = mapped_column(Enum(RouteEnum), nullable=False)
    schedule: Mapped[time] = mapped_column(Time, nullable=False)
    qr_code_hash: Mapped[str | None] = mapped_column(String(500), nullable=True)

    user = relationship("User", back_populates="student_form")
