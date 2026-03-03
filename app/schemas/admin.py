from pydantic import BaseModel


class CountByItem(BaseModel):
    key: str
    total: int


class DashboardOut(BaseModel):
    by_university: list[CountByItem]
    by_route: list[CountByItem]
