# jawara_api/tests/test_jwt_unit.py

from jose import jwt
from app.routers.auth import create_access_token
from app.deps import SECRET_KEY, ALGORITHM


def test_create_jwt_token():
    token = create_access_token(1)
    assert isinstance(token, str)
    assert len(token) > 20


def test_jwt_can_be_decoded():
    token = create_access_token(10)

    decoded = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])

    assert decoded["sub"] == "10"
    assert "exp" in decoded
