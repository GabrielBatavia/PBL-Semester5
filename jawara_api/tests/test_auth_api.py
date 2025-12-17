# tests/test_auth_api.py

import pytest
from app import models


@pytest.fixture
def cleanup_email(db):
    def _cleanup(email: str):
        db.query(models.User).filter(models.User.email == email).delete()
        db.commit()
    return _cleanup


def test_register_and_login_flow(client, db, cleanup_email):
    test_email = "api_test_user@example.com"
    test_password = "test12345"

    # pastikan bersih
    cleanup_email(test_email)

    # 1) REGISTER
    res_reg = client.post(
        "/auth/register",
        json={
            "name": "API Test User",
            "email": test_email,
            "password": test_password,
            "nik": None,
            "phone": None,
            "address": None,
        },
    )

    assert res_reg.status_code == 201
    data_reg = res_reg.json()
    assert data_reg["email"] == test_email
    assert data_reg["status"] == "pending"

    # 2) AKTIFKAN USER DI DB
    user = db.query(models.User).filter(models.User.email == test_email).first()
    assert user is not None
    user.status = "diterima"
    db.commit()

    # 3) LOGIN
    res_login = client.post(
        "/auth/login",
        json={
            "email": test_email,
            "password": test_password,
        },
    )

    assert res_login.status_code == 200
    token_data = res_login.json()
    assert "token" in token_data
    token = token_data["token"]

    # 4) /auth/me
    res_me = client.get(
        "/auth/me",
        headers={"Authorization": f"Bearer {token}"},
    )

    assert res_me.status_code == 200
    data_me = res_me.json()
    assert data_me["email"] == test_email

    # 5) BERSIHKAN USER TEST
    cleanup_email(test_email)
