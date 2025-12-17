from sqlalchemy import Column, String, Date, DateTime, ForeignKey, DECIMAL, Text
from sqlalchemy.dialects.mysql import BIGINT
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from ..db import Base


class IncomeTransaction(Base):
    __tablename__ = "income_transactions"

    id = Column(BIGINT(unsigned=True), primary_key=True, autoincrement=True, index=True)
    category_id = Column(BIGINT(unsigned=True), ForeignKey("fee_categories.id"), nullable=True, index=True)
    family_id = Column(BIGINT(unsigned=True), ForeignKey("families.id"), nullable=True, index=True)

    name = Column(String(255), nullable=False)
    type = Column(String(50), nullable=True)
    amount = Column(DECIMAL(18, 2), nullable=False)
    date = Column(Date, nullable=False)

    proof_image_url = Column(Text, nullable=True)

    created_by = Column(BIGINT(unsigned=True), ForeignKey("users.id"), nullable=True, index=True)

    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    category = relationship("FeeCategory")
    family = relationship("Family")
    creator = relationship("User")
