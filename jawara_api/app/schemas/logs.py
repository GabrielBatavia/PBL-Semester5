# app/schemas/logs.py
from pydantic import BaseModel
from datetime import datetime


class LogActor(BaseModel):
    id: int
    name: str

    class Config:
        orm_mode = True


class LogRead(BaseModel):
    id: int
    description: str
    actor: LogActor
    created_at: datetime

    class Config:
        orm_mode = True
