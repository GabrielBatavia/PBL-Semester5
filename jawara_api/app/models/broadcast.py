from sqlalchemy import Column, BigInteger, String, Text, DateTime, ForeignKey, func
from sqlalchemy.orm import relationship
from ..db import Base

class Broadcast(Base):
    __tablename__ = "broadcasts"

    id = Column(BigInteger, primary_key=True, autoincrement=True)

    title = Column(String(200), nullable=False)
    content = Column(Text, nullable=False)

    sender_id = Column(
        BigInteger,
        ForeignKey("users.id", ondelete="SET NULL", onupdate="CASCADE"),
        nullable=True,
        index=True
    )

    published_at = Column(DateTime, server_default=func.now(), nullable=True)

    image_url = Column(Text, nullable=True)
    document_name = Column(String(200), nullable=True)
    document_url = Column(Text, nullable=True)

    target_scope = Column(String(50), nullable=True)

    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    # Relasi ke User
    sender = relationship("User", back_populates="broadcasts")