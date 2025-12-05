from sqlalchemy import Column, BigInteger, String, DateTime
from sqlalchemy.orm import relationship
from ..db import Base

class Role(Base):
    __tablename__ = "roles"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    name = Column(String(255), nullable=False)
    display_name = Column(String(255), nullable=True)

    created_at = Column(DateTime, nullable=True)
    updated_at = Column(DateTime, nullable=True)

    # Relasi ke users
    users = relationship("User", back_populates="roles")