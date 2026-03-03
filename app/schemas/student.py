from datetime import time

from pydantic import BaseModel, Field, field_validator

from app.models.student_form import RouteEnum


class StudentFormBase(BaseModel):
    university: str = Field(min_length=2, max_length=255)
    route: RouteEnum
    schedule: str = Field(description="Formato HH:mm")

    @field_validator("schedule")
    @classmethod
    def validate_schedule(cls, value: str) -> str:
        try:
            time.fromisoformat(value)
        except ValueError as exc:
            raise ValueError("schedule deve estar no formato HH:mm") from exc
        if len(value) != 5:
            raise ValueError("schedule deve estar no formato HH:mm")
        return value


class StudentFormCreate(StudentFormBase):
    pass


class StudentFormUpdate(StudentFormBase):
    pass


class StudentFormOut(BaseModel):
    id: int
    user_id: int
    university: str
    route: RouteEnum
    schedule: time
    qr_code_hash: str | None

    class Config:
        from_attributes = True


class QRCodeOut(BaseModel):
    qr_code_base64: str
    validation_payload: str
