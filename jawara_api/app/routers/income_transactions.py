# jawara_api/app/routers/income_transactions.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List, Optional
from pydantic import BaseModel
from decimal import Decimal
from datetime import datetime

from ..deps import get_db, get_current_user
from .. import models

router = APIRouter(prefix="/income-transactions", tags=["Income Transactions"])

class IncomeTransactionRead(BaseModel):
    id: int
    category_id: Optional[int] = None
    family_id: Optional[int] = None
    name: str
    type: Optional[str] = None
    amount: float
    date: str
    proof_image_url: Optional[str] = None
    created_by: Optional[int] = None
    
    class Config:
        from_attributes = True

class IncomeTransactionCreate(BaseModel):
    category_id: Optional[int] = None
    family_id: Optional[int] = None
    name: str
    type: str
    amount: float
    date: str  # YYYY-MM-DD

@router.get("/", response_model=List[IncomeTransactionRead])
def list_income_transactions(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    """Get all income transactions"""
    transactions = (
        db.query(models.IncomeTransaction)
        .order_by(models.IncomeTransaction.date.desc())
        .all()
    )
    
    result = []
    for txn in transactions:
        result.append({
            "id": txn.id,
            "category_id": txn.category_id,
            "family_id": txn.family_id,
            "name": txn.name,
            "type": txn.type,
            "amount": float(txn.amount),
            "date": txn.date.isoformat(),
            "proof_image_url": txn.proof_image_url,
            "created_by": txn.created_by,
        })
    
    return result

@router.post("/", response_model=IncomeTransactionRead)
def create_income_transaction(
    transaction: IncomeTransactionCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    """Create new income transaction"""
    new_transaction = models.IncomeTransaction(
        category_id=transaction.category_id,
        family_id=transaction.family_id,
        name=transaction.name,
        type=transaction.type,
        amount=Decimal(str(transaction.amount)),
        date=datetime.strptime(transaction.date, "%Y-%m-%d").date(),
        created_by=current_user.id,
    )
    
    db.add(new_transaction)
    db.commit()
    db.refresh(new_transaction)
    
    return {
        "id": new_transaction.id,
        "category_id": new_transaction.category_id,
        "family_id": new_transaction.family_id,
        "name": new_transaction.name,
        "type": new_transaction.type,
        "amount": float(new_transaction.amount),
        "date": new_transaction.date.isoformat(),
        "proof_image_url": new_transaction.proof_image_url,
        "created_by": new_transaction.created_by,
    }