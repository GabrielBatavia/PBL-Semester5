# app/schemas/users.py
from pydantic import BaseModel, EmailStr


class RoleRead(BaseModel):
    id: int
    name: str
    display_name: str | None

    class Config:
        orm_mode = True


class UserBase(BaseModel):
    name: str
    email: EmailStr
    nik: str | None = None
    phone: str | None = None
    address: str | None = None
    status: str | None = None


class UserCreate(UserBase):
    password: str
    role_id: int | None = None


class UserUpdate(BaseModel):
    name: str | None = None
    role_id: int | None = None
    status: str | None = None


class UserRead(UserBase):
    id: int
    role: RoleRead | None = None

    class Config:
        orm_mode = True
