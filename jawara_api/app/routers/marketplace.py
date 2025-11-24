# app/routers/marketplace.py
from fastapi import APIRouter, Depends, UploadFile, File, Form, HTTPException, status
from sqlalchemy.orm import Session
from pathlib import Path
from typing import List, Optional

from ..deps import get_db, get_current_user
from .. import models
from ..schemas import marketplace as marketplace_schemas

router = APIRouter(prefix="/marketplace", tags=["Marketplace"])

# folder penyimpanan gambar
UPLOAD_DIR = Path("uploads/marketplace")
UPLOAD_DIR.mkdir(parents=True, exist_ok=True)


@router.get("/items", response_model=List[marketplace_schemas.MarketplaceItemRead])
def list_items(db: Session = Depends(get_db)):
    items = db.query(models.MarketplaceItem).order_by(models.MarketplaceItem.created_at.desc()).all()
    return items


@router.get(
    "/items/{item_id}",
    response_model=marketplace_schemas.MarketplaceItemRead,
)
def get_item(item_id: int, db: Session = Depends(get_db)):
    item = db.query(models.MarketplaceItem).get(item_id)
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    return item


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
    image: Optional[UploadFile] = File(None),
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user),
):
    image_url: Optional[str] = None

    if image is not None:
        # simpan file ke disk (sederhana, untuk tugas)
        ext = Path(image.filename).suffix
        file_name = f"{current_user.id}_{title.replace(' ', '_')}{ext}"
        file_path = UPLOAD_DIR / file_name

        with file_path.open("wb") as f:
            content = await image.read()
            f.write(content)

        image_url = f"/static/marketplace/{file_name}"  # atau langsung file_path.as_posix()

    item = models.MarketplaceItem(
        title=title,
        description=description,
        price=price,
        unit=unit,
        image_url=image_url,
        owner_id=current_user.id,
    )

    db.add(item)
    db.commit()
    db.refresh(item)
    return item
