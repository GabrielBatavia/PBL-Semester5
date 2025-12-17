# app/models/family.py

from sqlalchemy import (
    Column, Integer, String, ForeignKey, DateTime, Text, Float, Enum, 
)
from sqlalchemy.orm import relationship
from datetime import datetime

from ..db import Base

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