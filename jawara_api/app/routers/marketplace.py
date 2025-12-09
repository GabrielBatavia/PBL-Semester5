from fastapi import APIRouter, Depends, UploadFile, File, Form, HTTPException, status
from sqlalchemy.orm import Session
from pathlib import Path
from typing import List, Optional
import os
import httpx

from ..deps import get_db, get_current_user
from .. import models
from ..schemas import marketplace as marketplace_schemas

router = APIRouter(prefix="/marketplace", tags=["Marketplace"])

# folder penyimpanan gambar
UPLOAD_DIR = Path("uploads/marketplace")
UPLOAD_DIR.mkdir(parents=True, exist_ok=True)

# 🔹 URL service AI sayur (lokal / HuggingFace)
VEGGIE_MODEL_URL = os.getenv("VEGGIE_MODEL_URL", "http://127.0.0.1:7860")

# 🔹 Daftar kelas yang valid
VEGGIE_CLASSES = [
    "Tomato",
    "Onion White",
    "Pepper Green",
    "Cucumber Ripe",
    "Corn",
    "Pepper Red",
]


@router.get("/items", response_model=List[marketplace_schemas.MarketplaceItemRead])
def list_items(db: Session = Depends(get_db)):
    items = (
        db.query(models.MarketplaceItem)
        .order_by(models.MarketplaceItem.created_at.desc())
        .all()
    )
    return items


@router.get(
    "/items/{item_id}",
    response_model=marketplace_schemas.MarketplaceItemRead,
)
def get_item(item_id: int, db: Session = Depends(get_db)):
    item = db.get(models.MarketplaceItem, item_id)
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    return item


# 🔹 Endpoint baru: kirim foto ke AI model service
@router.post("/analyze-image")
async def analyze_image(
    image: UploadFile = File(...),
    current_user=Depends(get_current_user),
):
    if not VEGGIE_MODEL_URL:
        raise HTTPException(
            status_code=500, detail="VEGGIE_MODEL_URL is not configured"
        )

    try:
        img_bytes = await image.read()

        async with httpx.AsyncClient(timeout=30.0) as client:
            files = {
                "file": (
                    image.filename,
                    img_bytes,
                    image.content_type or "image/jpeg",
                )
            }
            resp = await client.post(
                f"{VEGGIE_MODEL_URL.rstrip('/')}/predict", files=files
            )

        if resp.status_code != 200:
            raise HTTPException(
                status_code=resp.status_code,
                detail=f"Model service error: {resp.text}",
            )

        data = resp.json()
        # data berisi: label, label_index, confidence, probs
        return data
    except httpx.RequestError as e:
        raise HTTPException(
            status_code=502,
            detail=f"Gagal menghubungi service AI: {e}",
        )
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Unexpected error: {e}",
        )


@router.post(
    "/items",
    response_model=marketplace_schemas.MarketplaceItemRead,
    status_code=status.HTTP_201_CREATED,
)
async def create_item(
    title: str = Form(...),
    price: float = Form(...),
    description: Optional[str] = Form(None),
    unit: Optional[str] = Form(None),
    # 🔹 class dari user / AI
    veggie_class: Optional[str] = Form(None),
    image: Optional[UploadFile] = File(None),
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    image_url: Optional[str] = None

    if veggie_class is not None and veggie_class not in VEGGIE_CLASSES:
        raise HTTPException(status_code=400, detail="Invalid veggie_class value")

    if image is not None:
        # simpan file ke disk (sederhana, untuk tugas)
        ext = Path(image.filename).suffix
        file_name = f"{current_user.id}_{title.replace(' ', '_')}{ext}"
        file_path = UPLOAD_DIR / file_name

        with file_path.open("wb") as f:
            content = await image.read()
            f.write(content)

        image_url = f"/static/marketplace/{file_name}"

    item = models.MarketplaceItem(
        title=title,
        description=description,
        price=price,
        unit=unit,
        image_url=image_url,
        veggie_class=veggie_class,
        owner_id=current_user.id,
    )

    db.add(item)
    db.commit()
    db.refresh(item)
    return item
