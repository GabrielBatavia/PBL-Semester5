# app/models/kegiatan.py
from sqlalchemy import Column, String, Text, Date, DateTime, ForeignKey
from sqlalchemy.dialects.mysql import BIGINT
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from ..db import Base


class Kegiatan(Base):
    __tablename__ = "activities"

    id = Column(BIGINT(unsigned=True), primary_key=True, autoincrement=True, index=True)

    name = Column(String(200), nullable=False)
    category = Column(String(100), nullable=True)
    pic_name = Column(String(150), nullable=True)
    location = Column(String(200), nullable=True)
    date = Column(Date, nullable=False)
    description = Column(Text, nullable=True)
    image_url = Column(Text, nullable=True)

    created_by = Column(BIGINT(unsigned=True), ForeignKey("users.id"), nullable=False, index=True)

    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    creator = relationship("User", back_populates="kegiatan_list")
