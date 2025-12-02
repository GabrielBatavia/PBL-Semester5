from sqlalchemy import (
    Column, Integer, String, ForeignKey, DateTime, Text, Float
)
from sqlalchemy.orm import relationship
from datetime import datetime

from .db import Base


class Role(Base):
    __tablename__ = "roles"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50), unique=True, nullable=False)         # admin, ketua_rt, dst
    display_name = Column(String(100), nullable=True)

    users = relationship("User", back_populates="role")


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    email = Column(String(255), unique=True, index=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    nik = Column(String(50), nullable=True)
    phone = Column(String(50), nullable=True)
    address = Column(String(255), nullable=True)

    role_id = Column(Integer, ForeignKey("roles.id"), nullable=True)
    status = Column(String(50), default="pending")   # pending / diterima / ditolak / nonaktif

    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(
        DateTime,
        default=datetime.utcnow,
        onupdate=datetime.utcnow
    )

    role = relationship("Role", back_populates="users")
    logs = relationship("ActivityLog", back_populates="actor")

    marketplace_items = relationship(
        "MarketplaceItem",
        back_populates="owner",
        cascade="all, delete-orphan",
    )


class ActivityLog(Base):
    __tablename__ = "activity_logs"

    id = Column(Integer, primary_key=True, index=True)
    description = Column(Text, nullable=False)
    actor_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    actor = relationship("User", back_populates="logs")


class MarketplaceItem(Base):
    __tablename__ = "marketplace_items"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(200), nullable=False)
    description = Column(Text, nullable=True)
    price = Column(Float, nullable=False)           # ⬅️ pakai Float
    unit = Column(String(50), nullable=True)        # kg / ikat / pcs
    image_url = Column(Text, nullable=True)

    owner_id = Column(Integer, ForeignKey("users.id"), nullable=False)

    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    owner = relationship("User", back_populates="marketplace_items")

class Family(Base):
    __tablename__ = "families"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    house_id = Column(Integer, ForeignKey("houses.id"), nullable=True)
    status = Column(String, default="aktif")

    # Relationship
    house = relationship("House", back_populates="families") 
    residents = relationship("Resident", back_populates="family") 

class House(Base):
    __tablename__ = "houses"

    id = Column(Integer, primary_key=True, index=True)
    address = Column(String(255), nullable=False)
    area = Column(String(50), nullable=True)
    status = Column(String(255), nullable=False)
    # relasi ke Family
    families = relationship("Family", back_populates="house")
    

class Resident(Base):
    __tablename__ = "residents"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    nik = Column(String(100), nullable=True)
    gender = Column(String(50), nullable=True)
    birth_date = Column(String(50), nullable=True)
    job = Column(String(100), nullable=True)
    gender = Column(String(1), nullable=True)
    user_id = Column(Integer, nullable=True)
    family_id = Column(Integer, ForeignKey("families.id", ondelete="CASCADE"))
    family = relationship("Family", back_populates="residents")
