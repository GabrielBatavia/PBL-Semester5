# app/routers/messages.py
from typing import List

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from ..db import SessionLocal
from .. import models
from ..schemas import messages as msg_schemas
from ..deps import get_db, get_current_user

router = APIRouter(
    prefix="/messages",
    tags=["Pesan Warga"],
)


@router.post("/", response_model=msg_schemas.MessageRead, status_code=201)
def create_message(
    body: msg_schemas.MessageCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    # hanya user login yang boleh
    if current_user is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED)

    msg = models.CitizenMessage(
        user_id=current_user.id,
        title=body.title,
        content=body.content,
        status="pending",
    )
    db.add(msg)
    db.commit()
    db.refresh(msg)
    return msg


@router.get("/", response_model=List[msg_schemas.MessageRead])
def list_messages(
    only_mine: bool = False,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    if current_user is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED)

    q = db.query(models.CitizenMessage).order_by(
        models.CitizenMessage.created_at.desc()
    )

    # kalau warga: default hanya lihat pesan sendiri
    if only_mine or current_user.role_name == "warga":
        q = q.filter(models.CitizenMessage.user_id == current_user.id)

    return q.all()
