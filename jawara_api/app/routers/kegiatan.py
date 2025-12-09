# app/routers/kegiatan.py

from typing import List

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from .. import models, schemas
from ..deps import get_db, get_current_user

router = APIRouter(
    prefix="/kegiatan",
    tags=["kegiatan"],
)


@router.get("/", response_model=List[schemas.KegiatanOut])
def list_kegiatan(
    skip: int = 0,
    limit: int = 50,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    # 🔥 untuk sekarang: tampilkan SEMUA kegiatan yang tidak dihapus
    kegiatan = (
        db.query(models.Kegiatan)
        .filter(models.Kegiatan.is_deleted == False)  # noqa: E712
        .order_by(models.Kegiatan.tanggal.desc())
        .offset(skip)
        .limit(limit)
        .all()
    )
    return kegiatan


@router.post("/", response_model=schemas.KegiatanOut, status_code=status.HTTP_201_CREATED)
def create_kegiatan(
    body: schemas.KegiatanCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    keg = models.Kegiatan(
        nama=body.nama,
        kategori=body.kategori,
        pj=body.pj,
        tanggal=body.tanggal,
        lokasi=body.lokasi,
        deskripsi=body.deskripsi,
        created_by_id=current_user.id,
    )
    db.add(keg)
    db.commit()
    db.refresh(keg)
    return keg


@router.put("/{kegiatan_id}", response_model=schemas.KegiatanOut)
def update_kegiatan(
    kegiatan_id: int,
    body: schemas.KegiatanUpdate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    keg = db.query(models.Kegiatan).filter(
        models.Kegiatan.id == kegiatan_id,
        models.Kegiatan.is_deleted == False,  # noqa: E712
    ).first()

    if not keg:
        raise HTTPException(status_code=404, detail="Kegiatan tidak ditemukan")

    # untuk sekarang belum cek role/owner
    for field, value in body.model_dump(exclude_unset=True).items():
        setattr(keg, field, value)

    db.commit()
    db.refresh(keg)
    return keg


@router.delete("/{kegiatan_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_kegiatan(
    kegiatan_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    keg = db.query(models.Kegiatan).filter(
        models.Kegiatan.id == kegiatan_id,
        models.Kegiatan.is_deleted == False,  # noqa: E712
    ).first()

    if not keg:
        raise HTTPException(status_code=404, detail="Kegiatan tidak ditemukan")

    # soft delete
    keg.is_deleted = True
    db.commit()
    return
