# tests/test_logs_api.py

from app import models


def test_list_logs_after_creating_user(client, auth_header, db):
    email = "log_user_pytest@example.com"

    # pastikan user ini gak ada
    db.query(models.User).filter(models.User.email == email).delete()
    db.commit()

    # Buat user baru (ini akan menulis ActivityLog)
    res_create = client.post(
        "/users/",
        headers=auth_header,
        json={
            "name": "Log User",
            "email": email,
            "password": "password123",
            "nik": None,
            "phone": None,
            "address": None,
            "role_id": None,
            "status": "diterima",
        },
    )
    assert res_create.status_code == 201

    # Panggil /logs
    res_logs = client.get("/logs/", headers=auth_header)
    assert res_logs.status_code == 200

    data = res_logs.json()
    assert isinstance(data, list)
    assert len(data) >= 1

    first = data[0]
    assert "description" in first
    assert "actor" in first
    assert "name" in first["actor"]

    # cleanup user baru
    user = db.query(models.User).filter(models.User.email == email).first()
    if user:
        db.query(models.User).filter(models.User.id == user.id).delete()
        db.commit()
