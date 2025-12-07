# app/schemas/kegiatan.py

from pydantic import BaseModel
from datetime import date, datetime

class KegiatanBase(BaseModel):
    name: str
    category: str
    pic_name: str | None = None
    location: str
    date: date
    description: str | None = None
    image_url: str | None = None
    created_by: int

class KegiatanCreate(KegiatanBase):
    pass

class KegiatanUpdate(BaseModel):
    name: str | None = None
    category: str | None = None
    pic_name: str | None = None
    location: str | None = None
    date: date | None = None
    description: str | None = None
    image_url: str | None = None

class KegiatanRead(BaseModel):
    id: int
    name: str
    kategori: str
    pj: str
    lokasi: str
    tanggal: str
    deskripsi: str

    class Config:
        from_attributes = True