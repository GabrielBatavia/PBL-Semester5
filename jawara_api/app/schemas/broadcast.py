from pydantic import BaseModel
from datetime import datetime
from typing import Optional

# BASE
class BroadcastBase(BaseModel):
    title: str
    content: str
    sender_id: Optional[int] = None
    published_at: Optional[datetime] = None
    image_url: Optional[str] = None
    document_name: Optional[str] = None
    document_url: Optional[str] = None
    target_scope: Optional[str] = None


# CREATE
class BroadcastCreate(BroadcastBase):
    pass


# UPDATE
class BroadcastUpdate(BaseModel):
    title: Optional[str] = None
    content: Optional[str] = None
    sender_id: Optional[int] = None
    published_at: Optional[datetime] = None
    image_url: Optional[str] = None
    document_name: Optional[str] = None
    document_url: Optional[str] = None
    target_scope: Optional[str] = None


# READ
class BroadcastRead(BroadcastBase):
    id: int
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True