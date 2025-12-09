from sqlalchemy import (
    Column, Integer, String, ForeignKey, DateTime, Text, Float, DECIMAL, Date, BigInteger
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


# ==========================================
# MODUL KEUANGAN - MODELS
# ==========================================

class FeeCategory(Base):
    """Model untuk kategori iuran"""
    __tablename__ = "fee_categories"
    
    id = Column(BigInteger, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    type = Column(String(50), nullable=False)  # bulanan, insidental, sukarela
    default_amount = Column(DECIMAL(18, 2), nullable=False)
    is_active = Column(Integer, default=1)  # 1=active, 0=inactive
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    bills = relationship("Bill", back_populates="category")


class Family(Base):
    """Model untuk data keluarga"""
    __tablename__ = "families"
    
    id = Column(BigInteger, primary_key=True, index=True)
    head_name = Column(String(255), nullable=False)  # ✅ Ganti dari family_head ke head_name
    address = Column(String(500), nullable=True)
    phone = Column(String(50), nullable=True)
    status = Column(String(50), default="aktif")  # aktif, nonaktif
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    bills = relationship("Bill", back_populates="family")
    income_transactions = relationship("IncomeTransaction", back_populates="family")


class Bill(Base):
    """Model untuk tagihan"""
    __tablename__ = "bills"
    
    id = Column(BigInteger, primary_key=True, index=True)
    family_id = Column(BigInteger, ForeignKey("families.id"), nullable=True)
    category_id = Column(BigInteger, ForeignKey("fee_categories.id"), nullable=True)
    code = Column(String(100), unique=True, nullable=False)
    amount = Column(DECIMAL(18, 2), nullable=False)
    period_start = Column(Date, nullable=False)
    period_end = Column(Date, nullable=True)
    status = Column(String(50), default="belum_lunas")  # belum_lunas, lunas, terlambat
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    family = relationship("Family", back_populates="bills")
    category = relationship("FeeCategory", back_populates="bills")


class IncomeTransaction(Base):
    """Model untuk transaksi pemasukan"""
    __tablename__ = "income_transactions"
    
    id = Column(BigInteger, primary_key=True, index=True)
    category_id = Column(BigInteger, ForeignKey("fee_categories.id"), nullable=True)
    family_id = Column(BigInteger, ForeignKey("families.id"), nullable=True)
    name = Column(String(255), nullable=False)
    type = Column(String(50), nullable=True)  # iuran, donasi, lain_lain
    amount = Column(DECIMAL(18, 2), nullable=False)
    date = Column(Date, nullable=False)
    proof_image_url = Column(Text, nullable=True)
    created_by = Column(BigInteger, ForeignKey("users.id"), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    family = relationship("Family", back_populates="income_transactions")
    creator = relationship("User")


class ExpenseTransaction(Base):
    """Model untuk transaksi pengeluaran"""
    __tablename__ = "expense_transactions"
    
    id = Column(BigInteger, primary_key=True, index=True)
    category = Column(String(100), nullable=True)  # ✅ Ini STRING bukan ForeignKey
    name = Column(String(255), nullable=False)
    amount = Column(DECIMAL(18, 2), nullable=False)
    date = Column(Date, nullable=False)
    proof_image_url = Column(Text, nullable=True)
    created_by = Column(BigInteger, ForeignKey("users.id"), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    creator = relationship("User")


class PaymentChannel(Base):
    """Model untuk channel transfer"""
    __tablename__ = "payment_channels"
    
    id = Column(BigInteger, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    type = Column(String(50), nullable=False)  # bank, ewallet, qris
    account_name = Column(String(255), nullable=False)
    account_number = Column(String(100), nullable=False)
    bank_name = Column(String(100), nullable=True)
    qris_image_url = Column(Text, nullable=True)
    is_active = Column(Integer, default=1)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


class Activity(Base):
    """Model untuk kegiatan warga"""
    __tablename__ = "activities"
    
    id = Column(BigInteger, primary_key=True, index=True)
    name = Column(String(200), nullable=False)
    category = Column(String(100), nullable=True)  # kebersihan, keagamaan, pendidikan, olahraga, dll
    pic_name = Column(String(150), nullable=True)  # Penanggung jawab
    location = Column(String(200), nullable=True)
    date = Column(Date, nullable=False)
    description = Column(Text, nullable=True)
    image_url = Column(Text, nullable=True)
    created_by = Column(BigInteger, ForeignKey("users.id"), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    creator = relationship("User")
