# tests/test_resident.py

def test_create_resident(client):
    # butuh family dulu — ambil family id pertama
    fams = client.get("/families/").json()
    fam_id = fams[0]["id"]

    payload = {
        "name": "Budi",
        "nik": "321321",
        "birth_date": "1990-01-01",
        "job": "Pekerja",
        "gender": "L",
        "family_id": fam_id
    }
    res = client.post("/residents/", json=payload)
    assert res.status_code in (200, 201)
    assert "id" in res.json()

def test_search_resident(client):
    # gunakan ?search= sesuai router
    res = client.get("/residents/?search=budi")
    assert res.status_code == 200
    assert isinstance(res.json(), list)

def test_update_resident(client):
    res_list = client.get("/residents/")
    rid = res_list.json()[0]["id"]

    # ambil resident detil
    detail = client.get(f"/residents/{rid}").json()
    payload = {
        "name": detail.get("name"),
        "nik": detail.get("nik"),
        "birth_date": detail.get("birth_date"),
        "job": "Programmer",   # ubah job
        "gender": detail.get("gender"),
        "family_id": detail.get("family_id")
    }

    res = client.put(f"/residents/{rid}", json=payload)
    assert res.status_code == 200
    assert res.json()["job"] == "Programmer"

def test_delete_resident(client):
    # create resident dulu
    fams = client.get("/families/").json()
    fam_id = fams[0]["id"]
    payload = {
        "name": "ToDelete",
        "nik": "999999",
        "birth_date": "1990-01-01",
        "job": "None",
        "gender": "L",
        "family_id": fam_id
    }
    r = client.post("/residents/", json=payload)
    rid = r.json()["id"]

    res = client.delete(f"/residents/{rid}")
    assert res.status_code == 200
    assert res.json().get("deleted", True) is True
