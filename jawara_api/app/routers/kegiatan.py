# app/routers/kegiatan.py

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel

from ..deps import get_db
from ..models.kegiatan import Kegiatan
from ..models.users import User
from ..schemas.kegiatan import KegiatanCreate, KegiatanOut

router = APIRouter(prefix="/kegiatan", tags=["Kegiatan"])


class RoleFilter(BaseModel):
    user_id: int
    role: str


# ✅ CREATE: route jadi POST /kegiatan (tanpa trailing slash) + status 201
@router.post("", response_model=KegiatanOut, status_code=201)
def create_kegiatan(body: KegiatanCreate, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == body.created_by).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    data = Kegiatan(**body.model_dump())
    db.add(data)
    db.commit()
    db.refresh(data)
    return data


@router.post("/filter-by-role")
def get_kegiatan_by_role(body: RoleFilter, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == body.user_id).first()
    if not user:
        return []

    role = body.role.lower()

    # RT → kegiatan yang dibuat oleh user tersebut
    if role == "rt":
        return db.query(Kegiatan).filter(Kegiatan.created_by == body.user_id).all()

    # RW → tampilkan semua kegiatan dari seluruh RT
    if role == "rw":
        rt_users = db.query(User.id).filter(User.role == "rt").all()
        rt_ids = [u[0] for u in rt_users]
        return db.query(Kegiatan).filter(Kegiatan.created_by.in_(rt_ids)).all()

    # admin / lainnya → semua kegiatan
    return db.query(Kegiatan).all()
