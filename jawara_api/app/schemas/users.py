# app/schemas/users.py
from pydantic import BaseModel, EmailStr
from typing import Optional

class RoleRead(BaseModel):
    id: int
    name: str
    display_name: Optional[str]

    model_config = ConfigDict(from_attributes=True)


class UserBase(BaseModel):
    name: str
    email: EmailStr
    nik: Optional[str] = None
    phone: Optional[str] = None
    address: Optional[str] = None
    status: Optional[str] = None


class UserCreate(UserBase):
    password: str
    role_id: Optional[int] = None


class UserUpdate(BaseModel):
    name: Optional[str] = None
    role_id: Optional[int] = None
    status: Optional[str] = None


class UserRead(UserBase):
    id: int
    role: Optional[RoleRead] = None

    model_config = ConfigDict(from_attributes=True)
