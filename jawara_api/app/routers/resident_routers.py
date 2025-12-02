from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.deps import get_db
from app.models import Resident
from app.schemas.resident_schema import ResidentCreate, ResidentUpdate, ResidentOut

router = APIRouter(prefix="/residents", tags=["Residents"])

# GET BY ID
@router.get("/{id}", response_model=ResidentOut)
def get_resident(id: int, db: Session = Depends(get_db)):
    return db.query(Resident).filter(Resident.id == id).first()


# CREATE
@router.post("/", response_model=ResidentOut)
def create_resident(payload: ResidentCreate, db: Session = Depends(get_db)):
    new_resident = Resident(**payload.dict())
    db.add(new_resident)
    db.commit()
    db.refresh(new_resident)
    return new_resident


# UPDATE
@router.put("/{id}", response_model=ResidentOut)
def update_resident(id: int, payload: ResidentUpdate, db: Session = Depends(get_db)):
    res = db.query(Resident).filter(Resident.id == id).first()
    if not res:
        return None

    for key, value in payload.dict().items():
        setattr(res, key, value)

    db.commit()
    db.refresh(res)
    return res

@router.get("/", response_model=list[ResidentOut])
def get_residents(search: str | None = None, db: Session = Depends(get_db)):
    query = db.query(Resident)

    if search:
        search_term = f"%{search}%"
        query = query.filter(
            Resident.name.like(search_term) |
            Resident.nik.like(search_term)
        )

    return query.all()


# DELETE
@router.delete("/{id}")
def delete_resident(id: int, db: Session = Depends(get_db)):
    res = db.query(Resident).filter(Resident.id == id).first()
    if not res:
        return {"deleted": False}

    db.delete(res)
    db.commit()
    return {"deleted": True}
