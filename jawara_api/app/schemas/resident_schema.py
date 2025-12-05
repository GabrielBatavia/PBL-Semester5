from pydantic import BaseModel
from typing import Optional
from datetime import date

class ResidentBase(BaseModel):
    family_id: Optional[int] = None
    name: str
    nik: Optional[str] = None
    birth_date: Optional[date] = None
    job: Optional[str] = None
    gender: Optional[str] = None
    user_id: Optional[int] = None
    

class ResidentCreate(ResidentBase):
    pass


class ResidentUpdate(ResidentBase):
    pass


class ResidentOut(ResidentBase):
    id: int

    class Config:
        from_attributes = True
