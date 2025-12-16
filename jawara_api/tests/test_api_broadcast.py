# tests/test_api_broadcast.py
import pytest
from fastapi import status

@pytest.fixture(scope="module")
def sample_broadcast(client):
    # Buat broadcast dummy untuk testing
    payload = {"title": "Test Broadcast", "content": "Isi broadcast"}
    response = client.post("/broadcast/", json=payload)
    assert response.status_code == status.HTTP_201_CREATED
    return response.json()  # { "id": ..., "title": ..., "content": ..., "created_at": ... }

def test_create_broadcast(client):
    payload = {"title": "Create Test", "content": "Isi create test"}
    response = client.post("/broadcast/", json=payload)
    assert response.status_code == status.HTTP_201_CREATED
    data = response.json()
    assert data["title"] == payload["title"]
    assert data["content"] == payload["content"]

def test_list_broadcast(client, sample_broadcast):
    response = client.get("/broadcast/")
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert isinstance(data, list)
    assert any(b["id"] == sample_broadcast["id"] for b in data)

def test_get_broadcast(client, sample_broadcast):
    broadcast_id = sample_broadcast["id"]
    response = client.get(f"/broadcast/{broadcast_id}")
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert data["id"] == broadcast_id
    assert data["title"] == sample_broadcast["title"]

def test_update_broadcast(client, sample_broadcast):
    broadcast_id = sample_broadcast["id"]
    payload = {"title": "Updated Title"}
    response = client.put(f"/broadcast/{broadcast_id}", json=payload)
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert data["title"] == payload["title"]
    assert data["id"] == broadcast_id

def test_delete_broadcast(client, sample_broadcast):
    broadcast_id = sample_broadcast["id"]
    response = client.delete(f"/broadcast/{broadcast_id}")
    assert response.status_code == status.HTTP_204_NO_CONTENT

    # Pastikan sudah terhapus
    response_get = client.get(f"/broadcast/{broadcast_id}")
    assert response_get.status_code == status.HTTP_404_NOT_FOUND