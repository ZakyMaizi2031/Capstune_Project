import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
MODEL_DIR = BASE_DIR / "models"
MODEL_PATH = MODEL_DIR / "mobilenetv2_chili_final.h5"
UPLOAD_DIR = BASE_DIR / "uploaded_images"
DATABASE_URL = "sqlite:///./chilicare.db"  # bisa ganti ke postgresql

# Pastikan folder upload ada
UPLOAD_DIR.mkdir(exist_ok=True)

# Kelas penyakit (wajib sama dengan training)
CLASS_NAMES = ["Antraknosa", "Busuk Basah", "Busuk Kering", "Virus", "Sehat"]