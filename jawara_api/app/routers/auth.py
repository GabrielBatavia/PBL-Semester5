# app/routers/auth.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from passlib.context import CryptContext
from jose import jwt
from datetime import datetime, timedelta

from ..db import SessionLocal
from .. import models
from ..schemas import auth as auth_schemas, users as user_schemas
from ..deps import get_db, get_current_user, SECRET_KEY, ALGORITHM

router = APIRouter(prefix="/auth", tags=["Auth"])

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def verify_password(plain, hashed):
    return pwd_context.verify(plain, hashed)


def hash_password(password: str) -> str:
    # JAGA-JAGA: kalau kepanjangan, truncate ke 72 bytes
    if isinstance(password, bytes):
        raw = password
    else:
        raw = password.encode("utf-8")

    if len(raw) > 72:
        raw = raw[:72]

    return pwd_context.hash(raw)


def create_access_token(user_id: int, expires_minutes: int = 60 * 24):
    expire = datetime.utcnow() + timedelta(minutes=expires_minutes)
    to_encode = {"sub": str(user_id), "exp": expire}
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


@router.post("/register", response_model=user_schemas.UserRead, status_code=201)
def register(
    body: auth_schemas.RegisterRequest,
    db: Session = Depends(get_db),
):
    existing = db.query(models.User).filter(
        models.User.email == body.email
    ).first()
    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email sudah terdaftar.",
        )

    # cari role warga (boleh diubah)
    warga_role = db.query(models.Role).filter(
        models.Role.name == "warga"
    ).first()

    user = models.User(
        name=body.name,
        email=body.email,
        password_hash=hash_password(body.password),
        nik=body.nik,
        phone=body.phone,
        address=body.address,
        role_id=warga_role.id if warga_role else None,
        status="pending",  # menunggu verifikasi admin
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user


@router.post("/login", response_model=auth_schemas.TokenResponse)
def login(
    body: auth_schemas.LoginRequest,
    db: Session = Depends(get_db),
):
    user = db.query(models.User).filter(
        models.User.email == body.email
    ).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email atau password salah.",
        )

    if not verify_password(body.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email atau password salah.",
        )

    if user.status not in ("diterima", "active"):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Akun belum aktif. Hubungi admin.",
        )

    token = create_access_token(user.id)
    return auth_schemas.TokenResponse(token=token)


@router.get("/me", response_model=user_schemas.UserRead)
def me(current_user: models.User = Depends(get_current_user)):
    return current_user
