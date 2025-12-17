from sqlalchemy import Column, String, Date, DateTime, ForeignKey, DECIMAL
from sqlalchemy.dialects.mysql import BIGINT
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from ..db import Base


class Bill(Base):
    __tablename__ = "bills"

    id = Column(BIGINT(unsigned=True), primary_key=True, autoincrement=True, index=True)
    family_id = Column(BIGINT(unsigned=True), ForeignKey("families.id"), nullable=True, index=True)
    category_id = Column(BIGINT(unsigned=True), ForeignKey("fee_categories.id"), nullable=True, index=True)

    code = Column(String(100), unique=True, nullable=False)
    amount = Column(DECIMAL(18, 2), nullable=False)

    period_start = Column(Date, nullable=False)
    period_end = Column(Date, nullable=True)
    status = Column(String(50), default="belum_lunas")

    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    family = relationship("Family")  # tanpa back_populates biar nggak maksa Family punya bills
    category = relationship("FeeCategory", back_populates="bills")
