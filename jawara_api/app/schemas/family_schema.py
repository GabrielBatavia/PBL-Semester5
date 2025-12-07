# app/schemas/family_schema.py

from pydantic import BaseModel
from typing import Optional, List

class FamilyBase(BaseModel):
    name: str
    house_id: Optional[int] = None
    status: Optional[str] = "aktif"

class FamilyCreate(FamilyBase):
    pass

class FamilyUpdate(FamilyBase):
    pass

class FamilyOut(FamilyBase):
    id: int

    class Config:
        orm_mode = True


# Untuk endpoint /families/extended
class FamilyExtended(FamilyOut):
    jumlah_anggota: int
    address: Optional[str] = None
