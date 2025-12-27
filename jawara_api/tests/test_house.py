import pytest


def test_create_house_success(client):
    payload = {
        "address": "Jl. Merdeka No 10",
        "area": "RT 01",
        "status": "aktif"
    }

    res = client.post("/houses/", json=payload)
    assert res.status_code == 200

    data = res.json()
    assert data["address"] == payload["address"]
    assert data["status"] == payload["status"]
    assert "id" in data


def test_get_all_houses(client):
    res = client.get("/houses/")
    assert res.status_code == 200
    assert isinstance(res.json(), list)


def test_search_house_by_address(client):
    # buat data dulu
    client.post("/houses/", json={
        "address": "Jl. Mawar",
        "area": "RT 02",
        "status": "aktif"
    })

    res = client.get("/houses/?search=Mawar")
    assert res.status_code == 200
    data = res.json()

    assert len(data) >= 1
    assert "Mawar" in data[0]["address"]


def test_get_house_by_id_success(client):
    create = client.post("/houses/", json={
        "address": "Jl. Melati",
        "area": "RT 03",
        "status": "aktif"
    }).json()

    res = client.get(f"/houses/{create['id']}")
    assert res.status_code == 200
    assert res.json()["id"] == create["id"]


def test_update_house_success(client):
    create = client.post("/houses/", json={
        "address": "Jl. Kenanga",
        "area": "RT 04",
        "status": "aktif"
    }).json()

    update_payload = {
        "address": "Jl. Kenanga Baru",
        "area": "RT 05",
        "status": "tidak aktif"
    }

    res = client.put(f"/houses/{create['id']}", json=update_payload)
    assert res.status_code == 200

    data = res.json()
    assert data["address"] == "Jl. Kenanga Baru"
    assert data["status"] == "tidak aktif"

def test_delete_house_success(client):
    create = client.post("/houses/", json={
        "address": "Jl. Anggrek",
        "area": "RT 06",
        "status": "aktif"
    }).json()

    res = client.delete(f"/houses/{create['id']}")
    assert res.status_code == 200
    assert res.json()["deleted"] is True


def test_delete_house_not_found(client):
    res = client.delete("/houses/999999")
    assert res.status_code == 200
    assert res.json()["deleted"] is False


def test_create_house_invalid_payload(client):
    payload = {
        "area": "RT 07"
        # address wajib tapi tidak dikirim
    }

    res = client.post("/houses/", json=payload)
    assert res.status_code == 422
