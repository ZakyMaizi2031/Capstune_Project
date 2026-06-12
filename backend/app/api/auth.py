from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from .. import models, schemas, database

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
    
    return {"id_user": user.id_user, "nama": user.nama_lengkap, "role": user.role}

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
        role="petani" # <--- DIKUNCI DI SINI
    )
    
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return {"message": "Registrasi Petani Berhasil", "user": new_user.nama_lengkap}