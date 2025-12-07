from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.deps import get_db
from .. import models
from app.schemas.mutation_schema import MutasiCreate, MutasiUpdate, MutasiOut

router = APIRouter(prefix="/mutasi", tags=["Mutasi"])


# ============================================================
# GET ALL MUTASI (JOIN Family untuk mengambil family_name)
# ============================================================
@router.get("/", response_model=list[MutasiOut])
def get_all(db: Session = Depends(get_db)):
    query = (
        db.query(models.Mutasi, models.Family.name.label("family_name"))
        .join(models.Family, models.Mutasi.family_id == models.Family.id)
        .all()
    )

    return [
        MutasiOut(
            id=m[0].id,
            family_id=m[0].family_id,
            family_name=m[1],
            old_address=m[0].old_address,
            new_address=m[0].new_address,
            mutation_type=m[0].mutation_type,
            reason=m[0].reason,
            date=m[0].date,
            created_at=m[0].created_at,
            updated_at=m[0].updated_at,
        )
        for m in query
    ]


# ============================================================
# CREATE MUTASI
# ============================================================
@router.post("/", response_model=MutasiOut)
def create_mutasi(data: MutasiCreate, db: Session = Depends(get_db)):

    family = db.query(models.Family).filter(models.Family.id == data.family_id).first()
    if not family:
        raise HTTPException(status_code=404, detail="Family not found")

    # Buat rumah baru jika alamat baru belum ada
    new_house = db.query(models.House).filter(models.House.address == data.new_address).first()
    if not new_house:
        new_house = models.House(address=data.new_address, area=None, status="aktif")
        db.add(new_house)
        db.commit()
        db.refresh(new_house)

    # Update house_id pada family
    family.house_id = new_house.id
    db.commit()

    # Simpan mutasi
    mutasi = models.Mutasi(**data.model_dump())
    db.add(mutasi)
    db.commit()
    db.refresh(mutasi)

    return MutasiOut(
        id=mutasi.id,
        family_id=mutasi.family_id,
        family_name=family.name,
        old_address=mutasi.old_address,
        new_address=mutasi.new_address,
        mutation_type=mutasi.mutation_type,
        reason=mutasi.reason,
        date=mutasi.date,
        created_at=mutasi.created_at,
        updated_at=mutasi.updated_at,
    )


# ============================================================
# GET MUTASI BY ID
# ============================================================
@router.get("/{id}", response_model=MutasiOut)
def get_by_id(id: int, db: Session = Depends(get_db)):
    query = (
        db.query(models.Mutasi, models.Family.name.label("family_name"))
        .join(models.Family, models.Mutasi.family_id == models.Family.id)
        .filter(models.Mutasi.id == id)
        .first()
    )

    if not query:
        raise HTTPException(status_code=404, detail="Mutasi not found")

    mutasi, family_name = query

    return MutasiOut(
        id=mutasi.id,
        family_id=mutasi.family_id,
        family_name=family_name,
        old_address=mutasi.old_address,
        new_address=mutasi.new_address,
        mutation_type=mutasi.mutation_type,
        reason=mutasi.reason,
        date=mutasi.date,
        created_at=mutasi.created_at,
        updated_at=mutasi.updated_at,
    )


# ============================================================
# UPDATE MUTASI
# ============================================================
@router.put("/{id}", response_model=MutasiOut)
def update(id: int, payload: MutasiUpdate, db: Session = Depends(get_db)):
    q = db.query(models.Mutasi).filter(models.Mutasi.id == id)
    data = q.first()
    if not data:
        raise HTTPException(404, "Mutasi not found")

    q.update(payload.model_dump())
    db.commit()

    updated = q.first()

    # Ambil nama family
    family = db.query(models.Family).filter(models.Family.id == updated.family_id).first()

    return MutasiOut(
        id=updated.id,
        family_id=updated.family_id,
        family_name=family.name if family else "-",
        old_address=updated.old_address,
        new_address=updated.new_address,
        mutation_type=updated.mutation_type,
        reason=updated.reason,
        date=updated.date,
        created_at=updated.created_at,
        updated_at=updated.updated_at,
    )


# ============================================================
# DELETE MUTASI
# ============================================================
@router.delete("/{id}")
def delete(id: int, db: Session = Depends(get_db)):
    q = db.query(models.Mutasi).filter(models.Mutasi.id == id)
    data = q.first()
    if not data:
        raise HTTPException(404, "Mutasi not found")

    q.delete()
    db.commit()