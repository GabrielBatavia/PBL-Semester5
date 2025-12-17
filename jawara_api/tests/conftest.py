# tests/conftest.py
import sys
from pathlib import Path

# Arahkan ke folder root project (yang berisi folder app/)
ROOT_DIR = Path(__file__).resolve().parents[1]

if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

import pytest
from fastapi.testclient import TestClient

from app.main import app
from app.db import SessionLocal
from app import models
from app.routers.auth import hash_password, create_access_token


@pytest.fixture
def db():
    """Session DB per test."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@pytest.fixture
def client():
    """FastAPI TestClient untuk panggil endpoint tanpa server beneran."""
    return TestClient(app)


@pytest.fixture
def warga_role(db):
    """Pastikan role 'warga' ada di DB, kalau belum ya dibuat."""
    role = db.query(models.Role).filter(models.Role.name == "warga").first()
    if not role:
        role = models.Role(name="warga", display_name="Warga")
        db.add(role)
        db.commit()
        db.refresh(role)
    return role


@pytest.fixture
def test_user(db, warga_role):
    """
    User default untuk testing (status sudah 'diterima').
    Semua data terkait user ini dibersihkan di akhir test.
    """
    email = "test_user_pytest@example.com"

    # Bersihkan sisa user lama kalau ada
    existing = db.query(models.User).filter(models.User.email == email).first()
    if existing:
        db.query(models.ActivityLog).filter(
            models.ActivityLog.actor_id == existing.id
        ).delete()
        db.query(models.Kegiatan).filter(
            models.Kegiatan.created_by_id == existing.id
        ).delete()
        db.query(models.MarketplaceItem).filter(
            models.MarketplaceItem.owner_id == existing.id
        ).delete()
        db.query(models.CitizenMessage).filter(
            models.CitizenMessage.user_id == existing.id
        ).delete()
        db.delete(existing)
        db.commit()

    user = models.User(
        name="Test User",
        email=email,
        password_hash=hash_password("password123"),
        status="diterima",
        role_id=warga_role.id,
    )
    db.add(user)
    db.commit()
    db.refresh(user)

    try:
        yield user
    finally:
        # Bersihkan data terkait user test
        db.query(models.ActivityLog).filter(
            models.ActivityLog.actor_id == user.id
        ).delete()
        db.query(models.Kegiatan).filter(
            models.Kegiatan.created_by_id == user.id
        ).delete()
        db.query(models.MarketplaceItem).filter(
            models.MarketplaceItem.owner_id == user.id
        ).delete()
        db.query(models.CitizenMessage).filter(
            models.CitizenMessage.user_id == user.id
        ).delete()
        db.delete(user)
        db.commit()


@pytest.fixture
def auth_header(test_user):
    """Header Authorization: Bearer <token> untuk user test."""
    token = create_access_token(test_user.id)
    return {"Authorization": f"Bearer {token}"}
