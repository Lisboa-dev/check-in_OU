from fastapi import APIRouter, Depends
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session

from app.controllers.auth_controller import login_user, register_user
from app.database import get_db
from app.schemas.auth import Token, UserCreate, UserOut

router = APIRouter(prefix="/auth", tags=["Auth"])


@router.post("/register", response_model=UserOut)
async def register(payload: UserCreate, db: Session = Depends(get_db)) -> UserOut:
    return register_user(db, payload)


@router.post("/token", response_model=Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)) -> Token:
    token = login_user(db, form_data.username, form_data.password)
    return Token(access_token=token)
