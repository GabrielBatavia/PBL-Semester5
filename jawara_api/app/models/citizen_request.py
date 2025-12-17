from sqlalchemy import Column, Integer, String, Text, BigInteger, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.db import Base

class CitizenRequest(Base):
    __tablename__ = "citizen_registration_requests"

    id = Column(BigInteger, primary_key=True, index=True)
    name = Column(String(150), nullable=False)
    nik = Column(String(20), nullable=False)
    email = Column(String(150), nullable=False)
    gender = Column(String(1), nullable=True)
    identity_image_url = Column(Text, nullable=True)
    status = Column(String(20), default="pending")
    processed_by = Column(BigInteger,ForeignKey("users.id"), nullable=True)
    processed_at = Column(DateTime, nullable=True)

    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    processed_by_user = relationship("User")