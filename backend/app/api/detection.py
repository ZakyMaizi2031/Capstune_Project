from fastapi import APIRouter, Depends, UploadFile, File, Form, HTTPException
from sqlalchemy.orm import Session
from .. import models, database
from ..services import storage, ml_service

router = APIRouter(prefix="/api/predict", tags=["Detection"])

@router.post("/")
async def predict(id_user: int = Form(...), file: UploadFile = File(...), db: Session = Depends(database.get_db)):
    """Endpoint untuk mendeteksi penyakit cabai berdasarkan gambar"""
    try:
        # 1. Validasi user exists
        user = db.query(models.User).filter(models.User.id_user == id_user).first()
        if not user:
            raise HTTPException(status_code=404, detail="User tidak ditemukan")

        # 2. Simpan Gambar
        path = storage.save_upload_file(file)
        
        # 3. Jalankan Model CNN
        label, acc = ml_service.run_inference(path)
        
        # 4. Cari info penyakit dari database
        penyakit = db.query(models.Penyakit).filter(models.Penyakit.nama_penyakit == label).first()
        
        if not penyakit:
            raise HTTPException(status_code=404, detail=f"Data penyakit '{label}' tidak ditemukan di database")
        
        # 5. Simpan Riwayat Deteksi ke database
        log = models.RiwayatDeteksi(
            id_user=id_user, 
            id_penyakit=penyakit.id_penyakit,
            file_foto_input=path, 
            hasil_prediksi=label, 
            tingkat_akurasi=acc
        )
        db.add(log)
        db.commit()
        db.refresh(log)
        
        # 6. Return hasil ke Flutter
        # Perlu kirim rekomendasi agar Flutter bisa render langkah & obat
        rekomendasi = None
        try:
            rekomendasi = penyakit.rekomendasi
        except Exception:
            rekomendasi = None

        return {
            "id_riwayat": log.id_riwayat,
            "label": label,
            "confidence": acc,
            "penyakit_info": {
                "id_penyakit": penyakit.id_penyakit,
                "nama_penyakit": penyakit.nama_penyakit,
                "gejala_visual": penyakit.gejala_visual,
                "penyebab": penyakit.penyebab,
                "foto_referensi": penyakit.foto_referensi,
                "rekomendasi": (
                    {
                        "langkah_penanganan": rekomendasi.langkah_penanganan,
                        "nama_obat": rekomendasi.nama_obat,
                    }
                    if rekomendasi is not None
                    else None
                ),
            },
        }
        
    except HTTPException as e:
        raise e
    except Exception as e:
        db.rollback()
        print(f"[ERROR] detect error: {e}")
        raise HTTPException(status_code=500, detail=f"Gagal memproses deteksi: {str(e)}")