import pytest
from datetime import date

from app import models


# ============================================================
# FIXTURE FAMILY (dipakai oleh mutasi)
# ============================================================
@pytest.fixture
def family(db):
    fam = db.query(models.Family).first()
    if fam:
        return fam

    house = models.House(
        address="Jl Test",
        area=None,
        status="aktif"
    )
    db.add(house)
    db.commit()
    db.refresh(house)

    fam = models.Family(
        name="Keluarga Test",
        house_id=house.id
    )
    db.add(fam)
    db.commit()
    db.refresh(fam)

    return fam


# ============================================================
# CREATE MUTASI
# ============================================================
def test_create_mutasi_success(client, family):
    payload = {
        "family_id": family.id,
        "old_address": "Alamat Lama",
        "new_address": "Alamat Baru",
        "mutation_type": "pindah",
        "reason": "Pindah kerja",
        "date": str(date.today())
    }

    res = client.post("/mutasi/", json=payload)
    assert res.status_code == 200

    data = res.json()
    assert data["family_id"] == family.id
    assert data["family_name"] == family.name
    assert data["mutation_type"] == "pindah"


# ============================================================
# GET ALL MUTASI
# ============================================================
def test_get_all_mutasi(client):
    res = client.get("/mutasi/")
    assert res.status_code == 200
    assert isinstance(res.json(), list)


# ============================================================
# SEARCH MUTASI
# ============================================================
def test_search_mutasi(client):
    res = client.get("/mutasi/?search=pindah")
    assert res.status_code == 200
    assert isinstance(res.json(), list)


# ============================================================
# UPDATE MUTASI (payload lengkap → hindari 422)
# ============================================================
def test_update_mutasi_success(client, family):
    create = client.post("/mutasi/", json={
        "family_id": family.id,
        "old_address": "A",
        "new_address": "B",
        "mutation_type": "pindah",
        "reason": "Awal",
        "date": str(date.today())
    }).json()

    res = client.put(f"/mutasi/{create['id']}", json={
        "family_id": family.id,
        "old_address": "A",
        "new_address": "B",
        "mutation_type": "pindah",
        "reason": "Alasan diubah",
        "date": str(date.today())
    })

    assert res.status_code == 200
    assert res.json()["reason"] == "Alasan diubah"


# ============================================================
# DELETE MUTASI
# (router tidak return body → cukup cek status code)
# ============================================================
def test_delete_mutasi_success(client, family):
    create = client.post("/mutasi/", json={
        "family_id": family.id,
        "old_address": "X",
        "new_address": "Y",
        "mutation_type": "pindah",
        "reason": "Test delete",
        "date": str(date.today())
    }).json()

    res = client.delete(f"/mutasi/{create['id']}")
    assert res.status_code == 200
