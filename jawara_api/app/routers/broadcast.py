from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..db import SessionLocal
from ..models.broadcast import Broadcast
from ..schemas.broadcast import BroadcastCreate, BroadcastRead, BroadcastUpdate
from ..deps import get_db

router = APIRouter(prefix="/broadcasts", tags=["Broadcast"])

# GET ALL BROADCAST
@router.get("/", response_model=list[BroadcastRead])
def get_all_broadcasts(db: Session = Depends(get_db)):
    return db.query(Broadcast).order_by(Broadcast.created_at.desc()).all()

# GET DETAIL BROADCAST
@router.get("/{broadcast_id}", response_model=BroadcastRead)
def get_broadcast(broadcast_id: int, db: Session = Depends(get_db)):
    item = db.query(Broadcast).filter(Broadcast.id == broadcast_id).first()
    if not item:
        raise HTTPException(status_code=404, detail="Broadcast tidak ditemukan")
    return item

# CREATE BROADCAST
@router.post("/", response_model=BroadcastRead, status_code=201)
def create_broadcast(body: BroadcastCreate, db: Session = Depends(get_db)):
    new_item = Broadcast(**body.dict())
    db.add(new_item)
    db.commit()
    db.refresh(new_item)
    return new_item

# UPDATE BROADCAST
@router.put("/{broadcast_id}", response_model=BroadcastRead)
def update_broadcast(broadcast_id: int, body: BroadcastUpdate, db: Session = Depends(get_db)):
    item = db.query(Broadcast).filter(Broadcast.id == broadcast_id).first()
    if not item:
        raise HTTPException(status_code=404, detail="Broadcast tidak ditemukan")

    update_data = body.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(item, key, value)

    db.commit()
    db.refresh(item)
    return item

# DELETE BROADCAST
@router.delete("/{broadcast_id}")
def delete_broadcast(broadcast_id: int, db: Session = Depends(get_db)):
    item = db.query(Broadcast).filter(Broadcast.id == broadcast_id).first()
    if not item:
        raise HTTPException(status_code=404, detail="Broadcast tidak ditemukan")

    db.delete(item)
    db.commit()
    return {"message": "Broadcast berhasil dihapus"}