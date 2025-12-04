# app/routers/broadcast.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from ..deps import get_db
from ..models.broadcast import Broadcast
from ..schemas.broadcast import BroadcastCreate, BroadcastRead, BroadcastUpdate

router = APIRouter(prefix="/broadcast", tags=["Broadcast"])

@router.get("/", response_model=List[BroadcastRead])
def list_broadcasts(db: Session = Depends(get_db)):
    return db.query(Broadcast).order_by(Broadcast.created_at.desc()).all()

@router.get("/{broadcast_id}", response_model=BroadcastRead)
def get_broadcast(broadcast_id: int, db: Session = Depends(get_db)):
    item = db.query(Broadcast).filter(Broadcast.id == broadcast_id).first()
    if not item:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Broadcast tidak ditemukan")
    return item

@router.post("/", response_model=BroadcastRead, status_code=201)
def create_broadcast(body: BroadcastCreate, db: Session = Depends(get_db)):
    item = Broadcast(**body.dict())
    db.add(item)
    db.commit()
    db.refresh(item)
    return item

@router.put("/{broadcast_id}", response_model=BroadcastRead)
def update_broadcast(broadcast_id: int, body: BroadcastUpdate, db: Session = Depends(get_db)):
    item = db.query(Broadcast).filter(Broadcast.id == broadcast_id).first()
    if not item:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Broadcast tidak ditemukan")

    update_data = body.dict(exclude_unset=True)
    for k, v in update_data.items():
        setattr(item, k, v)

    db.commit()
    db.refresh(item)
    return item

@router.delete("/{broadcast_id}", status_code=204)
def delete_broadcast(broadcast_id: int, db: Session = Depends(get_db)):
    item = db.query(Broadcast).filter(Broadcast.id == broadcast_id).first()
    if not item:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Broadcast tidak ditemukan")

    db.delete(item)
    db.commit()
    return {}