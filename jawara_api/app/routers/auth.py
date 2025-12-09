# app/routers/auth.py

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from jose import jwt
from datetime import datetime, timedelta

from ..db import SessionLocal
from .. import models
from ..schemas import auth as auth_schemas, users as user_schemas
from ..deps import get_db, get_current_user, SECRET_KEY, ALGORITHM

router = APIRouter(prefix="/auth", tags=["Auth"])


# ============================================================
#   PASSWORD: PAKE PLAIN TEXT (TIDAK DI HASH)
# ============================================================

from passlib.context import CryptContext

# Gunakan bcrypt
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain: str, stored_hash: str) -> bool:
    """Cek apakah password plain cocok dengan hash."""
    if stored_hash is None:
        return False
    return pwd_context.verify(plain, stored_hash)

def hash_password(password: str) -> str:
    """Hash password sebelum disimpan."""
    return pwd_context.hash(password)



# ============================================================
#   TOKEN JWT
# ============================================================

def create_access_token(user_id: int, expires_minutes: int = 60 * 24):
    expire = datetime.utcnow() + timedelta(minutes=expires_minutes)
    to_encode = {"sub": str(user_id), "exp": expire}
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


# ============================================================
#   REGISTER
# ============================================================

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

    # role default = warga
    role = db.query(models.Role).filter(models.Role.name == "warga").first()

    new_user = models.User(
        name=body.name,
        email=body.email,
        password_hash=hash_password(body.password),
        nik=body.nik,
        phone=body.phone,
        address=body.address,
        role_id=role.id if role else None,
        status="active",         # ← penting: supaya user bisa login
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user


# ============================================================
#   LOGIN
# ============================================================

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

    # cek password plain
    if not verify_password(body.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email atau password salah.",
        )

    # pastikan status user aktif
    if user.status not in ("active", "diterima"):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Akun belum aktif.",
        )

    # buat token JWT
    token = create_access_token(user.id)
    return auth_schemas.TokenResponse(token=token)


# ============================================================
#   CURRENT USER
# ============================================================

@router.get("/me", response_model=user_schemas.UserRead)
def get_me(current_user: models.User = Depends(get_current_user)):
    return current_user