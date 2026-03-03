import enum

from sqlalchemy import Enum, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class UserRoleEnum(str, enum.Enum):
    ADMIN = "admin"
    STUDENT = "student"
    DRIVER = "driver"


class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True, nullable=False)
    hashed_password: Mapped[str] = mapped_column(String(255), nullable=False)
    full_name: Mapped[str] = mapped_column(String(255), nullable=False)
    role: Mapped[UserRoleEnum] = mapped_column(Enum(UserRoleEnum), nullable=False)

    student_form = relationship("StudentForm", back_populates="user", uselist=False)
    feedbacks = relationship("Feedback", back_populates="user")
    driver_trip_logs = relationship("TripLog", back_populates="driver")
    student_presences = relationship("PresenceLog", foreign_keys="PresenceLog.student_id", back_populates="student")
    driver_presences = relationship("PresenceLog", foreign_keys="PresenceLog.driver_id", back_populates="driver")
