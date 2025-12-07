from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from ..deps import get_db
from ..models.kegiatan import Kegiatan
from ..models.users import User
from pydantic import BaseModel

router = APIRouter(prefix="/kegiatan", tags=["Kegiatan"])

class RoleFilter(BaseModel):
    user_id: int
    role: str

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

    # admin → semua kegiatan
    return db.query(Kegiatan).all()