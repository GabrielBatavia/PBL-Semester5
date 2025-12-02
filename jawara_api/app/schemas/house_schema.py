from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class HouseBase(BaseModel):
    address: str
    area: Optional[str] = None
    status: Optional[str] = None


class HouseCreate(HouseBase):
    pass


class HouseUpdate(BaseModel):
    address: Optional[str] = None
    area: Optional[str] = None
    status: Optional[str] = None


class HouseOut(HouseBase):
    id: int
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None
    family_id: Optional[int] = None
    

    class Config:
        orm = True  # pengganti orm_mode=True
