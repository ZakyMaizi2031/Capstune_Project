from fastapi import APIRouter, UploadFile, File, HTTPException, Depends
from sqlalchemy.orm import Session
from ..database import get_db
from ..models import User, Penyakit, Rekomendasi, RiwayatDeteksi
from ..ml.preprocess import preprocess_image
from ..ml.model_loader import predict
from ..utils.file_upload import save_upload_file
from ..schemas import PredictionResponse
from ..config import UPLOAD_DIR
import os

router = APIRouter(prefix="/api", tags=["predict"])

# Helper: ambil detail penyakit berdasarkan nama (dari DB atau fallback)
def get_penyakit_detail(db: Session, nama_penyakit: str):
    penyakit = db.query(Penyakit).filter(Penyakit.nama_penyakit == nama_penyakit).first()
    if not penyakit:
        return {
            "gejala": "Data gejala belum tersedia",
            "penyebab": "Data penyebab belum tersedia",
            "penanganan": "Konsultasikan dengan ahli pertanian",
            "obat": "-"
        }
    rekom = db.query(Rekomendasi).filter(Rekomendasi.id_penyakit == penyakit.id_penyakit).first()
    return {
        "gejala": penyakit.gejala_visual or "",
        "penyebab": penyakit.penyebab or "",
        "penanganan": rekom.langkah_penanganan if rekom else "",
        "obat": rekom.nama_obat if rekom else ""
    }

@router.post("/predict", response_model=PredictionResponse)
async def predict_endpoint(
    file: UploadFile = File(...),
    user_id: int = 1,  # Sementara, nanti pakai auth JWT
    db: Session = Depends(get_db)
):
    # Validasi file
    if not file.filename.lower().endswith(('.png', '.jpg', '.jpeg')):
        raise HTTPException(400, "Hanya file .jpg/.png yang diperbolehkan")
    
    # Baca bytes gambar
    image_bytes = await file.read()
    if len(image_bytes) == 0:
        raise HTTPException(400, "File kosong")
    
    # Preprocess
    try:
        img_array = preprocess_image(image_bytes)
    except Exception as e:
        raise HTTPException(400, f"Gagal memproses gambar: {str(e)}")
    
    # Prediksi
    predicted_class, confidence = predict(img_array)
    
    # Simpan gambar ke disk
    saved_path = await save_upload_file(file, subdir="predictions")
    full_path = str(UPLOAD_DIR / saved_path)
    
    # Cari id_penyakit
    penyakit_obj = db.query(Penyakit).filter(Penyakit.nama_penyakit == predicted_class).first()
    penyakit_id = penyakit_obj.id_penyakit if penyakit_obj else None
    
    # Simpan riwayat
    riwayat = RiwayatDeteksi(
        id_user=user_id,
        id_penyakit=penyakit_id,
        file_foto_input=full_path,
        hasil_prediksi=predicted_class,
        tingkat_akurasi=confidence
    )
    db.add(riwayat)
    db.commit()
    
    # Ambil detail
    detail = get_penyakit_detail(db, predicted_class)
    
    # URL foto untuk diakses (misal static)
    foto_url = f"/static/predictions/{saved_path.split('/')[-1]}"
    
    return {
        "status": "success",
        "prediksi": predicted_class,
        "akurasi": confidence,
        "gejala": detail["gejala"],
        "penyebab": detail["penyebab"],
        "penanganan": detail["penanganan"],
        "obat": detail["obat"],
        "foto_url": foto_url
    }