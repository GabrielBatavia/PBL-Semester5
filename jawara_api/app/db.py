# app/db.py
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
import os

# Pilih database berdasarkan environment variable TESTING
if os.getenv("TESTING") == "1":
    DATABASE_URL = "mysql+pymysql://root:@localhost/jawara_test"
else:
    DATABASE_URL = "mysql+pymysql://root:@localhost/jawara"

engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()