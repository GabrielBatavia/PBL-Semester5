from sqlalchemy import Column, String, Date, DateTime, ForeignKey, DECIMAL, Text
from sqlalchemy.dialects.mysql import BIGINT
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from ..db import Base


class ExpenseTransaction(Base):
    __tablename__ = "expense_transactions"

    id = Column(BIGINT(unsigned=True), primary_key=True, autoincrement=True, index=True)
    category = Column(String(100), nullable=True)
    name = Column(String(255), nullable=False)
    amount = Column(DECIMAL(18, 2), nullable=False)
    date = Column(Date, nullable=False)

    proof_image_url = Column(Text, nullable=True)

    created_by = Column(BIGINT(unsigned=True), ForeignKey("users.id"), nullable=True, index=True)

    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    creator = relationship("User")
