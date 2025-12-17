# tests/test_kegiatan_api.py

from app import models


def test_crud_kegiatan(client, auth_header, db, test_user):
    # CREATE
    res_create = client.post(
        "/kegiatan/",
        headers=auth_header,
        json={
            "nama": "Kerja Bakti",
            "kategori": "Kebersihan",
            "pj": "Pak RT",
            "tanggal": "2025-12-31",
            "lokasi": "Lapangan RW",
            "deskripsi": "Kerja bakti bersih-bersih lingkungan.",
        },
    )
    assert res_create.status_code == 201
    keg = res_create.json()
    keg_id = keg["id"]
    assert keg["nama"] == "Kerja Bakti"
    assert keg["created_by_id"] == test_user.id
    assert keg["is_deleted"] is False

    # LIST: harus muncul
    res_list = client.get("/kegiatan/", headers=auth_header)
    assert res_list.status_code == 200
    data_list = res_list.json()
    assert any(k["id"] == keg_id for k in data_list)

    # UPDATE
    res_update = client.put(
        f"/kegiatan/{keg_id}",
        headers=auth_header,
        json={"nama": "Kerja Bakti Update"},
    )
    assert res_update.status_code == 200
    keg_up = res_update.json()
    assert keg_up["nama"] == "Kerja Bakti Update"

    # DELETE (soft delete)
    res_del = client.delete(f"/kegiatan/{keg_id}", headers=auth_header)
    assert res_del.status_code == 204

    # LIST lagi: kegiatan ini tidak boleh muncul karena is_deleted=True
    res_list2 = client.get("/kegiatan/", headers=auth_header)
    assert res_list2.status_code == 200
    data_list2 = res_list2.json()
    assert not any(k["id"] == keg_id for k in data_list2)


def test_update_nonexistent_kegiatan_returns_404(client, auth_header, db, test_user):
    """
    Negative test:
    Coba update kegiatan yang sudah dihapus dari DB.
    Endpoint harus balas 404 'Kegiatan tidak ditemukan'.
    """
    # 1) Buat kegiatan dulu
    res_create = client.post(
        "/kegiatan/",
        headers=auth_header,
        json={
            "nama": "Dummy Kegiatan",
            "kategori": "Test",
            "pj": "Tester",
            "tanggal": "2025-12-31",
            "lokasi": "Balai RW",
            "deskripsi": "Untuk negative test.",
        },
    )
    assert res_create.status_code == 201
    keg_id = res_create.json()["id"]

    # 2) Hapus langsung dari DB supaya benar-benar tidak ada
    db.query(models.Kegiatan).filter(models.Kegiatan.id == keg_id).delete()
    db.commit()

    # 3) Coba UPDATE via API → harus 404
    res_update = client.put(
        f"/kegiatan/{keg_id}",
        headers=auth_header,
        json={"nama": "Seharusnya 404"},
    )
    assert res_update.status_code == 404
    data = res_update.json()
    assert data["detail"] == "Kegiatan tidak ditemukan"
