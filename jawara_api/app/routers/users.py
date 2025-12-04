# app/routers/users.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from ..deps import get_db, get_current_user
from .. import models
from ..schemas import users as user_schemas
from ..schemas import logs as log_schemas
# from ..models import ActivityLog 

router = APIRouter(prefix="/users", tags=["Users"])


@router.get("/", response_model=List[user_schemas.UserRead])
def list_users(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    # kalau mau: cek role admin sistem di sini
    users = db.query(models.User).order_by(models.User.id.desc()).all()
    return users


@router.post("/", response_model=user_schemas.UserRead, status_code=201)
def create_user(
    body: user_schemas.UserCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    from .auth import hash_password  # reuse

    # cek email unik
    existing = db.query(models.User).filter(
        models.User.email == body.email
    ).first()
    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email sudah digunakan.",
        )

    user = models.User(
        name=body.name,
        email=body.email,
        password_hash=hash_password(body.password),
        nik=body.nik,
        phone=body.phone,
        address=body.address,
        role_id=body.role_id,
        status=body.status or "diterima",
    )
    db.add(user)

    # tulis log
    log = ActivityLog(
      description=f"Menambahkan pengguna: {user.name}",
      actor_id=current_user.id,
    )
    db.add(log)

    db.commit()
    db.refresh(user)
    return user


@router.patch("/{user_id}", response_model=user_schemas.UserRead)
def update_user(
    user_id: int,
    body: user_schemas.UserUpdate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User tidak ditemukan.")

    if body.name is not None:
        user.name = body.name
    if body.role_id is not None:
        user.role_id = body.role_id
    if body.status is not None:
        user.status = body.status

    log = ActivityLog(
      description=f"Update pengguna: {user.name}",
      actor_id=current_user.id,
    )
    db.add(log)

    db.commit()
    db.refresh(user)
    return user
