# tests/test_house.py

def test_create_house(client):
    payload = {"address": "Jl Mawar", "area": "A1", "status": "active"}
    res = client.post("/houses/", json=payload)
    assert res.status_code in (200, 201)
    assert "id" in res.json()

def test_search_house(client):
    # gunakan query param sesuai router: ?search=
    res = client.get("/houses/?search=mawar")
    assert res.status_code == 200
    # hasil bisa kosong atau berisi list
    assert isinstance(res.json(), list)

def test_update_house(client):
    # ambil house pertama
    res_list = client.get("/houses/")
    hid = res_list.json()[0]["id"]

    # Ambil detail house supaya kita kirim payload lengkap saat PUT
    house_detail = client.get(f"/houses/{hid}").json()
    # siapkan payload update (kirim semua field yang diperlukan)
    update_payload = {
        "address": house_detail.get("address", "Alamat Default"),
        "area": house_detail.get("area", None),
        "status": "terisi"  # perubahan yang diinginkan
    }

    res = client.put(f"/houses/{hid}", json=update_payload)
    assert res.status_code == 200
    assert res.json()["status"] == "terisi"

def test_delete_house(client):
    # create dulu supaya ada yang dihapus
    payload = {"address": "Jl Hapus", "area": "A2", "status": "active"}
    res = client.post("/houses/", json=payload)
    hid = res.json()["id"]

    res_del = client.delete(f"/houses/{hid}")
    assert res_del.status_code == 200
    assert res_del.json().get("deleted", True) is True
