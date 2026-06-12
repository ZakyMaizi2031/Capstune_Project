import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from sqlalchemy.orm import Session

# Import komponen internal sesuai struktur folder
from app.database import engine, Base, SessionLocal
from app.models import User, Penyakit, Rekomendasi
from app.api import auth, encyclopedia, detection, admin
from app.core.config import settings

# 1. OTOMATISASI DATABASE
# Membuat semua tabel (users, penyakit, rekomendasi, riwayat) jika belum ada di MySQL
Base.metadata.create_all(bind=engine)

# 2. INISIALISASI APP
app = FastAPI(
    title="ChiliCare Backend API",
    description="Sistem Deteksi Penyakit Cabai Merah & Manajemen Ensiklopedia",
    version="1.0.0"
)

# 3. KONFIGURASI CORS (PENTING: Agar Flutter & Web Dashboard bisa akses API)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # Mengizinkan semua akses (Mobile & Web)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 4. KONFIGURASI FOLDER STATIC (Untuk simpan & tampilkan foto hasil scan)
if not os.path.exists(settings.UPLOAD_DIR):
    os.makedirs(settings.UPLOAD_DIR, exist_ok=True)

# Folder static bisa diakses via URL: http://localhost:8000/static/...
app.mount("/static", StaticFiles(directory="static"), name="static")

# 5. REGISTRASI ROUTER (Menghubungkan endpoint API)
app.include_router(auth.router)           # Login & Register
app.include_router(encyclopedia.router)   # Katalog Penyakit untuk Petani
app.include_router(detection.router)      # Proses Deteksi CNN
app.include_router(admin.router)          # CRUD Dashboard Admin

# 6. AUTO-SEEDING (Dijalankan otomatis saat server startup)
@app.on_event("startup")
def startup_seeding():
    db = SessionLocal()
    try:
        print("\n>>> [SYSTEM] Menjalankan Sinkronisasi Data ChiliCare...")

        # --- A. Pembuatan Akun Admin Otomatis ---
        admin_email = "admin@chilicare.com"
        admin_exists = db.query(User).filter(User.email == admin_email).first()
        
        if not admin_exists:
            new_admin = User(
                nama_lengkap="Administrator ChiliCare",
                email=admin_email,
                password="adminchilicare", # Password default admin
                role="admin"
            )
            db.add(new_admin)
            db.commit()
            print(f"[SEED] Akun Admin Siap: {admin_email} | pass: adminchilicare")

        # --- B. Pengisian Data Ensiklopedia (5 Kelas Penyakit) ---
        if db.query(Penyakit).count() == 0:
            master_data = [
                {
                    "nama": "Antraknosa",
                    "gejala": "Bercak coklat kehitaman pada buah cabai, melingkar seperti pusaran api.",
                    "penyebab": "Jamur Colletotrichum capsici",
                    "obat": "Fungisida Mankozeb atau Propinib.",
                    "langkah": "Musnahkan buah terinfeksi, atur jarak tanam agar tidak terlalu lembab."
                },
                {
                    "nama": "Busuk Basah",
                    "gejala": "Buah melunak, berair, mengkerut, dan berbau busuk menyengat.",
                    "penyebab": "Bakteri Erwinia carotovora",
                    "obat": "Bakterisida Streptomisin (misal: Agrept).",
                    "langkah": "Perbaiki drainase tanah, hindari penyiraman langsung ke buah saat malam."
                },
                {
                    "nama": "Busuk Kering",
                    "gejala": "Buah mengkerut, kering, kusam, dan seringkali rontok sebelum matang.",
                    "penyebab": "Jamur Fusarium capsici",
                    "obat": "Fungisida sistemik berbahan aktif Benomil.",
                    "langkah": "Lakukan rotasi tanaman dengan tanaman yang bukan keluarga terong-terongan."
                },
                {
                    "nama": "Virus",
                    "gejala": "Daun menguning (bule), mengeriting ke atas, dan tanaman menjadi kerdil.",
                    "penyebab": "Gemini Virus (dibawa oleh Kutu Kebul)",
                    "obat": "Insektisida Abamektin (untuk membasmi kutu pembawa virus).",
                    "langkah": "Gunakan bibit unggul tahan virus, pasang perangkap kuning di lahan."
                },
                {
                    "nama": "Sehat",
                    "gejala": "Buah berwarna merah merata, tekstur kencang, kulit mulus tanpa bercak.",
                    "penyebab": "Perawatan Optimal",
                    "obat": "Pupuk NPK seimbang dan rutin penyiraman.",
                    "langkah": "Pertahankan kebersihan lahan dan pantau nutrisi tanaman secara berkala."
                }
            ]

            for item in master_data:
                # 1. Simpan ke tabel Penyakit
                p = Penyakit(
                    nama_penyakit=item['nama'],
                    gejala_visual=item['gejala'],
                    penyebab=item['penyebab'],
                    foto_referensi=f"static/placeholder_{item['nama'].lower()}.jpg"
                )
                db.add(p)
                db.flush() # Mendapatkan ID penyakit untuk relasi

                # 2. Simpan ke tabel Rekomendasi (Terhubung via ID)
                r = Rekomendasi(
                    id_penyakit=p.id_penyakit,
                    langkah_penanganan=item['langkah'],
                    nama_obat=item['obat']
                )
                db.add(r)
            
            db.commit()
            print("[SEED] 5 Master Data Ensiklopedia Berhasil Disuntikkan!")

    except Exception as e:
        print(f"[ERROR] Seeding gagal: {e}")
        db.rollback()
    finally:
        db.close()
        print(">>> [SYSTEM] Sinkronisasi Selesai.\n")

# 7. ENDPOINT ROOT (Untuk Cek Status Server)
@app.get("/", tags=["Root"])
def check_status():
    return {
        "project": "ChiliCare API",
        "status": "Online",
        "database": "Connected",
        "docs": "/docs"
    }