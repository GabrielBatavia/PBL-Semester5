# jawara_api/app/schemas/marketplace.py
from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import datetime


class MarketplaceItemBase(BaseModel):
    title: str
    description: Optional[str] = None
    price: float
    unit: Optional[str] = None
    veggie_class: Optional[str] = None


class MarketplaceItemCreate(MarketplaceItemBase):
    pass


class MarketplaceItemRead(MarketplaceItemBase):
    id: int
    image_url: Optional[str] = None
    owner_id: int
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)

