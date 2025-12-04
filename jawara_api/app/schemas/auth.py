# app/schemas/auth.py
from pydantic import BaseModel, EmailStr
from typing import Optional


class TokenResponse(BaseModel):
    token: str
    token_type: str = "bearer"


class LoginRequest(BaseModel):
    email: str
    password: str


class RegisterRequest(BaseModel):
    name: str
    email: EmailStr
    password: str
    nik: Optional[str] = None
    phone: Optional[str] = None
    address: Optional[str] = None
