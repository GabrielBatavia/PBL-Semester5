# app/models/users.py
from sqlalchemy import Column, String, DateTime, ForeignKey
from sqlalchemy.dialects.mysql import BIGINT
from sqlalchemy.orm import relationship
from ..db import Base

class User(Base):
    __tablename__ = "users"

    id = Column(BIGINT(unsigned=True), primary_key=True, autoincrement=True, index=True)
    name = Column(String(255))
    email = Column(String(255), unique=True, index=True)
    password_hash = Column(String(255))
    nik = Column(String(255))
    phone = Column(String(255))
    address = Column(String(255))
    role_id = Column(BIGINT(unsigned=True), ForeignKey("roles.id"))
    status = Column(String(50))
    created_at = Column(DateTime)

    role = relationship("Role", back_populates="users")
    broadcasts = relationship("Broadcast", back_populates="sender", cascade="all,delete-orphan")
    logs = relationship("ActivityLog", back_populates="actor")
    marketplace_items = relationship("MarketplaceItem", back_populates="owner", cascade="all, delete-orphan")
    kegiatan_list = relationship("Kegiatan", back_populates="creator")
