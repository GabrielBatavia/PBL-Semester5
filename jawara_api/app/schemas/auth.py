# app/schemas/auth.py
from pydantic import BaseModel, EmailStr
from typing import Optional
from app.models.users import User


class UserResponse(BaseModel):
    id: int
    name: str
    email: str


class TokenResponse(BaseModel):
    access_token: str  
    token_type: str = "bearer"
    user: Optional[UserResponse] = None  


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
