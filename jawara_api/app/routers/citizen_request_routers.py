from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.deps import get_db
from app.models.citizen_request import CitizenRequest
from app.schemas.citizen_request_schema import CitizenRequestOut, CitizenRequestCreate, CitizenRequestUpdate
from datetime import datetime

router = APIRouter(prefix="/citizen-requests", tags=["Citizen Requests"])

# ========================
# LIST REQUEST
# ========================
@router.get("/", response_model=list[CitizenRequestOut])
def get_all(db: Session = Depends(get_db)):
    data = db.query(CitizenRequest).order_by(CitizenRequest.created_at.desc()).all()

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

# ========================
# DETAIL REQUEST
# ========================
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

# ========================
# UPDATE REQUEST (Approve/Reject)
# ========================
@router.put("/{request_id}", response_model=CitizenRequestOut)
def update_request(request_id: int, payload: CitizenRequestUpdate, db: Session = Depends(get_db)):
    row = db.query(CitizenRequest).filter(CitizenRequest.id == request_id).first()
    if not row:
        raise HTTPException(404, "Citizen request not found")

    if payload.status:
        row.status = payload.status

    if payload.processed_by:
        row.processed_by = payload.processed_by
        row.processed_at = datetime.utcnow()

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
