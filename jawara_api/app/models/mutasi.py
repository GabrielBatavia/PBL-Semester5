from sqlalchemy import (
    Column, Integer, String, ForeignKey, DateTime, Text, Float, Enum, 
)
from sqlalchemy.orm import relationship
from datetime import datetime

from ..db import Base

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

    family = relationship("Family", back_populates="mutations")
