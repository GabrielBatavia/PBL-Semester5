# app/db.py
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# SESUAIKAN dengan pengaturan phpMyAdmin-mu
# contoh: user root tanpa password, db: jawara_db
DATABASE_URL = "mysql+pymysql://root:@localhost/jawara"

engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
