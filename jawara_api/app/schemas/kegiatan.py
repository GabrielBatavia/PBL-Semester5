# app/schemas/kegiatan.py
from datetime import date, datetime
from typing import Optional

from pydantic import BaseModel, ConfigDict


class KegiatanBase(BaseModel):
    nama: str
    kategori: Optional[str] = None
    pj: Optional[str] = None
    tanggal: date
    lokasi: Optional[str] = None
    deskripsi: Optional[str] = None


class KegiatanCreate(KegiatanBase):
    pass


class KegiatanUpdate(BaseModel):
    nama: Optional[str] = None
    kategori: Optional[str] = None
    pj: Optional[str] = None
    tanggal: Optional[date] = None
    lokasi: Optional[str] = None
    deskripsi: Optional[str] = None


class KegiatanOut(KegiatanBase):
    id: int
    image_url: Optional[str] = None
    created_by_id: int
    created_at: datetime
    updated_at: datetime
    is_deleted: bool

    # pengganti orm_mode=True di Pydantic v2
    model_config = ConfigDict(from_attributes=True)
