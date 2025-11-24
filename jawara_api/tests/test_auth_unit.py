# tests/test_auth_unit.py
from sqlalchemy.orm import Session

from app.routers.auth import hash_password
from app.schemas.auth import RegisterRequest
from app import models
from app.db import SessionLocal, Base, engine


def setup_module():
    # JANGAN drop_all di DB produksi yang dipakai aplikasi
    # Hanya pastikan semua tabel yang didefinisikan di Base sudah ada.
    Base.metadata.create_all(bind=engine)


def get_db() -> Session:
    return SessionLocal()


def test_register_user_directly():
    db = get_db()

    body = RegisterRequest(
        name="Unit Test",
        email="unit_test_pytest@example.com",  # pakai email unik
        password="123456",
    )

    # simulate register logic (unit, no HTTP)
    hashed_pw = hash_password(body.password)
    user = models.User(
        name=body.name,
        email=body.email,
        password_hash=hashed_pw,
    )

    db.add(user)
    db.commit()
    db.refresh(user)

    try:
        assert user.id is not None
        assert user.email == "unit_test_pytest@example.com"
        assert user.password_hash != "123456"
        assert user.password_hash.startswith("$2")
    finally:
        # cleanup: hapus user test biar DB bersih
        db.delete(user)
        db.commit()
        db.close()
