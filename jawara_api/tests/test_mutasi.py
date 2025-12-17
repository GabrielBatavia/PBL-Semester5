# tests/test_mutasi.py

def test_create_mutasi(client):
    # Buat family dulu karena mutasi butuh family_id
    fam_payload = { "house_id": None, "status": "aktif"}
    fam = client.post("/families/", json=fam_payload).json()

    payload = {
        "family_id": fam["id"],
        # server validation masih mengharuskan family_name (sesuai schema saat ini),
        # jadi kirimkan juga agar test lulus validasi.
        # "family_name": fam["name"],
        "old_address": "Jl Lama",
        "new_address": "Jl Baru",
        "mutation_type": "pindah",
        "reason": "Pekerjaan",
        "date": "2024-01-01"
    }

    res = client.post("/mutasi/", json=payload)
    assert res.status_code in (200, 201)
    assert "id" in res.json()

def test_get_all_mutasi(client):
    res = client.get("/mutasi/")
    assert res.status_code == 200
    assert isinstance(res.json(), list)

def test_get_mutasi_by_id(client):
    all_mut = client.get("/mutasi/").json()
    assert len(all_mut) >= 1
    mid = all_mut[0]["id"]

    res = client.get(f"/mutasi/{mid}")
    assert res.status_code == 200
    assert res.json()["id"] == mid

def test_update_mutasi(client):
    all_mut = client.get("/mutasi/").json()
    mut_id = all_mut[0]["id"]

    # ambil detil mutasi dulu
    det = client.get(f"/mutasi/{mut_id}").json()
    payload = {
        "family_id": det["family_id"],
        # "family_name": det.get("family_name", ""),  # ikut schema
        "old_address": det.get("old_address"),
        "new_address": det.get("new_address"),
        "mutation_type": det.get("mutation_type"),
        "reason": "Update alasan",
        "date": det.get("date")
    }

    res = client.put(f"/mutasi/{mut_id}", json=payload)
    assert res.status_code == 200
    assert res.json()["reason"] == "Update alasan"

def test_delete_mutasi(client):
    all_mut = client.get("/mutasi/").json()
    mut_id = all_mut[0]["id"]
    res = client.delete(f"/mutasi/{mut_id}")
    assert res.status_code == 200
