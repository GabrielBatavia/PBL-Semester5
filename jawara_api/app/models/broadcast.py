# app/models/broadcast.py
from sqlalchemy import Column, String, Text, DateTime, ForeignKey, func
from sqlalchemy.dialects.mysql import BIGINT
from ..db import Base
from sqlalchemy.orm import relationship

class Broadcast(Base):
    __tablename__ = "broadcasts"

    id = Column(BIGINT(unsigned=True), primary_key=True, autoincrement=True, index=True)
    title = Column(String(200), nullable=False)
    content = Column(Text, nullable=False)
    sender_id = Column(BIGINT(unsigned=True), ForeignKey("users.id"), nullable=True, index=True)
    published_at = Column(DateTime, nullable=True, server_default=func.current_timestamp())
    image_url = Column(Text, nullable=True)
    document_name = Column(String(200), nullable=True)
    document_url = Column(Text, nullable=True)
    target_scope = Column(String(50), nullable=True)
    created_at = Column(DateTime, nullable=True, server_default=func.current_timestamp())
    updated_at = Column(DateTime, nullable=True, server_default=func.current_timestamp(), onupdate=func.current_timestamp())

    # relationship back to User
    sender = relationship("User", back_populates="broadcasts", lazy="joined")