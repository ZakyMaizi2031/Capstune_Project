from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class PredictionResponse(BaseModel):
    status: str
    prediksi: str
    akurasi: float
    gejala: str
    penyebab: str
    penanganan: str
    obat: str
    foto_url: str

class EncyclopediaItem(BaseModel):
    id: int
    nama: str
    gejala: str
    penyebab: str
    foto_referensi: Optional[str]
    langkah_penanganan: str
    nama_obat: str

class HistoryItem(BaseModel):
    id_riwayat: int
    tanggal_deteksi: datetime
    hasil_prediksi: str
    tingkat_akurasi: float
    file_foto_input: str