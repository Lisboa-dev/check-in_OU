from fastapi import FastAPI

from app.database import Base, engine
from app.routes.admin import router as admin_router
from app.routes.auth import router as auth_router
from app.routes.drivers import router as drivers_router
from app.routes.students import router as students_router

Base.metadata.create_all(bind=engine)

app = FastAPI(title="API de Check-in Universitário", version="1.0.0")

app.include_router(auth_router)
app.include_router(students_router)
app.include_router(drivers_router)
app.include_router(admin_router)


@app.get("/health", tags=["Health"])
async def health_check() -> dict[str, str]:
    return {"status": "ok"}
