from .broadcast import Broadcast
from .users import User
from .roles import Role

import sys
from pathlib import Path


from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Text, Float, Date, DECIMAL, BigInteger
from sqlalchemy.orm import relationship
from datetime import datetime
from ..db import Base

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
    price = Column(Float, nullable=False)
    unit = Column(String(50), nullable=True)
    image_url = Column(Text, nullable=True)

    owner_id = Column(Integer, ForeignKey("users.id"), nullable=False)

    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    owner = relationship("User", back_populates="marketplace_items")

class ExpenseTransaction(Base):
    __tablename__ = "expense_transactions"
    
    id = Column(BigInteger, primary_key=True, index=True)
    category = Column(String(100))
    name = Column(String(150), nullable=False)
    amount = Column(DECIMAL(18, 2), nullable=False)
    date = Column(Date, nullable=False)
    proof_image_url = Column(Text)
    created_by = Column(BigInteger, ForeignKey("users.id"))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class PaymentChannel(Base):
    __tablename__ = "payment_channels"
    
    id = Column(BigInteger, primary_key=True, index=True)
    name = Column(String(150), nullable=False)
    type = Column(String(30), nullable=False)  # transfer, ewallet, qris
    account_name = Column(String(150))
    account_number = Column(String(100))
    bank_name = Column(String(100))
    qris_image_url = Column(Text)
    is_active = Column(Integer, default=1)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class FeeCategory(Base):
    __tablename__ = "fee_categories"
    
    id = Column(BigInteger, primary_key=True, index=True)
    name = Column(String(150), nullable=False)
    type = Column(String(50), nullable=False)
    default_amount = Column(DECIMAL(18, 2), default=0)
    is_active = Column(Integer, default=1)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class Family(Base):
    __tablename__ = "families"
    
    id = Column(BigInteger, primary_key=True, index=True)
    name = Column(String(150), nullable=False)
    house_id = Column(BigInteger)
    status = Column(String(20), default="aktif")
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class Bill(Base):
    __tablename__ = "bills"
    
    id = Column(BigInteger, primary_key=True, index=True)
    family_id = Column(BigInteger, ForeignKey("families.id"))
    category_id = Column(BigInteger, ForeignKey("fee_categories.id"))
    code = Column(String(50), nullable=False)
    amount = Column(DECIMAL(18, 2), nullable=False)
    period_start = Column(Date, nullable=False)
    period_end = Column(Date)
    status = Column(String(20), default="belum_lunas")
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    family = relationship("Family")
    category = relationship("FeeCategory")

class IncomeTransaction(Base):
    __tablename__ = "income_transactions"
    
    id = Column(BigInteger, primary_key=True, index=True)
    category_id = Column(BigInteger)
    family_id = Column(BigInteger)
    name = Column(String(150), nullable=False)
    type = Column(String(100))
    amount = Column(DECIMAL(18, 2), nullable=False)
    date = Column(Date, nullable=False)
    proof_image_url = Column(Text)
    created_by = Column(BigInteger, ForeignKey("users.id"))
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