from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from .. import models, database, schemas # Pastikan schemas sudah diupdate
from ..core.config import settings

router = APIRouter(prefix="/api/admin", tags=["Admin Management"])

# ==========================================
# 1. DASHBOARD STATS
# ==========================================

@router.get("/stats")
def get_dashboard_stats(db: Session = Depends(database.get_db)):
    """Ringkasan data untuk statistik di Web & Mobile Admin"""
    total_petani = db.query(models.User).filter(models.User.role == 'petani').count()
    total_penyakit = db.query(models.Penyakit).count()
    total_deteksi = db.query(models.RiwayatDeteksi).count()
    
    return {
        "total_users": total_petani,
        "total_diseases": total_penyakit,
        "total_scans": total_deteksi
    }

# ==========================================
# 2. USER MANAGEMENT (Kelola User)
# ==========================================

@router.get("/users")
def get_all_users(db: Session = Depends(database.get_db)):
    """Melihat daftar semua user (Admin & Petani)"""
    return db.query(models.User).all()

@router.delete("/users/{id_user}")
def delete_user(id_user: int, db: Session = Depends(database.get_db)):
    """Menghapus akun petani"""
    user = db.query(models.User).filter(models.User.id_user == id_user).first()
    if not user:
        raise HTTPException(status_code=404, detail="User tidak ditemukan")
    
    # Proteksi: Jangan biarkan menghapus admin lewat dashboard
    if user.role == "admin":
        raise HTTPException(status_code=403, detail="Tidak dapat menghapus akun Administrator")

    db.delete(user)
    db.commit()
    return {"message": "User berhasil dihapus"}

# ==========================================
# 3. ENCYCLOPEDIA CRUD (Kelola Penyakit)
# ==========================================

@router.get("/encyclopedia")
def admin_get_all_diseases(db: Session = Depends(database.get_db)):
    """Melihat list penyakit lengkap untuk tabel di Web Admin"""
    return db.query(models.Penyakit).all()

@router.post("/encyclopedia")
def admin_add_disease(data: schemas.EncyclopediaCreate, db: Session = Depends(database.get_db)):
    """TAMBAH: Membuat penyakit dan rekomendasi baru sekaligus"""
    # 1. Simpan ke tabel Penyakit
    new_p = models.Penyakit(
        nama_penyakit=data.nama_penyakit,
        gejala_visual=data.gejala_visual,
        penyebab=data.penyebab,
        foto_referensi="static/placeholder.jpg" # Default foto
    )
    db.add(new_p)
    db.flush() # Ambil ID penyakit yang baru dibuat

    # 2. Simpan ke tabel Rekomendasi
    new_r = models.Rekomendasi(
        id_penyakit=new_p.id_penyakit,
        langkah_penanganan=data.langkah_penanganan,
        nama_obat=data.nama_obat
    )
    db.add(new_r)
    db.commit()
    return {"message": "Data berhasil ditambahkan ke Ensiklopedia"}

@router.put("/encyclopedia/{id_penyakit}")
def admin_update_disease(id_penyakit: int, data: schemas.EncyclopediaUpdate, db: Session = Depends(database.get_db)):
    """UPDATE: Mengubah data penyakit & rekomendasi"""
    db_p = db.query(models.Penyakit).filter(models.Penyakit.id_penyakit == id_penyakit).first()
    if not db_p:
        raise HTTPException(status_code=404, detail="Data tidak ditemukan")

    # Update tabel Penyakit
    if data.nama_penyakit: db_p.nama_penyakit = data.nama_penyakit
    if data.gejala_visual: db_p.gejala_visual = data.gejala_visual
    
    # Update tabel Rekomendasi
    db_r = db.query(models.Rekomendasi).filter(models.Rekomendasi.id_penyakit == id_penyakit).first()
    if db_r:
        if data.langkah_penanganan: db_r.langkah_penanganan = data.langkah_penanganan
        if data.nama_obat: db_r.nama_obat = data.nama_obat

    db.commit()
    return {"message": "Data ensiklopedia berhasil diperbarui"}

@router.delete("/encyclopedia/{id_penyakit}")
def admin_delete_disease(id_penyakit: int, db: Session = Depends(database.get_db)):
    """DELETE: Menghapus penyakit (Otomatis hapus rekomendasi karena Cascade)"""
    disease = db.query(models.Penyakit).filter(models.Penyakit.id_penyakit == id_penyakit).first()
    if not disease:
        raise HTTPException(status_code=404, detail="Data tidak ditemukan")
    
    db.delete(disease)
    db.commit()
    return {"message": "Data penyakit berhasil dihapus"}

# ==========================================
# 4. MONITORING (Riwayat Scan)
# ==========================================

@router.get("/history-monitor")
def get_all_user_logs(db: Session = Depends(database.get_db)):
    """Melihat semua riwayat scan dari seluruh petani"""
    logs = db.query(
        models.RiwayatDeteksi.id_riwayat,
        models.User.nama_lengkap.label("nama_petani"),
        models.RiwayatDeteksi.hasil_prediksi,
        models.RiwayatDeteksi.tingkat_akurasi,
        models.RiwayatDeteksi.tanggal_deteksi
    ).join(models.User, models.RiwayatDeteksi.id_user == models.User.id_user).all()
    
    return logs