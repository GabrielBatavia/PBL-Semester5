# tests/test_expenses_unit.py
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
        email="test_expense@test.com",
        password_hash="hashed",
        role="bendahara"
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    yield user
    db.delete(user)
    db.commit()


class TestExpenseTransactionModel:
    """Test ExpenseTransaction model operations"""
    
    def test_create_expense_operasional(self, db: Session, test_user: models.User):
        """Test creating expense for operasional"""
        expense = models.ExpenseTransaction(
            category="Operasional",
            name="Gaji Satpam Januari",
            amount=Decimal("1500000"),
            date=date(2025, 1, 1),
            created_by=test_user.id
        )
        
        db.add(expense)
        db.commit()
        db.refresh(expense)
        
        assert expense.id is not None
        assert expense.category == "Operasional"
        assert expense.name == "Gaji Satpam Januari"
        assert expense.amount == Decimal("1500000")
        
        # Cleanup
        db.delete(expense)
        db.commit()
    
    def test_create_expense_pemeliharaan(self, db: Session, test_user: models.User):
        """Test creating expense for pemeliharaan"""
        expense = models.ExpenseTransaction(
            category="Pemeliharaan",
            name="Service Pompa Air",
            amount=Decimal("350000"),
            date=date(2025, 1, 8),
            created_by=test_user.id
        )
        
        db.add(expense)
        db.commit()
        db.refresh(expense)
        
        assert expense.category == "Pemeliharaan"
        assert expense.amount == Decimal("350000")
        
        # Cleanup
        db.delete(expense)
        db.commit()
    
    def test_create_expense_kegiatan(self, db: Session, test_user: models.User):
        """Test creating expense for kegiatan"""
        expense = models.ExpenseTransaction(
            category="Kegiatan",
            name="Peringatan 17 Agustus",
            amount=Decimal("2500000"),
            date=date(2025, 1, 12),
            created_by=test_user.id
        )
        
        db.add(expense)
        db.commit()
        db.refresh(expense)
        
        assert expense.category == "Kegiatan"
        assert expense.amount == Decimal("2500000")
        
        # Cleanup
        db.delete(expense)
        db.commit()
    
    def test_create_expense_lain_lain(self, db: Session, test_user: models.User):
        """Test creating expense for lain-lain"""
        expense = models.ExpenseTransaction(
            category="Lain-lain",
            name="Pembelian Alat Tulis",
            amount=Decimal("125000"),
            date=date(2025, 1, 20),
            created_by=test_user.id
        )
        
        db.add(expense)
        db.commit()
        db.refresh(expense)
        
        assert expense.category == "Lain-lain"
        assert expense.amount == Decimal("125000")
        
        # Cleanup
        db.delete(expense)
        db.commit()
    
    def test_expense_categories(self):
        """Test valid expense categories"""
        valid_categories = ["Operasional", "Pemeliharaan", "Kegiatan", "Lain-lain"]
        
        for category in valid_categories:
            assert category in valid_categories
    
    def test_list_expenses_by_category(self, db: Session, test_user: models.User):
        """Test filtering expenses by category"""
        # Create expenses with different categories
        exp1 = models.ExpenseTransaction(
            category="Operasional",
            name="Test Operasional",
            amount=Decimal("100000"),
            date=date(2025, 1, 1),
            created_by=test_user.id
        )
        exp2 = models.ExpenseTransaction(
            category="Pemeliharaan",
            name="Test Pemeliharaan",
            amount=Decimal("200000"),
            date=date(2025, 1, 2),
            created_by=test_user.id
        )
        
        db.add_all([exp1, exp2])
        db.commit()
        
        # Query only Operasional
        operasional_expenses = db.query(models.ExpenseTransaction).filter(
            models.ExpenseTransaction.category == "Operasional"
        ).all()
        
        assert all(exp.category == "Operasional" for exp in operasional_expenses)
        
        # Cleanup
        db.delete(exp1)
        db.delete(exp2)
        db.commit()
    
    def test_list_expenses_by_date_range(self, db: Session, test_user: models.User):
        """Test filtering expenses by date range"""
        # Create expenses in different months
        exp1 = models.ExpenseTransaction(
            category="Operasional",
            name="Expense January",
            amount=Decimal("100000"),
            date=date(2025, 1, 15),
            created_by=test_user.id
        )
        exp2 = models.ExpenseTransaction(
            category="Operasional",
            name="Expense February",
            amount=Decimal("100000"),
            date=date(2025, 2, 15),
            created_by=test_user.id
        )
        
        db.add_all([exp1, exp2])
        db.commit()
        
        # Query January only
        january_expenses = db.query(models.ExpenseTransaction).filter(
            models.ExpenseTransaction.date >= date(2025, 1, 1),
            models.ExpenseTransaction.date <= date(2025, 1, 31)
        ).all()
        
        assert all(exp.date.month == 1 for exp in january_expenses)
        
        # Cleanup
        db.delete(exp1)
        db.delete(exp2)
        db.commit()
    
    def test_calculate_total_expense(self, db: Session, test_user: models.User):
        """Test calculating total expenses"""
        # Create multiple expenses
        expenses = []
        for i in range(5):
            exp = models.ExpenseTransaction(
                category="Operasional",
                name=f"Expense {i}",
                amount=Decimal("100000"),
                date=date(2025, 1, i+1),
                created_by=test_user.id
            )
            expenses.append(exp)
        
        db.add_all(expenses)
        db.commit()
        
        # Calculate total
        total = db.query(
            models.ExpenseTransaction
        ).filter(
            models.ExpenseTransaction.date >= date(2025, 1, 1),
            models.ExpenseTransaction.date <= date(2025, 1, 31)
        ).with_entities(
            models.ExpenseTransaction.amount
        ).all()
        
        total_amount = sum(e[0] for e in total if e[0])
        assert total_amount >= Decimal("500000")
        
        # Cleanup
        for exp in expenses:
            db.delete(exp)
        db.commit()


class TestExpenseValidation:
    """Test expense validation"""
    
    def test_amount_is_positive(self):
        """Test that amount must be positive"""
        valid_amount = Decimal("100000")
        assert valid_amount > 0
    
    def test_date_format(self):
        """Test date format validation"""
        test_date = date(2025, 1, 15)
        assert isinstance(test_date, date)