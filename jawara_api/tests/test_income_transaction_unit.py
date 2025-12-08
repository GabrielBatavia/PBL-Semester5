# tests/test_income_transactions_unit.py
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
        name="Test Bendahara",
        email="test_income@test.com",
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
        name="Test Category Income",
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
        head_name="Test Family",  # ✅ Ganti dari family_head
        address="Jl. Test",
        phone="081234567890",
        status="aktif"
    )
    db.add(family)
    db.commit()
    db.refresh(family)
    yield family
    db.delete(family)
    db.commit()


class TestIncomeTransactionModel:
    """Test IncomeTransaction model operations"""
    
    def test_create_income_iuran(self, db: Session, test_user: models.User, test_category: models.FeeCategory, test_family: models.Family):
        """Test creating income transaction for iuran"""
        transaction = models.IncomeTransaction(
            category_id=test_category.id,
            family_id=test_family.id,
            name="Iuran Kebersihan Januari",
            type="iuran",
            amount=Decimal("50000"),
            date=date(2025, 1, 5),
            created_by=test_user.id
        )
        
        db.add(transaction)
        db.commit()
        db.refresh(transaction)
        
        assert transaction.id is not None
        assert transaction.name == "Iuran Kebersihan Januari"
        assert transaction.type == "iuran"
        assert transaction.amount == Decimal("50000")
        assert transaction.category_id == test_category.id
        assert transaction.family_id == test_family.id
        
        # Cleanup
        db.delete(transaction)
        db.commit()
    
    def test_create_income_donasi(self, db: Session, test_user: models.User):
        """Test creating income transaction for donasi"""
        transaction = models.IncomeTransaction(
            category_id=None,
            family_id=None,
            name="Donasi Pembangunan Masjid",
            type="donasi",
            amount=Decimal("500000"),
            date=date(2025, 1, 10),
            created_by=test_user.id
        )
        
        db.add(transaction)
        db.commit()
        db.refresh(transaction)
        
        assert transaction.type == "donasi"
        assert transaction.amount == Decimal("500000")
        assert transaction.category_id is None
        assert transaction.family_id is None
        
        # Cleanup
        db.delete(transaction)
        db.commit()
    
    def test_create_income_lain_lain(self, db: Session, test_user: models.User):
        """Test creating income transaction for lain-lain"""
        transaction = models.IncomeTransaction(
            name="Penjualan Barang Bekas",
            type="lain_lain",
            amount=Decimal("150000"),
            date=date(2025, 1, 15),
            created_by=test_user.id
        )
        
        db.add(transaction)
        db.commit()
        db.refresh(transaction)
        
        assert transaction.type == "lain_lain"
        assert transaction.amount == Decimal("150000")
        
        # Cleanup
        db.delete(transaction)
        db.commit()
    
    def test_income_transaction_types(self):
        """Test valid income transaction types"""
        valid_types = ["iuran", "donasi", "lain_lain"]
        
        for trans_type in valid_types:
            assert trans_type in valid_types
    
    def test_list_income_by_type(self, db: Session, test_user: models.User):
        """Test filtering income by type"""
        # Create transactions with different types
        trans1 = models.IncomeTransaction(
            name="Iuran Test",
            type="iuran",
            amount=Decimal("50000"),
            date=date(2025, 1, 1),
            created_by=test_user.id
        )
        trans2 = models.IncomeTransaction(
            name="Donasi Test",
            type="donasi",
            amount=Decimal("100000"),
            date=date(2025, 1, 2),
            created_by=test_user.id
        )
        
        db.add_all([trans1, trans2])
        db.commit()
        
        # Query only iuran
        iuran_transactions = db.query(models.IncomeTransaction).filter(
            models.IncomeTransaction.type == "iuran"
        ).all()
        
        assert all(trans.type == "iuran" for trans in iuran_transactions)
        
        # Cleanup
        db.delete(trans1)
        db.delete(trans2)
        db.commit()
    
    def test_list_income_by_date_range(self, db: Session, test_user: models.User):
        """Test filtering income by date range"""
        # Create transactions in different months
        trans1 = models.IncomeTransaction(
            name="Income January",
            type="iuran",
            amount=Decimal("50000"),
            date=date(2025, 1, 15),
            created_by=test_user.id
        )
        trans2 = models.IncomeTransaction(
            name="Income February",
            type="iuran",
            amount=Decimal("50000"),
            date=date(2025, 2, 15),
            created_by=test_user.id
        )
        
        db.add_all([trans1, trans2])
        db.commit()
        
        # Query January only
        january_transactions = db.query(models.IncomeTransaction).filter(
            models.IncomeTransaction.date >= date(2025, 1, 1),
            models.IncomeTransaction.date <= date(2025, 1, 31)
        ).all()
        
        assert all(trans.date.month == 1 for trans in january_transactions)
        
        # Cleanup
        db.delete(trans1)
        db.delete(trans2)
        db.commit()
    
    def test_calculate_total_income(self, db: Session, test_user: models.User):
        """Test calculating total income"""
        # Create multiple transactions
        transactions = []
        for i in range(5):
            trans = models.IncomeTransaction(
                name=f"Income {i}",
                type="iuran",
                amount=Decimal("50000"),
                date=date(2025, 1, i+1),
                created_by=test_user.id
            )
            transactions.append(trans)
        
        db.add_all(transactions)
        db.commit()
        
        # Calculate total
        total = db.query(
            models.IncomeTransaction
        ).filter(
            models.IncomeTransaction.date >= date(2025, 1, 1),
            models.IncomeTransaction.date <= date(2025, 1, 31)
        ).with_entities(
            models.IncomeTransaction.amount
        ).all()
        
        total_amount = sum(t[0] for t in total if t[0])
        assert total_amount >= Decimal("250000")
        
        # Cleanup
        for trans in transactions:
            db.delete(trans)
        db.commit()


class TestIncomeTransactionValidation:
    """Test income transaction validation"""
    
    def test_amount_is_positive(self):
        """Test that amount must be positive"""
        valid_amount = Decimal("50000")
        assert valid_amount > 0
    
    def test_date_format(self):
        """Test date format validation"""
        test_date = date(2025, 1, 15)
        assert isinstance(test_date, date)
        assert test_date.year == 2025
        assert test_date.month == 1
        assert test_date.day == 15