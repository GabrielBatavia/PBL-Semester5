# app/schemas/marketplace.py
from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class MarketplaceItemBase(BaseModel):
    title: str
    description: Optional[str] = None
    price: float
    unit: Optional[str] = None


class MarketplaceItemCreate(MarketplaceItemBase):
    pass  # semua field dari base, image di-handle via upload file


class MarketplaceItemRead(MarketplaceItemBase):
    id: int
    image_url: Optional[str] = None
    owner_id: int
    created_at: datetime

    class Config:
        orm_mode = True
