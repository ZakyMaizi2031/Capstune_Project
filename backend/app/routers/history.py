from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from ..database import get_db
from ..models import RiwayatDeteksi
from ..schemas import HistoryItem

router = APIRouter(prefix="/api", tags=["history"])

@router.get("/history", response_model=list[HistoryItem])
async def get_history(user_id: int = 1, db: Session = Depends(get_db)):
    riwayat = db.query(RiwayatDeteksi).filter(RiwayatDeteksi.id_user == user_id).order_by(RiwayatDeteksi.tanggal_deteksi.desc()).all()
    return riwayat