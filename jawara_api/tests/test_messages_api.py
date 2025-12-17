# tests/test_messages_api.py

from app import models


def test_create_and_list_own_messages(client, auth_header, db, test_user):
    # CREATE message
    res_create = client.post(
        "/messages/",
        headers=auth_header,
        json={
            "title": "Laporan Jalan Rusak",
            "content": "Jalan di depan rumah rusak parah.",
        },
    )
    assert res_create.status_code == 201
    msg = res_create.json()
    msg_id = msg["id"]

    # LIST only mine
    res_list = client.get("/messages/?only_mine=true", headers=auth_header)
    assert res_list.status_code == 200
    data = res_list.json()
    assert any(m["id"] == msg_id for m in data)

    # cleanup message
    db.query(models.CitizenMessage).filter(
        models.CitizenMessage.id == msg_id
    ).delete()
    db.commit()


def test_create_message_requires_auth(client):
    res = client.post(
        "/messages/",
        json={"title": "Test", "content": "Harusnya 401"},
    )
    assert res.status_code in (401, 403)
