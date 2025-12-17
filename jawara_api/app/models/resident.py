# app/models/family.py

from sqlalchemy import (
    Column, Integer, String, ForeignKey, DateTime, Text, Float, Enum, 
)
from sqlalchemy.orm import relationship
from datetime import datetime

from ..db import Base

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