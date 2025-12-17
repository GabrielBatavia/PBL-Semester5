# tests/test_family.py
def test_create_family(client):
    payload = {
        "name": "Keluarga A",
        "house_id": None,
        "status": "aktif"
    }

    res = client.post("/families/", json=payload)
    assert res.status_code == 200
    assert res.json()["name"] == "Keluarga A"


def test_get_families(client):
    res = client.get("/families/")
    assert res.status_code == 200
    data = res.json()
    assert isinstance(data, list)
    assert len(data) >= 1


def test_search_family(client):
    res = client.get("/families/?search=Keluarga")
    assert res.status_code == 200
    assert len(res.json()) >= 1


def test_update_family(client):
    # get first family
    families = client.get("/families/").json()
    fam_id = families[0]["id"]

    payload = {
        "name": "Keluarga Updated",
        "house_id": None,
        "status": "nonaktif"
    }

    res = client.put(f"/families/{fam_id}", json=payload)
    assert res.status_code == 200
    assert res.json()["name"] == "Keluarga Updated"


def test_create_house_and_resident_for_extended(client):
    # create house
    house_payload = {"address": "Jl. Merdeka", "area": "A1", "status": "active"}
    house_res = client.post("/houses/", json=house_payload)
    assert house_res.status_code in (200, 201)
    house_id = house_res.json()["id"]

    # create family with house_id
    fam_payload = {"name": "Keluarga B", "house_id": house_id, "status": "aktif"}
    fam_res = client.post("/families/", json=fam_payload)
    assert fam_res.status_code == 200
    fam_id = fam_res.json()["id"]

    # create resident
    resident_payload = {
        "name": "Warga 1",
        "nik": "123",
        "gender": "L",
        "birth_date": "2000-01-01",
        "job": "Pekerja",
        "family_id": fam_id
    }
    res2 = client.post("/residents/", json=resident_payload)
    assert res2.status_code in (200, 201)


def test_extended(client):
    res = client.get("/families/extended")
    assert res.status_code == 200

    data = res.json()
    assert isinstance(data, list)
    assert len(data) >= 1

    item = data[0]
    assert "jumlah_anggota" in item
    assert "address" in item


def test_get_family_residents(client):
    # get existing family
    families = client.get("/families/").json()
    fam_id = families[0]["id"]

    res = client.get(f"/families/{fam_id}/residents")
    assert res.status_code == 200
    assert isinstance(res.json(), list)


