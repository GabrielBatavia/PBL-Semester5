# app/schemas/logs.py
from pydantic import BaseModel, ConfigDict
from datetime import datetime


class LogActor(BaseModel):
    id: int
    name: str

    model_config = ConfigDict(from_attributes=True)


class LogRead(BaseModel):
    id: int
    description: str
    actor: LogActor
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)

