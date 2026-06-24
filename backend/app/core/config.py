import os
from dotenv import load_dotenv

load_dotenv()

# BASE_DIR dihitung dari lokasi file config.py agar aman saat server dijalankan dari cwd berbeda
BASE_DIR_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))  # backend/app/core -> backend/app -> backend
# backend/app/core/config.py -> BASE_DIR_ROOT = backend/

class Settings:
    PROJECT_NAME: str = "ChiliCare API"
    # Mengambil variabel dari .env atau default ke root@localhost
    DB_USER = os.getenv("DB_USER", "root")
    DB_PASS = os.getenv("DB_PASS", "")
    DB_HOST = os.getenv("DB_HOST", "localhost")
    DB_NAME = os.getenv("DB_NAME", "chilicare_db")

    DATABASE_URL = f"mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_HOST}/{DB_NAME}"

    # Static files mengarah ke folder backend/static/
    STATIC_DIR = os.path.join(BASE_DIR_ROOT, "static")
    UPLOAD_DIR = os.path.join(STATIC_DIR, "uploads")

    # Model path dibuat absolut
    MODEL_PATH = os.path.join(BASE_DIR_ROOT, "ml_models", "mobilenetv2_chili_final.h5")

    # JWT Settings
    SECRET_KEY: str = os.getenv("SECRET_KEY", "super-secret-chilicare-key-2026")
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7 # 7 days


settings = Settings()
