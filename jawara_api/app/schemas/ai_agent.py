# app/schemas/ai_agent.py
from pydantic import BaseModel
from typing import Optional

class MarketplaceAIResult(BaseModel):
    label: str          # contoh: "Bayam"
    confidence: float   # contoh: 0.93
    suggestion: Optional[str] = None
