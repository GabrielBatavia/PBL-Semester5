# jawara_api/app/routers/fee_categories.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List, Optional
from pydantic import BaseModel
from decimal import Decimal

from ..deps import get_db, get_current_user
from .. import models

router = APIRouter(prefix="/fee-categories", tags=["Fee Categories"])

class FeeCategoryRead(BaseModel):
    id: int
    name: str
    type: str
    default_amount: float
    is_active: int
    
    class Config:
        from_attributes = True

class FeeCategoryCreate(BaseModel):
    name: str
    type: str  # bulanan, insidental, sukarela
    default_amount: float

@router.get("/", response_model=List[FeeCategoryRead])
def list_fee_categories(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    """Get all active fee categories"""
    categories = (
        db.query(models.FeeCategory)
        .filter(models.FeeCategory.is_active == 1)
        .order_by(models.FeeCategory.name)
        .all()
    )
    return categories

@router.post("/", response_model=FeeCategoryRead)
def create_fee_category(
    category: FeeCategoryCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    """Create new fee category"""
    new_category = models.FeeCategory(
        name=category.name,
        type=category.type,
        default_amount=Decimal(str(category.default_amount)),
        is_active=1,
    )
    
    db.add(new_category)
    db.commit()
    db.refresh(new_category)
    
    return new_category