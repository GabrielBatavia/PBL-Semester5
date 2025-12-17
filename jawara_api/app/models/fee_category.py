from sqlalchemy import Column, String, DateTime, Integer, DECIMAL
from sqlalchemy.dialects.mysql import BIGINT
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from ..db import Base


class FeeCategory(Base):
    __tablename__ = "fee_categories"

    id = Column(BIGINT(unsigned=True), primary_key=True, autoincrement=True, index=True)
    name = Column(String(255), nullable=False)
    type = Column(String(50), nullable=False)
    default_amount = Column(DECIMAL(18, 2), nullable=False)
    is_active = Column(Integer, default=1)

    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    bills = relationship("Bill", back_populates="category")
