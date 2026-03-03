from pydantic import BaseModel, EmailStr, Field

from app.models.user import UserRoleEnum


class UserCreate(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8, max_length=128)
    full_name: str = Field(min_length=2, max_length=255)
    role: UserRoleEnum


class UserOut(BaseModel):
    id: int
    email: EmailStr
    full_name: str
    role: UserRoleEnum

    class Config:
        from_attributes = True


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
