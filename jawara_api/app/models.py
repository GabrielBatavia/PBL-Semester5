# jawara_api/app/models.py

from sqlalchemy import (
    Column, String, ForeignKey, DateTime, Text, Float,  Integer, Date, Boolean
)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from sqlalchemy.dialects.mysql import BIGINT as MySQLBigInt
from datetime import datetime, timezone

from .db import Base



def utcnow():
    return datetime.now(timezone.utc)

# =========================
# ROLE
# =========================
class Role(Base):
    __tablename__ = "roles"

    id = Column(MySQLBigInt(unsigned=True), primary_key=True, index=True)
    name = Column(String(50), unique=True, nullable=False)
    display_name = Column(String(100), nullable=True)

    users = relationship("User", back_populates="role")


# =========================
# USER
# =========================
class User(Base):
    __tablename__ = "users"

    id = Column(MySQLBigInt(unsigned=True), primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    email = Column(String(255), unique=True, index=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    nik = Column(String(50), nullable=True)
    phone = Column(String(50), nullable=True)
    address = Column(String(255), nullable=True)

    role_id = Column(MySQLBigInt(unsigned=True), ForeignKey("roles.id"), nullable=True)
    status = Column(String(50), default="pending")

    created_at = Column(DateTime, default=utcnow)
    updated_at = Column(DateTime, default=utcnow, onupdate=utcnow)

    role = relationship("Role", back_populates="users")

    logs = relationship("ActivityLog", back_populates="actor")

    marketplace_items = relationship(
        "MarketplaceItem",
        back_populates="owner",
        cascade="all, delete-orphan",
    )

    citizen_messages = relationship(
        "CitizenMessage",
        back_populates="user",
        cascade="all, delete-orphan",
    )

    kegiatan = relationship("Kegiatan", back_populates="created_by")


# =========================
# ACTIVITY LOG
# =========================
class ActivityLog(Base):
    __tablename__ = "activity_logs"

    id = Column(MySQLBigInt(unsigned=True), primary_key=True, index=True)
    description = Column(Text, nullable=False)
    actor_id = Column(MySQLBigInt(unsigned=True), ForeignKey("users.id"), nullable=False)
    created_at = Column(DateTime, default=utcnow)

    actor = relationship("User", back_populates="logs")


# =========================
# MARKETPLACE
# =========================
class MarketplaceItem(Base):
    __tablename__ = "marketplace_items"

    id = Column(MySQLBigInt(unsigned=True), primary_key=True, index=True)
    title = Column(String(200), nullable=False)
    description = Column(Text, nullable=True)
    price = Column(Float, nullable=False)
    unit = Column(String(50), nullable=True)
    image_url = Column(Text, nullable=True)

    # 🔹 class hasil AI / pilihan user
    veggie_class = Column(String(100), nullable=True)

    owner_id = Column(MySQLBigInt(unsigned=True), ForeignKey("users.id"), nullable=False)

    created_at = Column(DateTime, default=utcnow)
    updated_at = Column(DateTime, default=utcnow, onupdate=utcnow)

    owner = relationship("User", back_populates="marketplace_items")



# =========================
# CITIZEN MESSAGES
# =========================
class CitizenMessage(Base):
    __tablename__ = "citizen_messages"

    id = Column(MySQLBigInt(unsigned=True), primary_key=True, index=True)
    user_id = Column(MySQLBigInt(unsigned=True), ForeignKey("users.id"), nullable=False)

    title = Column(String(200), nullable=False)
    content = Column(Text, nullable=False)
    status = Column(String(50), default="pending")
    created_at = Column(DateTime, server_default=func.now())

    user = relationship("User", back_populates="citizen_messages")



# =========================
# KEGIATAN
# =========================

class Kegiatan(Base):
    __tablename__ = "activities" 

    # pakai tipe yang sama seperti tabel lain (BIGINT unsigned)
    id = Column(MySQLBigInt(unsigned=True), primary_key=True, index=True)

    # mapping kolom: atribut Python → nama kolom di DB
    nama = Column("name", String(200), nullable=False)
    kategori = Column("category", String(100), nullable=True)
    pj = Column("pic_name", String(100), nullable=True)
    lokasi = Column("location", String(200), nullable=True)
    tanggal = Column("date", Date, nullable=False)
    deskripsi = Column("description", Text, nullable=True)

    image_url = Column("image_url", Text, nullable=True)

    created_by_id = Column(
        "created_by",
        MySQLBigInt(unsigned=True),
        ForeignKey("users.id"),
        nullable=False,
    )
    created_by = relationship("User", back_populates="kegiatan")

    created_at = Column(DateTime, default=utcnow)
    updated_at = Column(DateTime, default=utcnow, onupdate=utcnow)

    # kolom baru untuk soft delete, kita tambahkan di DB (langkah 2)
    is_deleted = Column(Boolean, default=False, nullable=False)