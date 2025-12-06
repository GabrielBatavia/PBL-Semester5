# jawara_api/app/routers/bills.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List, Optional
from pydantic import BaseModel
from decimal import Decimal
from datetime import date

from ..deps import get_db, get_current_user
from .. import models

router = APIRouter(prefix="/bills", tags=["Bills"])

class BillRead(BaseModel):
    id: int
    family_id: Optional[int] = None
    category_id: Optional[int] = None
    code: str
    amount: float
    period_start: date
    period_end: Optional[date] = None
    status: str
    family_name: Optional[str] = None
    category_name: Optional[str] = None
    
    class Config:
        from_attributes = True

class BillCreate(BaseModel):
    category_id: int
    amount: float
    period_start: str  # yyyy-MM-dd
    period_end: str    # yyyy-MM-dd
    status: str = "belum_lunas"

@router.get("/", response_model=List[BillRead])
def list_bills(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    """Get all bills with family and category info"""
    bills = db.query(models.Bill).all()
    
    result = []
    for bill in bills:
        bill_dict = {
            "id": bill.id,
            "family_id": bill.family_id,
            "category_id": bill.category_id,
            "code": bill.code,
            "amount": float(bill.amount),
            "period_start": bill.period_start,
            "period_end": bill.period_end,
            "status": bill.status,
            "family_name": bill.family.name if bill.family else None,
            "category_name": bill.category.name if bill.category else None,
        }
        result.append(bill_dict)
    
    return result

@router.post("/bulk-create")
def create_bills_for_all_families(
    bill: BillCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    """Create bills for all active families"""
    # Get all active families
    families = db.query(models.Family).filter(models.Family.status == "aktif").all()
    
    # Get category to generate code
    category = db.query(models.FeeCategory).filter(models.FeeCategory.id == bill.category_id).first()
    
    bills_created = []
    for family in families:
        # Generate unique code
        code = f"BL{family.id:03d}{bill.category_id:02d}"
        
        new_bill = models.Bill(
            family_id=family.id,
            category_id=bill.category_id,
            code=code,
            amount=Decimal(str(bill.amount)),
            period_start=bill.period_start,
            period_end=bill.period_end,
            status=bill.status,
        )
        
        db.add(new_bill)
        bills_created.append({"family_name": family.name, "code": code})
    
    db.commit()
    
    return {
        "message": f"Successfully created {len(bills_created)} bills",
        "bills": bills_created
    }