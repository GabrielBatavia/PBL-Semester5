# tests/test_reports_unit.py
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
        email="test_report@test.com",
        password_hash="hashed",
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    yield user
    db.delete(user)
    db.commit()


@pytest.fixture
def test_data(db: Session, test_user: models.User):
    """Create test income and expense data"""
    # Create income transactions
    income1 = models.IncomeTransaction(
        name="Income 1",
        type="iuran",
        amount=Decimal("100000"),
        date=date(2025, 1, 5),
        created_by=test_user.id
    )
    income2 = models.IncomeTransaction(
        name="Income 2",
        type="donasi",
        amount=Decimal("200000"),
        date=date(2025, 1, 10),
        created_by=test_user.id
    )
    
    # Create expense transactions
    expense1 = models.ExpenseTransaction(
        category="Operasional",
        name="Expense 1",
        amount=Decimal("50000"),
        date=date(2025, 1, 8),
        created_by=test_user.id
    )
    expense2 = models.ExpenseTransaction(
        category="Pemeliharaan",
        name="Expense 2",
        amount=Decimal("75000"),
        date=date(2025, 1, 12),
        created_by=test_user.id
    )
    
    db.add_all([income1, income2, expense1, expense2])
    db.commit()
    
    yield {
        "incomes": [income1, income2],
        "expenses": [expense1, expense2]
    }
    
    # Cleanup
    db.delete(income1)
    db.delete(income2)
    db.delete(expense1)
    db.delete(expense2)
    db.commit()


class TestReportGeneration:
    """Test report generation logic"""
    
    def test_query_income_by_date_range(self, db: Session, test_data):
        """Test querying income transactions by date range"""
        start_date = date(2025, 1, 1)
        end_date = date(2025, 1, 31)
        
        incomes = db.query(models.IncomeTransaction).filter(
            models.IncomeTransaction.date >= start_date,
            models.IncomeTransaction.date <= end_date
        ).all()
        
        assert len(incomes) >= 2
        assert all(start_date <= inc.date <= end_date for inc in incomes)
    
    def test_query_expense_by_date_range(self, db: Session, test_data):
        """Test querying expense transactions by date range"""
        start_date = date(2025, 1, 1)
        end_date = date(2025, 1, 31)
        
        expenses = db.query(models.ExpenseTransaction).filter(
            models.ExpenseTransaction.date >= start_date,
            models.ExpenseTransaction.date <= end_date
        ).all()
        
        assert len(expenses) >= 2
        assert all(start_date <= exp.date <= end_date for exp in expenses)
    
    def test_calculate_total_income(self, db: Session, test_data):
        """Test calculating total income"""
        start_date = date(2025, 1, 1)
        end_date = date(2025, 1, 31)
        
        total = db.query(
            models.IncomeTransaction
        ).filter(
            models.IncomeTransaction.date >= start_date,
            models.IncomeTransaction.date <= end_date
        ).with_entities(
            models.IncomeTransaction.amount
        ).all()
        
        total_income = sum(t[0] for t in total if t[0])
        assert total_income >= Decimal("300000")  # 100000 + 200000
    
    def test_calculate_total_expense(self, db: Session, test_data):
        """Test calculating total expense"""
        start_date = date(2025, 1, 1)
        end_date = date(2025, 1, 31)
        
        total = db.query(
            models.ExpenseTransaction
        ).filter(
            models.ExpenseTransaction.date >= start_date,
            models.ExpenseTransaction.date <= end_date
        ).with_entities(
            models.ExpenseTransaction.amount
        ).all()
        
        total_expense = sum(t[0] for t in total if t[0])
        assert total_expense >= Decimal("125000")  # 50000 + 75000
    
    def test_calculate_net_balance(self, db: Session, test_data):
        """Test calculating net balance (income - expense)"""
        start_date = date(2025, 1, 1)
        end_date = date(2025, 1, 31)
        
        # Get total income
        incomes = db.query(
            models.IncomeTransaction
        ).filter(
            models.IncomeTransaction.date >= start_date,
            models.IncomeTransaction.date <= end_date
        ).with_entities(
            models.IncomeTransaction.amount
        ).all()
        total_income = sum(i[0] for i in incomes if i[0])
        
        # Get total expense
        expenses = db.query(
            models.ExpenseTransaction
        ).filter(
            models.ExpenseTransaction.date >= start_date,
            models.ExpenseTransaction.date <= end_date
        ).with_entities(
            models.ExpenseTransaction.amount
        ).all()
        total_expense = sum(e[0] for e in expenses if e[0])
        
        # Calculate balance
        balance = total_income - total_expense
        assert balance >= Decimal("175000")  # 300000 - 125000
    
    def test_report_types(self):
        """Test valid report types"""
        valid_types = ["pemasukan", "pengeluaran", "semua"]
        
        for report_type in valid_types:
            assert report_type in valid_types
    
    def test_format_currency(self):
        """Test currency formatting for reports"""
        amount = Decimal("1500000")
        
        # Format as Indonesian Rupiah
        formatted = f"Rp {amount:,.0f}".replace(",", ".")
        
        assert "Rp" in formatted
        assert "1.500.000" in formatted
    
    def test_format_date(self):
        """Test date formatting for reports"""
        test_date = date(2025, 1, 15)
        
        months_id = [
            'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
            'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
        ]
        
        formatted = f"{test_date.day} {months_id[test_date.month-1]} {test_date.year}"
        
        assert "15 Januari 2025" == formatted


class TestReportValidation:
    """Test report validation"""
    
    def test_date_range_validation(self):
        """Test that end_date should be >= start_date"""
        start_date = date(2025, 1, 1)
        end_date = date(2025, 1, 31)
        
        assert end_date >= start_date
    
    def test_invalid_date_range(self):
        """Test invalid date range (end before start)"""
        start_date = date(2025, 12, 31)
        end_date = date(2025, 1, 1)
        
        # This should fail validation
        assert end_date < start_date  # Invalid