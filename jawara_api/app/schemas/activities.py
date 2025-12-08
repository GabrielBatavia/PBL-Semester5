# Create file: jawara_api/app/schemas/activities.py

from pydantic import BaseModel
from datetime import date, datetime
from typing import Optional


class ActivityBase(BaseModel):
    name: str
    category: Optional[str] = None
    pic_name: Optional[str] = None
    location: Optional[str] = None
    date: date
    description: Optional[str] = None
    image_url: Optional[str] = None


class ActivityCreate(ActivityBase):
    pass


class ActivityUpdate(BaseModel):
    name: Optional[str] = None
    category: Optional[str] = None
    pic_name: Optional[str] = None
    location: Optional[str] = None
    date: Optional[date] = None
    description: Optional[str] = None
    image_url: Optional[str] = None


class ActivityRead(ActivityBase):
    id: int
    created_by: Optional[int] = None
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class ActivityCategoryStats(BaseModel):
    """Statistics by category"""
    category: str
    count: int
    percentage: float