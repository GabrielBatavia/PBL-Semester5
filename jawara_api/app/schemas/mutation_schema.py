from pydantic import BaseModel
from datetime import date,datetime


class MutasiBase(BaseModel):
    family_id: int
    old_address: str | None = None
    new_address: str | None = None
    mutation_type: str
    reason: str | None = None
    date: date
    


class MutasiCreate(MutasiBase):
    pass


class MutasiUpdate(MutasiBase):
    pass


class MutasiOut(MutasiBase):
    id: int
    family_name: str
    created_at: datetime | None = None
    updated_at: datetime | None = None


class Config:
    from_attributes = True