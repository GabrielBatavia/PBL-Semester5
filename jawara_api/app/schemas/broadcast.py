# app/schemas/broadcast.py
from pydantic import BaseModel
from datetime import datetime

class BroadcastBase(BaseModel):
    title: str
    content: str
    sender_id: int | None = None
    image_url: str | None = None
    document_name: str | None = None
    document_url: str | None = None
    target_scope: str | None = None

class BroadcastCreate(BroadcastBase):
    pass

class BroadcastUpdate(BaseModel):
    title: str | None = None
    content: str | None = None
    sender_id: int | None = None

class BroadcastRead(BroadcastBase):
    id: int
    published_at: datetime | None = None
    created_at: datetime | None = None
    updated_at: datetime | None = None

    class Config:
        from_attributes = True