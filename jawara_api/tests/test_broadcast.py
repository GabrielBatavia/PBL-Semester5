import dotenv
dotenv.load_dotenv(".env.test", override=True)

import sys, os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import unittest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy import text

from app.main import app
from app.db import Base, get_db
from app.models.users import User
from app.models.roles import Role
from app.models.broadcast import Broadcast


# ===============================================
#     CONFIG TEST DATABASE (MySQL)
# ===============================================
MYSQL_TEST_URL = "mysql+pymysql://root:@localhost:3306/jawara_test"

engine = create_engine(
    MYSQL_TEST_URL,
    pool_pre_ping=True,
)

Base.metadata.bind = engine

TestingSessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)


# override dependency FastAPI
def override_get_db():
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()


app.dependency_overrides[get_db] = override_get_db

from app import deps
deps.get_db = override_get_db

client = TestClient(app)


# ===========================================================
#  FUNCTION: RESET DATABASE SETIAP TEST
# ===========================================================

def reset_database():
    with engine.connect() as conn:
        conn.execute(text("SET FOREIGN_KEY_CHECKS = 0;"))

    Base.metadata.drop_all(bind=engine)

    with engine.connect() as conn:
        conn.execute(text("SET FOREIGN_KEY_CHECKS = 1;"))

    Base.metadata.create_all(bind=engine)

    db = TestingSessionLocal()

    # Insert role
    role = Role(name="admin", display_name="Administrator")
    db.add(role)
    db.commit()
    db.refresh(role)

    # Insert user
    user = User(
        name="Test User",
        email="tester@example.com",
        password_hash="xxx",
        nik="111",
        phone="0800",
        address="Alamat Rumah",
        role_id=role.id,
        status="active"
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    db.close()

    return user.id


# ===========================================================
#                         UNIT TEST
# ===========================================================
class TestBroadcastMySQL(unittest.TestCase):

    def setUp(self):
        self.sender_id = reset_database()

    # ----------------------------
    # GET LIST EMPTY
    # ----------------------------
    def test_get_list_empty(self):
        res = client.get("/broadcast/")
        self.assertEqual(res.status_code, 200)
        self.assertEqual(res.json(), [])

    # ----------------------------
    # CREATE
    # ----------------------------
    def test_create_broadcast(self):
        payload = {
            "title": "Judul Tes",
            "content": "Isi Tes",
            "sender_id": self.sender_id
        }

        res = client.post("/broadcast/", json=payload)
        self.assertEqual(res.status_code, 201)
        data = res.json()

        self.assertEqual(data["title"], payload["title"])
        self.assertEqual(data["sender_id"], self.sender_id)
        self.assertIn("id", data)

    # ----------------------------
    # LIST AFTER CREATE
    # ----------------------------
    def test_list_after_create(self):
        payload = {
            "title": "Tes",
            "content": "Isi",
            "sender_id": self.sender_id
        }
        client.post("/broadcast/", json=payload)

        res = client.get("/broadcast/")
        self.assertEqual(res.status_code, 200)
        self.assertEqual(len(res.json()), 1)

    # ----------------------------
    # DETAIL
    # ----------------------------
    def test_get_detail(self):
        payload = {
            "title": "Detail",
            "content": "Ini detail",
            "sender_id": self.sender_id
        }
        new = client.post("/broadcast/", json=payload).json()

        res = client.get(f"/broadcast/{new['id']}")
        self.assertEqual(res.status_code, 200)
        self.assertEqual(res.json()["title"], "Detail")

    # ----------------------------
    # 404 DETAIL
    # ----------------------------
    def test_detail_not_found(self):
        res = client.get("/broadcast/99999")
        self.assertEqual(res.status_code, 404)

    # ----------------------------
    # UPDATE
    # ----------------------------
    def test_update_broadcast(self):
        payload = {
            "title": "Old",
            "content": "Old Content",
            "sender_id": self.sender_id
        }
        new = client.post("/broadcast/", json=payload).json()

        update_payload = {
            "title": "Updated",
            "content": "Updated Content"
        }

        res = client.put(f"/broadcast/{new['id']}", json=update_payload)
        self.assertEqual(res.status_code, 200)
        self.assertEqual(res.json()["title"], "Updated")

    # ----------------------------
    # DELETE
    # ----------------------------
    def test_delete_broadcast(self):
        payload = {
            "title": "To Delete",
            "content": "Bye",
            "sender_id": self.sender_id
        }
        new = client.post("/broadcast/", json=payload).json()

        res = client.delete(f"/broadcast/{new['id']}")
        self.assertEqual(res.status_code, 204)

        # delete → GET should 404
        res = client.get(f"/broadcast/{new['id']}")
        self.assertEqual(res.status_code, 404)


if __name__ == "__main__":
    unittest.main()