# tests/test_users_api.py

from app import models


def test_list_users(client, auth_header, test_user):
    res = client.get("/users/", headers=auth_header)
    assert res.status_code == 200

    data = res.json()
    assert isinstance(data, list)
    # minimal: user test ada di list
    assert any(u["email"] == test_user.email for u in data)


def test_create_and_update_user(client, auth_header, db):
    email = "new_user_pytest@example.com"

    # pastikan tidak dobel
    db.query(models.User).filter(models.User.email == email).delete()
    db.commit()

    # CREATE
    res_create = client.post(
        "/users/",
        headers=auth_header,
        json={
            "name": "New User",
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
    data_create = res_create.json()
    user_id = data_create["id"]
    assert data_create["email"] == email

    # UPDATE
    res_update = client.patch(
        f"/users/{user_id}",
        headers=auth_header,
        json={"name": "Updated User"},
    )
    assert res_update.status_code == 200
    data_update = res_update.json()
    assert data_update["name"] == "Updated User"

    # cleanup user baru
    db.query(models.User).filter(models.User.id == user_id).delete()
    db.commit()


def test_create_user_duplicate_email_returns_400(client, auth_header, db):
    """
    Negative test:
    Bikin user dengan email yang sama dua kali.
    Request kedua harus 400 dengan pesan 'Email sudah digunakan.'.
    """
    email = "duplicate_user_pytest@example.com"

    # bersihkan dulu
    db.query(models.User).filter(models.User.email == email).delete()
    db.commit()

    payload = {
        "name": "Duplicate User",
        "email": email,
        "password": "password123",
        "nik": None,
        "phone": None,
        "address": None,
        "role_id": None,
        "status": "diterima",
    }

    # CREATE pertama → OK
    res1 = client.post("/users/", headers=auth_header, json=payload)
    assert res1.status_code == 201

    # CREATE kedua dengan email sama → harus 400
    res2 = client.post("/users/", headers=auth_header, json=payload)
    assert res2.status_code == 400
    data2 = res2.json()
    assert "Email sudah digunakan" in data2["detail"]

    # cleanup
    user = db.query(models.User).filter(models.User.email == email).first()
    if user:
        db.delete(user)
        db.commit()
