# app/schemas/broadcast.py
from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class BroadcastBase(BaseModel):
    title: str
    content: str
    sender_id: Optional[int] = None
    image_url: Optional[str] = None
    document_name: Optional[str] = None
    document_url: Optional[str] = None
    target_scope: Optional[str] = None

class BroadcastCreate(BroadcastBase):
    pass

class BroadcastUpdate(BaseModel):
    title: Optional[str] = None
    content: Optional[str] = None
    sender_id: Optional[int] = None

class BroadcastRead(BroadcastBase):
    id: int
    published_at: Optional[datetime] = None
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True