# app/routers/expenses.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import date
from decimal import Decimal

from ..deps import get_db, get_current_user
from .. import models
from pydantic import BaseModel

router = APIRouter(prefix="/expenses", tags=["Expenses"])

class ExpenseRead(BaseModel):
    id: int
    category: Optional[str] = None
    name: str
    amount: float
    date: date
    proof_image_url: Optional[str] = None
    created_by: Optional[int] = None
    
    class Config:
        from_attributes = True

class ExpenseCreate(BaseModel):
    category: str
    name: str
    amount: float
    date: date
    proof_image_url: Optional[str] = None

@router.get("/", response_model=List[ExpenseRead])
def list_expenses(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    """Get all expense transactions"""
    expenses = (
        db.query(models.ExpenseTransaction)
        .order_by(models.ExpenseTransaction.date.desc())
        .all()
    )
    return expenses

@router.post("/", response_model=ExpenseRead)
def create_expense(
    expense: ExpenseCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    """Create new expense transaction"""
    new_expense = models.ExpenseTransaction(
        category=expense.category,
        name=expense.name,
        amount=Decimal(str(expense.amount)),
        date=expense.date,
        proof_image_url=expense.proof_image_url,
        created_by=current_user.id,
    )
    
    db.add(new_expense)
    db.commit()
    db.refresh(new_expense)
    
    return new_expense