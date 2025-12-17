# app/schemas/kegiatan.py
from pydantic import BaseModel, ConfigDict
from typing import Optional
import datetime as dt

class KegiatanBase(BaseModel):
    name: str
    category: str
    pic_name: Optional[str] = None
    location: str
    date: dt.date
    description: Optional[str] = None
    image_url: Optional[str] = None
    created_by: int

class KegiatanCreate(KegiatanBase):
    pass

class KegiatanUpdate(BaseModel):
    name: Optional[str] = None
    category: Optional[str] = None
    pic_name: Optional[str] = None
    location: Optional[str] = None
    date: Optional[dt.date] = None
    description: Optional[str] = None
    image_url: Optional[str] = None

class KegiatanRead(BaseModel):
    id: int
    name: str
    category: Optional[str] = None
    pic_name: Optional[str] = None
    location: Optional[str] = None
    date: dt.date
    description: Optional[str] = None
    image_url: Optional[str] = None
    created_by: int

    model_config = ConfigDict(from_attributes=True)

# ✅ alias biar kompatibel sama import lama
KegiatanOut = KegiatanRead
