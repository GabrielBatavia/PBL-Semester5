# app/routers/auth.py

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from jose import jwt
from datetime import datetime, timedelta, timezone
import hashlib

from ..db import SessionLocal
from .. import models
from ..schemas import auth as auth_schemas, users as user_schemas
from ..deps import get_db, get_current_user, SECRET_KEY, ALGORITHM

router = APIRouter(prefix="/auth", tags=["Auth"])


# ============================================================
#   PASSWORD: PAKE PLAIN TEXT (TIDAK DI HASH)
# ============================================================

def hash_password(password: str) -> str:
    """
    Hash password using SHA256 + bcrypt
    SHA256 ensures consistent length (64 hex chars) before bcrypt
    """
    # Pre-hash with SHA256 to handle any length password
    prehashed = hashlib.sha256(password.encode('utf-8')).hexdigest()
    # Then hash with bcrypt (prehashed is always 64 chars, safe for bcrypt)
    return pwd_context.hash(prehashed)


def verify_password(plain: str, hashed: str) -> bool:
    """
    Verify password using SHA256 + bcrypt
    
    Special handling for legacy passwords:
    - If hash starts with $2b$, try direct bcrypt verify first (legacy)
    - If that fails, try SHA256 + bcrypt (new method)
    """
    try:
        # Try new method (SHA256 + bcrypt)
        prehashed = hashlib.sha256(plain.encode('utf-8')).hexdigest()
        if pwd_context.verify(prehashed, hashed):
            return True
    except Exception:
        pass
    
    try:
        # Try legacy method (direct bcrypt) for old passwords
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
            status_code=400,
            detail="Email sudah terdaftar"
        )
    
    # Hash password using SHA256 + bcrypt
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
    user = db.query(models.User).filter(
        models.User.email == body.email
    ).first()
    
    if not user:
        raise HTTPException(
            status_code=401,
            detail="Email atau password salah"
        )
    
    # Verify password (handles both legacy and new hashes)
    if not verify_password(body.password, user.password_hash):
        raise HTTPException(
            status_code=401,
            detail="Email atau password salah"
        )
    
    # Auto-upgrade legacy passwords to new format
    if user.password_hash and not user.password_hash.startswith("$2b$12$"):
        # Re-hash password with new method
        user.password_hash = hash_password(body.password)
        db.commit()
    
    # Create access token
    token = create_access_token(user.id)
    
    return {
        "access_token": token,
        "token_type": "bearer",
        "user": {
            "id": user.id,
            "name": user.name,
            "email": user.email,
        }
    }


# ============================================================
#   CURRENT USER
# ============================================================

@router.get("/me", response_model=user_schemas.UserRead)
def get_me(current_user: models.User = Depends(get_current_user)):
    return current_user