import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    PROJECT_NAME: str = "ChiliCare API"
    # Mengambil variabel dari .env atau default ke root@localhost
    DB_USER = os.getenv("DB_USER", "root")
    DB_PASS = os.getenv("DB_PASS", "")
    DB_HOST = os.getenv("DB_HOST", "localhost")
    DB_NAME = os.getenv("DB_NAME", "db_chilicare")
    
    DATABASE_URL = f"mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_HOST}/{DB_NAME}"
    UPLOAD_DIR = "static/uploads"
    MODEL_PATH = "ml_models/mobilenetv2_chili_final.h5"

settings = Settings()