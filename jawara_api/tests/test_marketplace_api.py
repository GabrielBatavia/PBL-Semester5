# tests/test_marketplace_api.py

from app import models


def test_create_get_and_list_marketplace_item(client, auth_header, db, test_user):
    title = "Bayam Segar Unit Test"

    # CREATE (pakai form-data, bukan JSON)
    res_create = client.post(
        "/marketplace/items",
        headers=auth_header,
        data={
            "title": title,
            "price": 10000,
            "description": "Dicoba untuk unit test.",
            "unit": "kg",
            "veggie_class": "Tomato",  # harus salah satu dari VEGGIE_CLASSES
        },
    )
    assert res_create.status_code == 201
    item = res_create.json()
    item_id = item["id"]
    assert item["title"] == title
    assert item["owner_id"] == test_user.id

    # GET by id
    res_get = client.get(f"/marketplace/items/{item_id}")
    assert res_get.status_code == 200
    assert res_get.json()["id"] == item_id

    # LIST
    res_list = client.get("/marketplace/items")
    assert res_list.status_code == 200
    data_list = res_list.json()
    assert any(i["id"] == item_id for i in data_list)

    # cleanup item
    db.query(models.MarketplaceItem).filter(
        models.MarketplaceItem.id == item_id
    ).delete()
    db.commit()


def test_analyze_image_requires_auth(client):
    # Tanpa header Authorization, harus 401/403 sebelum nyentuh service AI
    res = client.post(
        "/marketplace/analyze-image",
        files={
            "image": ("test.jpg", b"fake-image-content", "image/jpeg"),
        },
    )
    assert res.status_code in (401, 403)


def test_create_item_invalid_veggie_class_returns_400(client, auth_header):
    """
    Negative test:
    Kirim veggie_class yang tidak ada di daftar VEGGIE_CLASSES
    → harus 400 dengan pesan 'Invalid veggie_class value'.
    """
    res = client.post(
        "/marketplace/items",
        headers=auth_header,
        data={
            "title": "Sayur Aneh",
            "price": 5000,
            "description": "Ini harus gagal.",
            "unit": "kg",
            "veggie_class": "Banana",  # tidak ada di VEGGIE_CLASSES
        },
    )

    assert res.status_code == 400
    data = res.json()
    assert data["detail"] == "Invalid veggie_class value"
