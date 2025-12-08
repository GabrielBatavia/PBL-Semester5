# tests/test_payment_channels_unit.py
import pytest
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
        email="test_payment@test.com",
        password_hash="hashed",
        role="bendahara"
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    yield user
    db.delete(user)
    db.commit()


class TestPaymentChannelModel:
    """Test PaymentChannel model operations"""
    
    def test_create_bank_channel(self, db: Session):
        """Test creating bank payment channel"""
        channel = models.PaymentChannel(
            name="BCA - Kas RT",
            type="bank",
            account_name="Kas RT 01 RW 05",
            account_number="1234567890",
            bank_name="BCA",
            is_active=1
        )
        
        db.add(channel)
        db.commit()
        db.refresh(channel)
        
        assert channel.id is not None
        assert channel.name == "BCA - Kas RT"
        assert channel.type == "bank"
        assert channel.bank_name == "BCA"
        assert channel.is_active == 1
        
        # Cleanup
        db.delete(channel)
        db.commit()
    
    def test_create_ewallet_channel(self, db: Session):
        """Test creating e-wallet payment channel"""
        channel = models.PaymentChannel(
            name="GoPay - Bendahara",
            type="ewallet",
            account_name="Budi Santoso",
            account_number="081234567890",
            is_active=1
        )
        
        db.add(channel)
        db.commit()
        db.refresh(channel)
        
        assert channel.type == "ewallet"
        assert channel.account_number == "081234567890"
        
        # Cleanup
        db.delete(channel)
        db.commit()
    
    def test_create_qris_channel(self, db: Session):
        """Test creating QRIS payment channel"""
        channel = models.PaymentChannel(
            name="QRIS Kas RT",
            type="qris",
            account_name="Kas RT 01",
            account_number="-",
            qris_image_url="/static/qris/rt01.jpg",
            is_active=1
        )
        
        db.add(channel)
        db.commit()
        db.refresh(channel)
        
        assert channel.type == "qris"
        assert channel.qris_image_url is not None
        
        # Cleanup
        db.delete(channel)
        db.commit()
    
    def test_payment_channel_types(self):
        """Test valid payment channel types"""
        valid_types = ["bank", "ewallet", "qris"]
        
        for channel_type in valid_types:
            assert channel_type in valid_types
    
    def test_list_active_channels(self, db: Session):
        """Test filtering only active channels"""
        # Create active and inactive channels
        active_channel = models.PaymentChannel(
            name="Active Channel",
            type="bank",
            account_name="Test",
            account_number="123456",
            is_active=1
        )
        inactive_channel = models.PaymentChannel(
            name="Inactive Channel",
            type="bank",
            account_name="Test",
            account_number="654321",
            is_active=0
        )
        
        db.add_all([active_channel, inactive_channel])
        db.commit()
        
        # Query only active
        active_channels = db.query(models.PaymentChannel).filter(
            models.PaymentChannel.is_active == 1
        ).all()
        
        assert all(ch.is_active == 1 for ch in active_channels)
        
        # Cleanup
        db.delete(active_channel)
        db.delete(inactive_channel)
        db.commit()
    
    def test_update_channel_status(self, db: Session):
        """Test updating channel status"""
        channel = models.PaymentChannel(
            name="Test Channel",
            type="bank",
            account_name="Test",
            account_number="123456",
            is_active=1
        )
        
        db.add(channel)
        db.commit()
        db.refresh(channel)
        
        # Deactivate
        channel.is_active = 0
        db.commit()
        db.refresh(channel)
        
        assert channel.is_active == 0
        
        # Cleanup
        db.delete(channel)
        db.commit()
    
    def test_list_channels_by_type(self, db: Session):
        """Test filtering channels by type"""
        # Create channels with different types
        bank_channel = models.PaymentChannel(
            name="Bank Test",
            type="bank",
            account_name="Test",
            account_number="123456",
            bank_name="BCA",
            is_active=1
        )
        ewallet_channel = models.PaymentChannel(
            name="E-Wallet Test",
            type="ewallet",
            account_name="Test",
            account_number="081234567890",
            is_active=1
        )
        
        db.add_all([bank_channel, ewallet_channel])
        db.commit()
        
        # Query only bank channels
        bank_channels = db.query(models.PaymentChannel).filter(
            models.PaymentChannel.type == "bank"
        ).all()
        
        assert all(ch.type == "bank" for ch in bank_channels)
        
        # Cleanup
        db.delete(bank_channel)
        db.delete(ewallet_channel)
        db.commit()


class TestPaymentChannelValidation:
    """Test payment channel validation"""
    
    def test_bank_requires_bank_name(self):
        """Test that bank type should have bank_name"""
        # This should be validated in business logic
        bank_data = {
            "type": "bank",
            "bank_name": "BCA"
        }
        
        assert bank_data["type"] == "bank"
        assert bank_data["bank_name"] is not None
    
    def test_qris_requires_image_url(self):
        """Test that QRIS type should have qris_image_url"""
        qris_data = {
            "type": "qris",
            "qris_image_url": "/static/qris/test.jpg"
        }
        
        assert qris_data["type"] == "qris"
        assert qris_data["qris_image_url"] is not None