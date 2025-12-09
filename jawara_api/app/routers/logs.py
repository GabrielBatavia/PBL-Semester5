# app/routers/logs.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List

from ..deps import get_db, get_current_user
from .. import models
from ..schemas import logs as log_schemas

router = APIRouter(prefix="/logs", tags=["Logs"])


@router.get("/", response_model=List[log_schemas.LogRead])
def list_logs(
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user),
):
    logs = (
        db.query(models.ActivityLog)
        .order_by(models.ActivityLog.created_at.desc())
        .limit(100)
        .all()
    )
    return logs


@router.get("/latest", response_model=List[log_schemas.LogRead])
def get_latest_logs(
    limit: int = 3,
    db: Session = Depends(get_db),
):
    """Get latest activity logs without authentication"""
    logs = (
        db.query(models.ActivityLog)
        .order_by(models.ActivityLog.created_at.desc())
        .limit(limit)
        .all()
    )
    return logs
