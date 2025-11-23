# app/schemas/auth.py
from pydantic import BaseModel, EmailStr


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
    nik: str | None = None
    phone: str | None = None
    address: str | None = None
