from sqlalchemy import Column, BigInteger, String, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from ..db import Base

class User(Base):
    __tablename__ = "users"

    id = Column(BigInteger, primary_key=True, autoincrement=True)

    name = Column(String(255), nullable=True)
    email = Column(String(255), unique=True, index=True, nullable=False)
    password_hash = Column(String(255), nullable=False)

    nik = Column(String(255), nullable=True)
    phone = Column(String(255), nullable=True)
    address = Column(String(255), nullable=True)

    role_id = Column(
        BigInteger,
        ForeignKey("roles.id", ondelete="SET NULL", onupdate="CASCADE"),
        nullable=True
    )

    status = Column(String(50), nullable=True)

    created_at = Column(DateTime, nullable=True)
    updated_at = Column(DateTime, nullable=True)

    # Relasi ke Role
    role = relationship("Role", back_populates="users")

    # Relasi ke Broadcast
    broadcasts = relationship("Broadcast", back_populates="sender")