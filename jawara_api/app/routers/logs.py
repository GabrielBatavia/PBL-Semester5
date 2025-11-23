# app/routers/logs.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from ..deps import get_db, get_current_user
from .. import models
from ..schemas import logs as log_schemas

router = APIRouter(prefix="/logs", tags=["Logs"])


@router.get("/", response_model=list[log_schemas.LogRead])
def list_logs(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    logs = (
        db.query(models.ActivityLog)
        .order_by(models.ActivityLog.created_at.desc())
        .limit(100)
        .all()
    )
    return logs
