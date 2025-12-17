# app/models/citizen_message.py

from sqlalchemy import Column, String, Text, DateTime, ForeignKey
from sqlalchemy.dialects.mysql import BIGINT
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from ..db import Base


class CitizenMessage(Base):
    __tablename__ = "citizen_messages"

    id = Column(BIGINT(unsigned=True), primary_key=True, autoincrement=True, index=True)
    user_id = Column(BIGINT(unsigned=True), ForeignKey("users.id"), nullable=False, index=True)

    title = Column(String(200), nullable=False)
    content = Column(Text, nullable=False)
    status = Column(String(50), default="pending")

    created_at = Column(DateTime, server_default=func.now())

    user = relationship("User", back_populates="citizen_messages")
