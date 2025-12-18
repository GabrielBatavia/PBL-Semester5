from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from app.deps import get_db
from app.models.citizen_request import CitizenRequest
from app.schemas.citizen_request_schema import CitizenRequestOut, CitizenRequestCreate, CitizenRequestUpdate
from datetime import datetime
from sqlalchemy import or_

router = APIRouter(prefix="/citizen-requests", tags=["Citizen Requests"])

@router.get("/search", response_model=list[CitizenRequestOut])
def search_requests(
    q: str,
    db: Session = Depends(get_db)
):
    data = db.query(CitizenRequest).filter(
        or_(
            CitizenRequest.name.ilike(f"%{q}%"),
            CitizenRequest.nik.ilike(f"%{q}%"),
            CitizenRequest.email.ilike(f"%{q}%")
        )
    ).all()

    return [
        CitizenRequestOut(
            id=row.id,
            name=row.name,
            nik=row.nik,
            email=row.email,
            gender=row.gender,
            identity_image_url=row.identity_image_url,
            status=row.status,
            processed_by=row.processed_by,
            processed_by_name=row.processed_by_user.name if row.processed_by_user else None,
            processed_at=row.processed_at,
            created_at=row.created_at,
            updated_at=row.updated_at
        )
        for row in data
    ]

# CREATE REQUEST 

@router.post("/", response_model=CitizenRequestOut, status_code=201)
def create_request(
    payload: CitizenRequestCreate,
    db: Session = Depends(get_db)
):
    data = CitizenRequest(
        name=payload.name,
        nik=payload.nik,
        email=payload.email,
        gender=payload.gender,
        status=payload.status or "pending",
        identity_image_url=None,   
        created_at=datetime.utcnow(),
        updated_at=datetime.utcnow()
    )

    db.add(data)
    db.commit()
    db.refresh(data)

    return CitizenRequestOut(
        id=data.id,
        name=data.name,
        nik=data.nik,
        email=data.email,
        gender=data.gender,
        identity_image_url=data.identity_image_url,
        status=data.status,
        processed_by=data.processed_by,
        processed_by_name=None,
        processed_at=data.processed_at,
        created_at=data.created_at,
        updated_at=data.updated_at
    )
 
# LIST REQUEST

@router.get("/", response_model=list[CitizenRequestOut])
def get_all(search: str | None = Query(default=None),
    db: Session = Depends(get_db)
):
    query = db.query(CitizenRequest)

    if search:
        query = query.filter(
            CitizenRequest.name.ilike(f"%{search}%")
        )

    data = query.order_by(CitizenRequest.created_at.desc()).all()

    results = []
    for row in data:
        results.append(
            CitizenRequestOut(
                id=row.id,
                name=row.name,
                nik=row.nik,
                email=row.email,
                gender=row.gender,
                identity_image_url=row.identity_image_url,
                status=row.status,
                processed_by=row.processed_by,
                processed_by_name=row.processed_by_user.name if row.processed_by_user else None,
                processed_at=row.processed_at,
                created_at=row.created_at,
                updated_at=row.updated_at
            )
        )
    return results


# DETAIL REQUEST

@router.get("/{request_id}", response_model=CitizenRequestOut)
def get_detail(request_id: int, db: Session = Depends(get_db)):
    row = db.query(CitizenRequest).filter(CitizenRequest.id == request_id).first()
    if not row:
        raise HTTPException(404, "Citizen request not found")

    return CitizenRequestOut(
        id=row.id,
        name=row.name,
        nik=row.nik,
        email=row.email,
        gender=row.gender,
        identity_image_url=row.identity_image_url,
        status=row.status,
        processed_by=row.processed_by,
        processed_by_name=row.processed_by_user.name if row.processed_by_user else None,
        processed_at=row.processed_at,
        created_at=row.created_at,
        updated_at=row.updated_at
    )


# UPDATE REQUEST (Approve/Reject)

@router.put("/{request_id}", response_model=CitizenRequestOut)
def update_request(
    request_id: int,
    payload: CitizenRequestUpdate,
    db: Session = Depends(get_db)
):
    row = db.query(CitizenRequest).filter(CitizenRequest.id == request_id).first()
    if not row:
        raise HTTPException(404, "Citizen request not found")

    data = payload.model_dump(exclude_unset=True)

    for key, value in data.items():
        setattr(row, key, value)

    # jika diproses admin
    if "processed_by" in data:
        row.processed_at = datetime.utcnow()

    row.updated_at = datetime.utcnow()

    db.commit()
    db.refresh(row)

    return CitizenRequestOut(
        id=row.id,
        name=row.name,
        nik=row.nik,
        email=row.email,
        gender=row.gender,
        identity_image_url=row.identity_image_url,
        status=row.status,
        processed_by=row.processed_by,
        processed_by_name=row.processed_by_user.name if row.processed_by_user else None,
        processed_at=row.processed_at,
        created_at=row.created_at,
        updated_at=row.updated_at
    )

# DELETE REQUEST

@router.delete("/{request_id}", status_code=204)
def delete_request(
    request_id: int,
    db: Session = Depends(get_db)
):
    row = db.query(CitizenRequest).filter(
        CitizenRequest.id == request_id
    ).first()

    if not row:
        raise HTTPException(404, "Citizen request not found")

    db.delete(row)
    db.commit()

    return
