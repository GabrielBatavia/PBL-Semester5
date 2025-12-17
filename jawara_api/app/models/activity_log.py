from sqlalchemy import Column, Text, DateTime, ForeignKey
from sqlalchemy.dialects.mysql import BIGINT
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from ..db import Base


class ActivityLog(Base):
    __tablename__ = "activity_logs"

    id = Column(BIGINT(unsigned=True), primary_key=True, autoincrement=True, index=True)
    description = Column(Text, nullable=False)

    actor_id = Column(BIGINT(unsigned=True), ForeignKey("users.id"), nullable=False, index=True)
    created_at = Column(DateTime, server_default=func.now())

    actor = relationship("User", back_populates="logs")
