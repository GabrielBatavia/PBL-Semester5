import pytest
from app import models


# ============================================================
# FIXTURE: CITIZEN REQUEST DATA
# ============================================================
@pytest.fixture
def citizen_request(db):
    data = models.CitizenRequest(
        name="Budi Test",
        nik="1234567890123456",
        email="budi@test.com",
        gender="L",
        status="pending",
    )
    db.add(data)
    db.commit()
    db.refresh(data)

    yield data

    db.delete(data)
    db.commit()


# ============================================================
# CREATE REQUEST
# ============================================================
def test_create_citizen_request_success(client):
    payload = {
        "name": "Andi Test",
        "nik": "9876543210987654",
        "email": "andi@test.com",
        "gender": "L",
    }

    res = client.post("/citizen-requests/", json=payload)
    assert res.status_code == 201

    data = res.json()
    assert data["name"] == payload["name"]
    assert data["nik"] == payload["nik"]
    assert data["status"] == "pending"


# ============================================================
# GET ALL REQUEST
# ============================================================
def test_get_all_citizen_requests(client):
    res = client.get("/citizen-requests/")
    assert res.status_code == 200
    assert isinstance(res.json(), list)


# ============================================================
# SEARCH REQUEST
# ============================================================
def test_search_citizen_request(client, citizen_request):
    res = client.get("/citizen-requests/search?q=Budi")
    assert res.status_code == 200
    assert isinstance(res.json(), list)
    assert len(res.json()) >= 1


# ============================================================
# GET DETAIL
# ============================================================
def test_get_citizen_request_detail_success(client, citizen_request):
    res = client.get(f"/citizen-requests/{citizen_request.id}")
    assert res.status_code == 200
    assert res.json()["id"] == citizen_request.id


def test_get_citizen_request_detail_not_found(client):
    res = client.get("/citizen-requests/999999")
    assert res.status_code == 404


# ============================================================
# UPDATE REQUEST
# ============================================================
def test_update_citizen_request_success(client, citizen_request):
    payload = {
        "status": "approved"
    }

    res = client.put(
        f"/citizen-requests/{citizen_request.id}",
        json=payload
    )

    assert res.status_code == 200

    data = res.json()
    assert data["status"] == "approved"
    assert data["processed_at"] is None


def test_update_citizen_request_not_found(client):
    res = client.put(
        "/citizen-requests/999999",
        json={"status": "rejected"}
    )
    assert res.status_code == 404


# ============================================================
# DELETE REQUEST
# ============================================================
def test_delete_citizen_request_success(client, citizen_request):
    res = client.delete(f"/citizen-requests/{citizen_request.id}")
    assert res.status_code == 204


def test_delete_citizen_request_not_found(client):
    res = client.delete("/citizen-requests/999999")
    assert res.status_code == 404
