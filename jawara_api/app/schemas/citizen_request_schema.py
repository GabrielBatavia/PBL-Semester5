from pydantic import BaseModel
from datetime import datetime

class CitizenRequestBase(BaseModel):
    name: str
    nik: str
    email: str
    gender: str | None = None
    identity_image_url: str | None = None

class CitizenRequestCreate(CitizenRequestBase):
    pass

class CitizenRequestUpdate(BaseModel):
    status: str | None = None
    processed_by: int | None = None

class CitizenRequestOut(CitizenRequestBase):
    id: int
    status: str
    processed_by: int | None = None
    processed_by_name: str | None = None
    processed_at: datetime | None = None
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
