from sqlalchemy import Column, String, DateTime, Integer, Text
from sqlalchemy.dialects.mysql import BIGINT
from sqlalchemy.sql import func

from ..db import Base


class PaymentChannel(Base):
    __tablename__ = "payment_channels"

    id = Column(BIGINT(unsigned=True), primary_key=True, autoincrement=True, index=True)
    name = Column(String(255), nullable=False)
    type = Column(String(50), nullable=False)

    account_name = Column(String(255), nullable=False)
    account_number = Column(String(100), nullable=False)

    bank_name = Column(String(100), nullable=True)
    qris_image_url = Column(Text, nullable=True)

    is_active = Column(Integer, default=1)

    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())
