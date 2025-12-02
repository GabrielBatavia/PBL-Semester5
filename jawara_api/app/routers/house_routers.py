# app/routers/house_router.py

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.deps import get_db
from app.models import House, Family
from app.schemas.house_schema import HouseCreate, HouseOut, HouseUpdate 

router = APIRouter(prefix="/houses", tags=["Houses"])

# GET ALL
@router.get("/", response_model=list[HouseOut])
def get_houses(search: str | None = None, db: Session = Depends(get_db)):
    query = db.query(House)

    if search:
        search_term = f"%{search}%"
        query = query.filter(
            House.address.like(search_term) |
            House.area.like(search_term)
        )
    return query.all()

# GET BY ID
@router.get("/{id}", response_model=HouseOut)
def get_house(id: int, db: Session = Depends(get_db)):
    return db.query(House).filter(House.id == id).first()

@router.get("/", response_model=list[HouseOut])
def get_houses(search: str | None = None, db: Session = Depends(get_db)):
    query = db.query(House)

    if search:
        search_term = f"%{search}%"
        query = query.filter(
            House.address.like(search_term) |
            House.area.like(search_term)
        )
    return query.all()


# CREATE
@router.post("/", response_model=HouseCreate)
def create_house(payload: HouseCreate, db: Session = Depends(get_db)):
    new_house = House(**payload.dict())
    db.add(new_house)
    db.commit()
    db.refresh(new_house)
    return new_house

# UPDATE
@router.put("/{id}", response_model=HouseUpdate)
def update_house(id: int, payload: HouseCreate, db: Session = Depends(get_db)):
    house = db.query(House).filter(House.id == id).first()
    if not house:
        return None

    for key, value in payload.dict().items():
        setattr(house, key, value)

    db.commit()
    db.refresh(house)
    return house

# DELETE
@router.delete("/{id}")
def delete_house(id: int, db: Session = Depends(get_db)):
    house = db.query(House).filter(House.id == id).first()
    if not house:
        return {"deleted": False}

    db.delete(house)
    db.commit()
    return {"deleted": True}

@router.get("/{id}/families")
def get_families_by_house(id: int, db: Session = Depends(get_db)):
    families = db.query(Family).filter(Family.house_id == id).all()
    return families
