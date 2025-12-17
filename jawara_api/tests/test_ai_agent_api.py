# tests/test_ai_agent_api.py


def test_ai_marketplace_analyze_requires_auth(client):
    res = client.post(
        "/ai/marketplace/analyze",
        files={"image": ("test.jpg", b"fake", "image/jpeg")},
    )
    assert res.status_code in (401, 403)


def test_ai_marketplace_analyze_mock_response(client, auth_header):
    res = client.post(
        "/ai/marketplace/analyze",
        headers=auth_header,
        files={"image": ("test.jpg", b"fake", "image/jpeg")},
    )

    assert res.status_code == 200
    data = res.json()
    # sesuai mock di router: label "Bayam (mock)"
    assert data["label"] == "Bayam (mock)"
    assert "confidence" in data
    assert isinstance(data["confidence"], float)
