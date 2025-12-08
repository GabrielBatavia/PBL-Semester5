# tests/test_bills_unit.py
import pytest
from decimal import Decimal
from datetime import date
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
    """Create test user"""
    user = models.User(
        name="Test User",
        email="test_bills@test.com",
        password_hash="hashed",
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
        name="Test Category Bills",
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


@pytest.fixture
def test_family(db: Session):
    """Create test family"""
    family = models.Family(
        family_head="Budi Santoso",
        address="Jl. Test No. 1",
        phone="081234567890",
        status="aktif"
    )
    db.add(family)
    db.commit()
    db.refresh(family)
    yield family
    db.delete(family)
    db.commit()


class TestBillModel:
    """Test Bill model operations"""
    
    def test_create_bill(self, db: Session, test_category: models.FeeCategory, test_family: models.Family):
        """Test creating a new bill"""
        bill = models.Bill(
            family_id=test_family.id,
            category_id=test_category.id,
            code=f"BILL-{test_family.id}-{test_category.id}-202501",
            amount=Decimal("50000"),
            period_start=date(2025, 1, 1),
            period_end=date(2025, 1, 31),
            status="belum_lunas"
        )
        
        db.add(bill)
        db.commit()
        db.refresh(bill)
        
        assert bill.id is not None
        assert bill.family_id == test_family.id
        assert bill.category_id == test_category.id
        assert bill.amount == Decimal("50000")
        assert bill.status == "belum_lunas"
        
        # Cleanup
        db.delete(bill)
        db.commit()
    
    def test_bill_code_generation(self, db: Session, test_category: models.FeeCategory, test_family: models.Family):
        """Test bill code format"""
        bill_code = f"BILL-{test_family.id}-{test_category.id}-202501"
        
        assert "BILL-" in bill_code
        assert str(test_family.id) in bill_code
        assert str(test_category.id) in bill_code
    
    def test_bill_status_values(self):
        """Test valid bill status values"""
        valid_statuses = ["belum_lunas", "lunas", "terlambat"]
        
        for status in valid_statuses:
            assert status in valid_statuses
    
    def test_update_bill_status(self, db: Session, test_category: models.FeeCategory, test_family: models.Family):
        """Test updating bill status from belum_lunas to lunas"""
        bill = models.Bill(
            family_id=test_family.id,
            category_id=test_category.id,
            code=f"BILL-TEST-{test_family.id}",
            amount=Decimal("50000"),
            period_start=date(2025, 1, 1),
            period_end=date(2025, 1, 31),
            status="belum_lunas"
        )
        
        db.add(bill)
        db.commit()
        db.refresh(bill)
        
        # Update status
        bill.status = "lunas"
        db.commit()
        db.refresh(bill)
        
        assert bill.status == "lunas"
        
        # Cleanup
        db.delete(bill)
        db.commit()
    
    def test_list_bills_by_status(self, db: Session, test_category: models.FeeCategory, test_family: models.Family):
        """Test filtering bills by status"""
        # Create bills with different statuses
        bill1 = models.Bill(
            family_id=test_family.id,
            category_id=test_category.id,
            code="BILL-1",
            amount=Decimal("50000"),
            period_start=date(2025, 1, 1),
            period_end=date(2025, 1, 31),
            status="belum_lunas"
        )
        bill2 = models.Bill(
            family_id=test_family.id,
            category_id=test_category.id,
            code="BILL-2",
            amount=Decimal("50000"),
            period_start=date(2025, 2, 1),
            period_end=date(2025, 2, 28),
            status="lunas"
        )
        
        db.add_all([bill1, bill2])
        db.commit()
        
        # Query unpaid bills
        unpaid_bills = db.query(models.Bill).filter(
            models.Bill.status == "belum_lunas"
        ).all()
        
        assert all(bill.status == "belum_lunas" for bill in unpaid_bills)
        
        # Cleanup
        db.delete(bill1)
        db.delete(bill2)
        db.commit()
    
    def test_bulk_bill_creation(self, db: Session, test_category: models.FeeCategory):
        """Test creating bills for multiple families"""
        # Create multiple families
        families = []
        for i in range(3):
            family = models.Family(
                family_head=f"Family {i}",
                address=f"Jl. Test {i}",
                phone=f"08123456789{i}",
                status="aktif"
            )
            families.append(family)
        
        db.add_all(families)
        db.commit()
        
        # Create bills for all families
        bills = []
        for family in families:
            bill = models.Bill(
                family_id=family.id,
                category_id=test_category.id,
                code=f"BILL-{family.id}-{test_category.id}",
                amount=Decimal("50000"),
                period_start=date(2025, 1, 1),
                period_end=date(2025, 1, 31),
                status="belum_lunas"
            )
            bills.append(bill)
        
        db.add_all(bills)
        db.commit()
        
        assert len(bills) == 3
        
        # Cleanup
        for bill in bills:
            db.delete(bill)
        for family in families:
            db.delete(family)
        db.commit()


class TestBillNotifications:
    """Test bill notification logic"""
    
    def test_notification_data_structure(self, db: Session, test_category: models.FeeCategory, test_family: models.Family):
        """Test notification data preparation"""
        bill = models.Bill(
            family_id=test_family.id,
            category_id=test_category.id,
            code="BILL-NOTIF-TEST",
            amount=Decimal("50000"),
            period_start=date(2025, 1, 1),
            period_end=date(2025, 1, 31),
            status="belum_lunas"
        )
        
        db.add(bill)
        db.commit()
        db.refresh(bill)
        
        # Prepare notification data
        notification = {
            "bill_id": bill.id,
            "family_name": test_family.family_head,
            "category_name": test_category.name,
            "amount": float(bill.amount),
            "period": f"{bill.period_start} - {bill.period_end}",
            "status": bill.status
        }
        
        assert notification["bill_id"] is not None
        assert notification["family_name"] == test_family.family_head
        assert notification["amount"] == 50000.0
        
        # Cleanup
        db.delete(bill)
        db.commit()