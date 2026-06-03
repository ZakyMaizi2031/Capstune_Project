from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from ..database import get_db
from ..models import Penyakit, Rekomendasi
from ..schemas import EncyclopediaItem

router = APIRouter(prefix="/api", tags=["encyclopedia"])

@router.get("/ensiklopedia", response_model=list[EncyclopediaItem])
async def get_ensiklopedia(db: Session = Depends(get_db)):
    penyakit_list = db.query(Penyakit).all()
    result = []
    for p in penyakit_list:
        rekom = db.query(Rekomendasi).filter(Rekomendasi.id_penyakit == p.id_penyakit).first()
        result.append({
            "id": p.id_penyakit,
            "nama": p.nama_penyakit,
            "gejala": p.gejala_visual or "",
            "penyebab": p.penyebab or "",
            "foto_referensi": p.foto_referensi,
            "langkah_penanganan": rekom.langkah_penanganan if rekom else "",
            "nama_obat": rekom.nama_obat if rekom else ""
        })
    return result