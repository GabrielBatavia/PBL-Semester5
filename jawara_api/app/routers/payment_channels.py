# app/routers/payment_channels.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List, Optional
from pydantic import BaseModel

from ..deps import get_db, get_current_user
from .. import models

router = APIRouter(prefix="/payment-channels", tags=["Payment Channels"])

class PaymentChannelRead(BaseModel):
    id: int
    name: str
    type: str
    account_name: Optional[str] = None
    account_number: Optional[str] = None
    bank_name: Optional[str] = None
    qris_image_url: Optional[str] = None
    is_active: int
    
    class Config:
        from_attributes = True

class PaymentChannelCreate(BaseModel):
    name: str
    type: str  # bank, ewallet, qris
    account_name: str
    account_number: str
    bank_name: Optional[str] = None
    qris_image_url: Optional[str] = None

@router.get("/", response_model=List[PaymentChannelRead])
def list_payment_channels(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    """Get all active payment channels"""
    channels = (
        db.query(models.PaymentChannel)
        .filter(models.PaymentChannel.is_active == 1)
        .all()
    )
    return channels

@router.post("/", response_model=PaymentChannelRead)
def create_payment_channel(
    channel: PaymentChannelCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    """Create new payment channel"""
    new_channel = models.PaymentChannel(
        name=channel.name,
        type=channel.type,
        account_name=channel.account_name,
        account_number=channel.account_number,
        bank_name=channel.bank_name,
        qris_image_url=channel.qris_image_url,
        is_active=1,
    )
    
    db.add(new_channel)
    db.commit()
    db.refresh(new_channel)
    
    return new_channel