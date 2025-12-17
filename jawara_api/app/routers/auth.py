# app/routers/auth.py

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from jose import jwt
from datetime import datetime, timedelta, timezone
import hashlib

from .. import models
from ..schemas import auth as auth_schemas, users as user_schemas
from ..deps import get_db, get_current_user, SECRET_KEY, ALGORITHM

# IMPORTANT:
# pastikan di file ini memang ada pwd_context (kalau belum, ini juga bisa jadi sumber masalah)
# Kalau kamu sudah punya pwd_context di file lain, biarkan seperti yang kamu pakai.
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

router = APIRouter(prefix="/auth", tags=["Auth"])


# ============================================================
#   PASSWORD (SHA256 + bcrypt) + fallback bcrypt plain
# ============================================================

def hash_password(password: str) -> str:
    prehashed = hashlib.sha256(password.encode("utf-8")).hexdigest()
    return pwd_context.hash(prehashed)


def verify_password(plain: str, hashed: str) -> bool:
    # ✅ bersihkan hash dari DB (spasi, \r, \n)
    hashed = (hashed or "").strip()

    # 1) new method: sha256 + bcrypt
    try:
        prehashed = hashlib.sha256(plain.encode("utf-8")).hexdigest()
        if pwd_context.verify(prehashed, hashed):
            return True
    except Exception:
        pass

    # 2) legacy: bcrypt(plain)
    try:
        if pwd_context.verify(plain, hashed):
            return True
    except Exception:
        pass

    return False


# ============================================================
#   TOKEN JWT
# ============================================================

def create_access_token(user_id: int, expires_minutes: int = 60 * 24):
    expire = datetime.now(timezone.utc) + timedelta(minutes=expires_minutes)
    to_encode = {"sub": str(user_id), "exp": expire}
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


# ============================================================
#   DEBUG helper
# ============================================================

def mask_hash(h: str | None) -> str:
    if not h:
        return "(null)"
    if len(h) <= 12:
        return h
    return f"{h[:8]}...{h[-8:]} (len={len(h)})"


# ============================================================
#   REGISTER
# ============================================================

@router.post("/register", response_model=user_schemas.UserRead, status_code=201)
def register(
    body: auth_schemas.RegisterRequest,
    db: Session = Depends(get_db),
):
    existing = db.query(models.User).filter(models.User.email == body.email).first()

    if existing:
        raise HTTPException(status_code=400, detail="Email sudah terdaftar")

    hashed_pw = hash_password(body.password)

    new_user = models.User(
        name=body.name,
        email=body.email,
        password_hash=hashed_pw,
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
    user = db.query(models.User).filter(models.User.email == body.email).first()

    # DEBUG (email lookup)
    print("[AUTH][LOGIN] email =", body.email)
    print("[AUTH][LOGIN] user_found =", bool(user))

    if not user:
        raise HTTPException(status_code=401, detail="Email atau password salah")

    # DEBUG (hash format)
    print("[AUTH][LOGIN] hash_db =", mask_hash(user.password_hash))
    print("[AUTH][LOGIN] hash_prefix =", (user.password_hash or "")[:4])

    # DEBUG (verify in two modes)
    prehashed = hashlib.sha256(body.password.encode("utf-8")).hexdigest()
    ok_new = False
    ok_legacy = False

    try:
        ok_new = pwd_context.verify(prehashed, user.password_hash)
    except Exception as e:
        print("[AUTH][LOGIN] verify_new_exception =", repr(e))

    try:
        ok_legacy = pwd_context.verify(body.password, user.password_hash)
    except Exception as e:
        print("[AUTH][LOGIN] verify_legacy_exception =", repr(e))

    print("[AUTH][LOGIN] verify_new(sha256+bcrypt) =", ok_new)
    print("[AUTH][LOGIN] verify_legacy(bcrypt_plain) =", ok_legacy)

    ok = ok_new or ok_legacy
    print("[AUTH][LOGIN] verify_final =", ok)

    if not ok:
        raise HTTPException(status_code=401, detail="Email atau password salah")

    # (optional) jangan upgrade pakai startswith("$2b$12$") karena cost bisa beda
    # kalau mau upgrade legacy -> new, sebaiknya pakai flag/version (lebih rapi).
    # Untuk sementara, aku biarkan tidak auto-upgrade supaya tidak bikin bingung.

    token = create_access_token(user.id)

    return {
        "access_token": token,
        "token_type": "bearer",
        "user": {
            "id": user.id,
            "name": user.name,
            "email": user.email,
        },
    }


# ============================================================
#   CURRENT USER
# ============================================================

@router.get("/me", response_model=user_schemas.UserRead)
def get_me(current_user: models.User = Depends(get_current_user)):
    return current_user
