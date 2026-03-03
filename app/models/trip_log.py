import enum
from datetime import datetime

from sqlalchemy import DateTime, Enum, ForeignKey, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base


class TripStatusEnum(str, enum.Enum):
    ACTIVE = "active"
    COMPLETED = "completed"


class TripLog(Base):
    __tablename__ = "trip_logs"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    driver_id: Mapped[int] = mapped_column(ForeignKey("users.id"), nullable=False)
    status: Mapped[TripStatusEnum] = mapped_column(Enum(TripStatusEnum), nullable=False)
    message: Mapped[str] = mapped_column(String(255), nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)

    driver = relationship("User", back_populates="driver_trip_logs")
