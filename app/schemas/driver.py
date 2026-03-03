from datetime import datetime

from pydantic import BaseModel, Field

from app.models.trip_log import TripStatusEnum


class ScanRequest(BaseModel):
    qr_payload: str = Field(min_length=10)


class ScanResponse(BaseModel):
    message: str
    scanned_at: datetime


class TripNotificationCreate(BaseModel):
    status: TripStatusEnum
    message: str = Field(min_length=3, max_length=255)


class TripNotificationOut(BaseModel):
    id: int
    driver_id: int
    status: TripStatusEnum
    message: str
    created_at: datetime

    class Config:
        from_attributes = True
