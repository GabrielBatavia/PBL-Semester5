# app/routers/family_router.py

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.deps import get_db
from .. import models


from app.schemas.family_schema import (
    FamilyCreate, FamilyUpdate, FamilyOut, FamilyExtended
)

router = APIRouter(prefix="/families", tags=["Family"])

# # ─────────────────────────────────────────────
# # GET families
# # ─────────────────────────────────────────────
# @router.get("/", response_model=list[FamilyOut])
# def get_families(search: str | None = None, db: Session = Depends(get_db)):
#     query = db.query(models.Family)
#     if search:
#         pattern = f"%{search}%"
#         query = query.filter(models.Family.name.like(pattern))
#     return query.all()


# ─────────────────────────────────────────────
# GET families extended (jumlah anggota + alamat rumah)
# ─────────────────────────────────────────────
@router.get("/extended", response_model=list[FamilyExtended])
def get_families(search: str | None = None, db: Session = Depends(get_db)):
    query = db.query(models.Family)
    if search:
        pattern = f"%{search}%"
        query = query.filter(models.Family.name.like(pattern))
    families =query.all()
    result = []

    for fam in families:
        count = db.query(models.Resident).filter(models.Resident.family_id == fam.id).count()

        # ambil alamat dari tabel House
        address = None
        if fam.house_id:
            house = db.query(models.House).filter(models.House.id == fam.house_id).first()
            address = house.address if house else None

        result.append({
            "id": fam.id,
            "name": fam.name,
            "house_id": fam.house_id,
            "status": fam.status,
            "jumlah_anggota": count,
            "address": address
        })

    return result


# ─────────────────────────────────────────────
# GET by ID
# ─────────────────────────────────────────────
@router.get("/{id}", response_model=FamilyOut)
def get_family(id: int, db: Session = Depends(get_db)):
    return db.query(models.Family).filter(models.Family.id == id).first()

@router.get("/", response_model=list[FamilyOut])
def get_families(search: str | None = None, db: Session = Depends(get_db)):
    query = db.query(models.Family)

    if search:
        query = query.filter(models.Family.name.like(f"%{search}%"))

    return query.all()

# ─────────────────────────────────────────────
# CREATE
# ─────────────────────────────────────────────
@router.post("/", response_model=FamilyOut)
def create_family(payload: FamilyCreate, db: Session = Depends(get_db)):
    fam = models.Family(**payload.dict())
    db.add(fam)
    db.commit()
    db.refresh(fam)
    return fam


# ─────────────────────────────────────────────
# UPDATE
# ─────────────────────────────────────────────
@router.put("/{id}", response_model=FamilyOut)
def update_family(id: int, payload: FamilyUpdate, db: Session = Depends(get_db)):
    fam = db.query(models.Family).filter(models.Family.id == id).first()
    if not fam:
        return None

    for key, value in payload.dict().items():
        setattr(fam, key, value)

    db.commit()
    db.refresh(fam)
    return fam


# ─────────────────────────────────────────────
# DELETE
# ─────────────────────────────────────────────
@router.delete("/{id}")
def delete_family(id: int, db: Session = Depends(get_db)):
    fam = db.query(models.Family).filter(models.Family.id == id).first()
    if not fam:
        return {"deleted": False}

    db.delete(fam)
    db.commit()
    return {"deleted": True}

# ─────────────────────────────────────────────
# GET FAMILY MEMBERS (RESIDENTS) BY FAMILY ID
# ─────────────────────────────────────────────
@router.get("/{family_id}/residents") # <-- PATH INI HARUS ADA
def get_family_residents(family_id: int, db: Session = Depends(get_db)):
    # Lakukan Query ke database
    residents = db.query(models.Resident).filter(models.Resident.family_id == family_id).all()
    
    # Pastikan data yang dikembalikan sesuai dengan skema Resident/ResidentOut
    return residents