# jawara_api/tests/test_password_unit.py

from app.routers.auth import hash_password, verify_password


def test_hash_password_returns_hash_string():
    pw = "123456"
    hashed = hash_password(pw)

    assert isinstance(hashed, str)
    assert hashed != pw
    assert hashed.startswith("$2b$") or hashed.startswith("$2a$")


def test_verify_password_success():
    pw = "secret123"
    hashed = hash_password(pw)

    assert verify_password(pw, hashed) is True


def test_verify_password_fail():
    hashed = hash_password("passwordA")

    assert verify_password("passwordB", hashed) is False
