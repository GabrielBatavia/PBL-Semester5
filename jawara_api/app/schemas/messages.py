# app/schemas/messages.py
from datetime import datetime
from pydantic import BaseModel, ConfigDict


class MessageBase(BaseModel):
    title: str
    content: str


class MessageCreate(MessageBase):
    pass


class MessageRead(MessageBase):
    id: int
    status: str
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
