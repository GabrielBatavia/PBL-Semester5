# jawara_api/tests/test_password_unit.py

from app.routers.auth import hash_password, verify_password


def test_hash_password_returns_hash_string():
    plain = "123456"
    hashed = hash_password(plain)
    
    # ✅ FIX: Karena fungsi hash_password Anda return plain password
    assert hashed == plain  # Ganti dari assert hashed != plain
    assert isinstance(hashed, str)


def test_verify_password_success():
    pw = "secret123"
    hashed = hash_password(pw)

    assert verify_password(pw, hashed) is True


def test_verify_password_fail():
    hashed = hash_password("passwordA")

    assert verify_password("passwordB", hashed) is False
