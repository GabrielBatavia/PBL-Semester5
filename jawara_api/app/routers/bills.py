# jawara_api/app/routers/bills.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional
from pydantic import BaseModel
from decimal import Decimal
from datetime import datetime, date

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

class BillBulkCreate(BaseModel):
    category_id: int
    amount: float
    period_start: str  # YYYY-MM-DD
    period_end: str    # YYYY-MM-DD
    status: str = "belum_lunas"

class BillNotificationRequest(BaseModel):
    bill_ids: List[int]

@router.get("/", response_model=List[BillRead])
def list_bills(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    """Get all bills with family and category info"""
    bills = (
        db.query(models.Bill)
        .order_by(models.Bill.created_at.desc())
        .all()
    )
    
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

@router.post("/bulk-create/")
def create_bills_for_all_families(
    data: BillBulkCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    """Create bills for all active families"""
    families = db.query(models.Family).filter(models.Family.status == "aktif").all()
    
    if not families:
        raise HTTPException(status_code=404, detail="No active families found")
    
    category = db.query(models.FeeCategory).filter(models.FeeCategory.id == data.category_id).first()
    if not category:
        raise HTTPException(status_code=404, detail="Fee category not found")
    
    created_bills = []
    for family in families:
        code = f"BL{data.category_id}{family.id}{datetime.now().strftime('%Y%m%d%H%M%S')}"
        
        new_bill = models.Bill(
            family_id=family.id,
            category_id=data.category_id,
            code=code,
            amount=Decimal(str(data.amount)),
            period_start=datetime.strptime(data.period_start, "%Y-%m-%d").date(),
            period_end=datetime.strptime(data.period_end, "%Y-%m-%d").date(),
            status=data.status,
        )
        db.add(new_bill)
        created_bills.append(new_bill)
    
    db.commit()
    
    return {
        "message": f"Successfully created {len(created_bills)} bills",
        "count": len(created_bills),
        "category": category.name,
    }

@router.post("/send-notifications/")
def send_bill_notifications(
    request: BillNotificationRequest,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    """
    Endpoint untuk mengirim notifikasi tagihan ke warga.
    Developer fitur warga akan menggunakan data ini untuk membuat notifikasi.
    """
    bills = (
        db.query(models.Bill)
        .filter(models.Bill.id.in_(request.bill_ids))
        .all()
    )
    
    if not bills:
        raise HTTPException(status_code=404, detail="No bills found")
    
    # Prepare notification data for warga developer
    notification_data = []
    for bill in bills:
        notification_data.append({
            "bill_id": bill.id,
            "family_id": bill.family_id,
            "family_name": bill.family.name if bill.family else None,
            "category_name": bill.category.name if bill.category else None,
            "code": bill.code,
            "amount": float(bill.amount),
            "period_start": bill.period_start.isoformat(),
            "period_end": bill.period_end.isoformat() if bill.period_end else None,
            "status": bill.status,
            "message": f"Tagihan {bill.category.name if bill.category else 'Iuran'} sebesar Rp {bill.amount:,.0f} untuk periode {bill.period_start} - {bill.period_end}",
        })
    
    # TODO: Developer fitur warga akan mengintegrasikan ini dengan sistem notifikasi mereka
    # Misalnya: Firebase Cloud Messaging, WebSocket, atau sistem notifikasi lainnya
    
    return {
        "message": f"Notification data prepared for {len(bills)} bills",
        "count": len(bills),
        "notifications": notification_data,
        "note": "Data ini siap digunakan oleh developer fitur warga untuk mengirim notifikasi"
    }