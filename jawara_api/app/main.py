# app/main.py

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pathlib import Path
from .routers import broadcast 
from .routers import kegiatan 

from .db import Base, engine
from .routers import auth, users, logs, marketplace, ai_agent   # ← TAMBAHKAN marketplace

# create tables kalau belum ada
Base.metadata.create_all(bind=engine)

app = FastAPI(title="Jawara RT/RW API")

# CORS buat Flutter dev
origins = [
    "http://localhost:3000",
    "http://localhost:51377",
    "http://127.0.0.1:51377",
    "http://localhost:5173",
    "http://127.0.0.1:5500",
    "http://10.0.2.2:8080",
    "http://localhost:62301",  # flutter web dev
    "http://localhost:8000",
    "http://127.0.0.1:62301",
    "*",  # dev only
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_origin_regex=".*",
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ───────────────────────────────────────────────
# STATIC FILES (serve gambar)
# ───────────────────────────────────────────────
static_dir = Path("uploads")
static_dir.mkdir(exist_ok=True)

# contoh akses: http://localhost:8000/static/nama_file.jpg
app.mount("/static", StaticFiles(directory=static_dir), name="static")

# ───────────────────────────────────────────────
# ROUTERS
# ───────────────────────────────────────────────
app.include_router(auth.router)
app.include_router(users.router)
app.include_router(logs.router)
app.include_router(ai_agent.router)
app.include_router(marketplace.router)     
app.include_router(broadcast.router)
app.include_router(kegiatan.router)
