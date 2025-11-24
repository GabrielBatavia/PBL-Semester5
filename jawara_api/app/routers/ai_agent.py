# app/routers/ai_agent.py
from fastapi import APIRouter, Depends, UploadFile, File
from ..deps import get_current_user
from ..schemas import ai_agent as ai_schemas
import httpx
import os

router = APIRouter(prefix="/ai", tags=["AI"])

AI_AGENT_BASE_URL = os.getenv("AI_AGENT_BASE_URL", "http://localhost:9000")  

@router.post(
    "/marketplace/analyze",
    response_model=ai_schemas.MarketplaceAIResult,
)
async def analyze_marketplace_image(
    image: UploadFile = File(...),
    current_user=Depends(get_current_user),
):
    """
    Endpoint yang dipanggil MOBILE.
    Di sini backend yang akan ngomong ke AI Agent.
    """

    # ==== MOCK dulu (belum ada model) ====
    # Nanti bagian ini diganti panggil AI_AGENT_BASE_URL.
    return ai_schemas.MarketplaceAIResult(
        label="Bayam (mock)",
        confidence=0.95,
        suggestion="Tulis nama: Bayam segar 1 ikat",
    )

    # ==== CONTOH NANTI KALAU SUDAH ADA AI AGENT ====
    # async with httpx.AsyncClient() as client:
    #     files = {"image": (image.filename, await image.read(), image.content_type)}
    #     resp = await client.post(
    #         f"{AI_AGENT_BASE_URL}/api/marketplace/analyze",
    #         files=files,
    #     )
    #     resp.raise_for_status()
    #     data = resp.json()
    #     return ai_schemas.MarketplaceAIResult(**data)
