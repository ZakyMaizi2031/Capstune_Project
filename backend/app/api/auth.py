from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from sqlalchemy.orm import Session
from .. import models, schemas, database
from ..services import storage

router = APIRouter(prefix="/api/auth", tags=["Auth"])

@router.post("/login")
def login(data: schemas.UserLogin, db: Session = Depends(database.get_db)):
    # Pastikan memfilter email DAN password
    user = db.query(models.User).filter(
        models.User.email == data.email, 
        models.User.password == data.password
    ).first()
    
    if not user:
        raise HTTPException(status_code=401, detail="Email atau password salah")
    
    return {
        "id_user": user.id_user,
        "nama": user.nama_lengkap,
        "role": user.role,
        "foto_profil": user.foto_profil,
    }

@router.post("/register")
def register(data: schemas.UserCreate, db: Session = Depends(database.get_db)):
    # 1. Cek apakah email sudah terdaftar
    db_user = db.query(models.User).filter(models.User.email == data.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email sudah terdaftar!")

    # 2. Buat user baru, PAKSA role menjadi 'petani'
    new_user = models.User(
        nama_lengkap=data.nama,
        email=data.email,
        password=data.password, 
        role="petani",# <--- DIKUNCI DI SINI
        foto_profil=None    
    )
    
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return {"message": "Registrasi Petani Berhasil", "user": new_user.nama_lengkap}
@router.put("/update-profile/{id_user}")
async def update_profile(id_user: int, file: UploadFile = File(...), db: Session = Depends(database.get_db)):
    user = db.query(models.User).filter(models.User.id_user == id_user).first()
    
    # Simpan file menggunakan storage service yang sudah kita buat
    path = storage.save_image(file) # pastikan file tersimpan di static/uploads/
    
    user.foto_profil = path
    db.commit()
    
    return {"message": "Foto profil berhasil diperbarui", "path": path}