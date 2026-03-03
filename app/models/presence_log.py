from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Integer, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class PresenceLog(Base):
    __tablename__ = "presence_logs"
    __table_args__ = (UniqueConstraint("student_id", "trip_log_id", name="uq_presence_student_trip"),)

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    student_id: Mapped[int] = mapped_column(ForeignKey("users.id"), nullable=False)
    driver_id: Mapped[int] = mapped_column(ForeignKey("users.id"), nullable=False)
    trip_log_id: Mapped[int | None] = mapped_column(ForeignKey("trip_logs.id"), nullable=True)
    scanned_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)

    student = relationship("User", foreign_keys=[student_id], back_populates="student_presences")
    driver = relationship("User", foreign_keys=[driver_id], back_populates="driver_presences")
    trip_log = relationship("TripLog")
