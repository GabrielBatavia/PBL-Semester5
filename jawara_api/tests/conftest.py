# tests/conftest.py
import pytest
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from app.db import Base, get_db
from fastapi.testclient import TestClient
from app.main import app
from app.models.broadcast import Broadcast  # <-- import model broadcast

# Database test
DATABASE_URL = "mysql+pymysql://root:@localhost/jawara_test"

# Engine dan session factory
engine = create_engine(DATABASE_URL, echo=False, future=True)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Override dependency FastAPI untuk testing
def override_get_db():
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()

app.dependency_overrides[get_db] = override_get_db

# Fixture setup database
@pytest.fixture(scope="module", autouse=True)
def setup_database():
    # Create all tables (bisa semua atau khusus broadcast)
    Base.metadata.create_all(bind=engine)
    yield
    # Drop tabel broadcast saja
    with engine.begin() as conn:  # pakai begin() supaya auto-commit
        conn.execute(text("SET FOREIGN_KEY_CHECKS=0;"))
        Broadcast.__table__.drop(bind=conn)
        conn.execute(text("SET FOREIGN_KEY_CHECKS=1;"))

# Fixture TestClient FastAPI
@pytest.fixture(scope="module")
def client():
    with TestClient(app) as c:
        yield c