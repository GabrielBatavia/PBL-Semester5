from sqlalchemy import (
    Column, Integer, String, ForeignKey, DateTime, Text, Float, Enum, 
)
from sqlalchemy.orm import relationship
from datetime import datetime

from ..db import Base

class House(Base):
    __tablename__ = "houses"

    id = Column(Integer, primary_key=True, index=True)
    address = Column(String(255), nullable=False)
    area = Column(String(50), nullable=True)
    status = Column(String(255), nullable=False)
    # relasi ke Family
    families = relationship("Family", back_populates="house")