# jawara_api/app/models.py

from sqlalchemy import (
    Column, Integer, String, ForeignKey, DateTime, Text, Float, Enum, Date, Boolean, Float,DECIMAL, BigInteger
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
class Family(Base):
    __tablename__ = "families"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    house_id = Column(Integer, ForeignKey("houses.id"), nullable=True)
    status = Column(String, default="aktif")

    # Relationship
    house = relationship("House", back_populates="families") 
    residents = relationship("Resident", back_populates="family") 
    mutations = relationship("Mutasi", back_populates="family")


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

class Mutasi(Base):
    __tablename__ = "mutations"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    family_id = Column(Integer, ForeignKey("families.id", ondelete="CASCADE"))
    old_address = Column(String(255))
    new_address = Column(String(255))
    mutation_type = Column(
        Enum("masuk", "keluar", "pindah", name="mutation_type"),
        nullable=False
    )
    reason = Column(Text)
    date = Column(DateTime, nullable=False)
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
    family = relationship("Family", back_populates="mutations")
