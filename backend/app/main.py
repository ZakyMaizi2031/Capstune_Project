from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from .database import engine, Base
from .routers import predict, encyclopedia, history
from .ml.model_loader import load_model
from .config import UPLOAD_DIR

# Buat tabel database
Base.metadata.create_all(bind=engine)

# Load model AI saat startup
load_model()

app = FastAPI(title="ChiliCare API", description="Deteksi penyakit cabai merah", version="1.0.0")

# CORS untuk Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount folder static untuk mengakses gambar hasil upload
app.mount("/static", StaticFiles(directory=str(UPLOAD_DIR)), name="static")

# Include routers
app.include_router(predict.router)
app.include_router(encyclopedia.router)
app.include_router(history.router)

@app.get("/")
async def root():
    return {"message": "ChiliCare API is running"}