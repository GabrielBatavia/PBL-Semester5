# app/models/family.py

from sqlalchemy import Column, Integer, String, Text, DateTime, Enum, ForeignKey
from sqlalchemy.dialects.mysql import BIGINT
from sqlalchemy.orm import relationship
from datetime import datetime
from ..db import Base

class Mutasi(Base):
    __tablename__ = "mutations"
    __table_args__ = {"mysql_engine": "InnoDB"}

    id = Column(BIGINT(unsigned=True), primary_key=True, index=True, autoincrement=True)
    family_id = Column(BIGINT(unsigned=True), ForeignKey("families.id", ondelete="CASCADE"), nullable=False)

    old_address = Column(String(255))
    new_address = Column(String(255))
    mutation_type = Column(Enum("masuk", "keluar", "pindah", name="mutation_type"), nullable=False)
    reason = Column(Text)
    date = Column(DateTime, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    family = relationship("Family", back_populates="mutations")