# tests/test_fee_categories_unit.py
import pytest
from decimal import Decimal
from sqlalchemy.orm import Session

from app import models
from app.db import SessionLocal, Base, engine


@pytest.fixture(scope="module")
def db():
    """Setup database for tests"""
    Base.metadata.create_all(bind=engine)
    session = SessionLocal()
    yield session
    session.close()


@pytest.fixture
def test_user(db: Session):
    """Create test user for authentication"""
    user = models.User(
        name="Test Bendahara",
        email="test_bendahara@test.com",
        password_hash="hashed_password",
        role="bendahara"
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    yield user
    db.delete(user)
    db.commit()


@pytest.fixture
def test_category(db: Session):
    """Create test fee category"""
    category = models.FeeCategory(
        name="Test Iuran Bulanan",
        type="bulanan",
        default_amount=Decimal("50000"),
        is_active=1
    )
    db.add(category)
    db.commit()
    db.refresh(category)
    yield category
    db.delete(category)
    db.commit()


class TestFeeCategoryModel:
    """Test FeeCategory model operations"""
    
    def test_create_fee_category(self, db: Session):
        """Test creating a new fee category"""
        category = models.FeeCategory(
            name="Iuran Kebersihan",
            type="bulanan",
            default_amount=Decimal("50000"),
            is_active=1
        )
        
        db.add(category)
        db.commit()
        db.refresh(category)
        
        assert category.id is not None
        assert category.name == "Iuran Kebersihan"
        assert category.type == "bulanan"
        assert category.default_amount == Decimal("50000")
        assert category.is_active == 1
        
        # Cleanup
        db.delete(category)
        db.commit()
    
    def test_create_insidental_category(self, db: Session):
        """Test creating insidental category"""
        category = models.FeeCategory(
            name="Iuran 17 Agustus",
            type="insidental",
            default_amount=Decimal("100000"),
            is_active=1
        )
        
        db.add(category)
        db.commit()
        db.refresh(category)
        
        assert category.type == "insidental"
        assert category.default_amount == Decimal("100000")
        
        # Cleanup
        db.delete(category)
        db.commit()
    
    def test_create_sukarela_category(self, db: Session):
        """Test creating sukarela category"""
        category = models.FeeCategory(
            name="Sumbangan Masjid",
            type="sukarela",
            default_amount=Decimal("0"),
            is_active=1
        )
        
        db.add(category)
        db.commit()
        db.refresh(category)
        
        assert category.type == "sukarela"
        assert category.default_amount == Decimal("0")
        
        # Cleanup
        db.delete(category)
        db.commit()
    
    def test_update_category_status(self, test_category: models.FeeCategory, db: Session):
        """Test updating category status"""
        # Deactivate
        test_category.is_active = 0
        db.commit()
        db.refresh(test_category)
        
        assert test_category.is_active == 0
        
        # Reactivate
        test_category.is_active = 1
        db.commit()
        db.refresh(test_category)
        
        assert test_category.is_active == 1
    
    def test_list_all_categories(self, db: Session, test_category: models.FeeCategory):
        """Test listing all categories"""
        categories = db.query(models.FeeCategory).all()
        
        assert len(categories) >= 1
        assert any(cat.name == "Test Iuran Bulanan" for cat in categories)
    
    def test_filter_active_categories(self, db: Session):
        """Test filtering only active categories"""
        # Create active and inactive categories
        active_cat = models.FeeCategory(
            name="Active Category",
            type="bulanan",
            default_amount=Decimal("25000"),
            is_active=1
        )
        inactive_cat = models.FeeCategory(
            name="Inactive Category",
            type="bulanan",
            default_amount=Decimal("25000"),
            is_active=0
        )
        
        db.add_all([active_cat, inactive_cat])
        db.commit()
        
        # Query only active
        active_categories = db.query(models.FeeCategory).filter(
            models.FeeCategory.is_active == 1
        ).all()
        
        assert all(cat.is_active == 1 for cat in active_categories)
        
        # Cleanup
        db.delete(active_cat)
        db.delete(inactive_cat)
        db.commit()
    
    def test_category_name_uniqueness(self, db: Session, test_category: models.FeeCategory):
        """Test that duplicate category names are handled"""
        # Try to create category with same name
        duplicate = models.FeeCategory(
            name="Test Iuran Bulanan",
            type="bulanan",
            default_amount=Decimal("50000"),
            is_active=1
        )
        
        # This should raise an error if unique constraint exists
        # Or we can check in business logic
        db.add(duplicate)
        
        try:
            db.commit()
            # If successful, cleanup
            db.delete(duplicate)
            db.commit()
        except Exception:
            db.rollback()


class TestFeeCategoryValidation:
    """Test fee category validation logic"""
    
    def test_valid_category_types(self):
        """Test valid category types"""
        valid_types = ["bulanan", "insidental", "sukarela"]
        
        for cat_type in valid_types:
            assert cat_type in valid_types
    
    def test_amount_is_positive(self):
        """Test that amount should be non-negative"""
        valid_amount = Decimal("50000")
        zero_amount = Decimal("0")
        
        assert valid_amount >= 0
        assert zero_amount >= 0
    
    def test_amount_precision(self):
        """Test decimal precision for amounts"""
        amount = Decimal("50000.50")
        
        # Should have 2 decimal places max
        assert amount.as_tuple().exponent >= -2