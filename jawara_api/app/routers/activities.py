# Create file: jawara_api/app/routers/activities.py

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import List
from datetime import datetime

from ..db import SessionLocal
from ..models import Activity, User  # GANTI IMPORT INI
from ..schemas import activities as activity_schemas
from ..deps import get_db, get_current_user

router = APIRouter(prefix="/activities", tags=["Activities"])


@router.get("/", response_model=List[activity_schemas.ActivityRead])
def get_activities(
    skip: int = 0,
    limit: int = 100,
    category: str = None,
    db: Session = Depends(get_db),
):
    """Get all activities with optional category filter"""
    query = db.query(Activity)  # GANTI models.Activity → Activity
    
    if category:
        query = query.filter(Activity.category == category)  # GANTI
    
    activities = query.order_by(Activity.date.desc()).offset(skip).limit(limit).all()  # GANTI
    return activities


@router.get("/stats/by-category", response_model=List[activity_schemas.ActivityCategoryStats])
def get_category_stats(db: Session = Depends(get_db)):
    """Get activity statistics grouped by category"""
    # Query to count activities per category
    results = (
        db.query(
            Activity.category,  # GANTI models.Activity → Activity
            func.count(Activity.id).label('count')  # GANTI
        )
        .filter(Activity.category.isnot(None))  # GANTI
        .group_by(Activity.category)  # GANTI
        .all()
    )
    
    # Calculate total and percentages
    total = sum(r.count for r in results)
    
    if total == 0:
        return []
    
    stats = []
    for result in results:
        stats.append({
            "category": result.category,
            "count": result.count,
            "percentage": round((result.count / total) * 100, 1)
        })
    
    return stats


@router.post("/", response_model=activity_schemas.ActivityRead, status_code=201)
def create_activity(
    activity: activity_schemas.ActivityCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),  # GANTI models.User → User
):
    """Create new activity"""
    new_activity = Activity(  # GANTI models.Activity → Activity
        **activity.dict(),
        created_by=current_user.id
    )
    
    db.add(new_activity)
    db.commit()
    db.refresh(new_activity)
    
    return new_activity


@router.get("/{activity_id}", response_model=activity_schemas.ActivityRead)
def get_activity(activity_id: int, db: Session = Depends(get_db)):
    """Get activity by ID"""
    activity = db.query(Activity).filter(Activity.id == activity_id).first()  # GANTI
    
    if not activity:
        raise HTTPException(status_code=404, detail="Activity not found")
    
    return activity


@router.patch("/{activity_id}", response_model=activity_schemas.ActivityRead)
def update_activity(
    activity_id: int,
    activity_update: activity_schemas.ActivityUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),  # GANTI
):
    """Update activity"""
    activity = db.query(Activity).filter(Activity.id == activity_id).first()  # GANTI
    
    if not activity:
        raise HTTPException(status_code=404, detail="Activity not found")
    
    # Update fields
    update_data = activity_update.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(activity, key, value)
    
    db.commit()
    db.refresh(activity)
    
    return activity


@router.delete("/{activity_id}", status_code=204)
def delete_activity(
    activity_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),  # GANTI
):
    """Delete activity"""
    activity = db.query(Activity).filter(Activity.id == activity_id).first()  # GANTI
    
    if not activity:
        raise HTTPException(status_code=404, detail="Activity not found")
    
    db.delete(activity)
    db.commit()
    
    return None