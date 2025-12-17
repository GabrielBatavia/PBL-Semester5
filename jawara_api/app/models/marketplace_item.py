from sqlalchemy import Column, String, Text, Float, DateTime, ForeignKey
from sqlalchemy.dialects.mysql import BIGINT
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from ..db import Base


class MarketplaceItem(Base):
    __tablename__ = "marketplace_items"

    id = Column(BIGINT(unsigned=True), primary_key=True, autoincrement=True, index=True)
    title = Column(String(200), nullable=False)
    description = Column(Text, nullable=True)
    price = Column(Float, nullable=False)
    unit = Column(String(50), nullable=True)
    image_url = Column(Text, nullable=True)

    veggie_class = Column(String(100), nullable=True)

    owner_id = Column(BIGINT(unsigned=True), ForeignKey("users.id"), nullable=False, index=True)

    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    owner = relationship("User", back_populates="marketplace_items")
