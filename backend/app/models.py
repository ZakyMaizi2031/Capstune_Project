from sqlalchemy import Column, Integer, String, Text, Float, ForeignKey, DateTime
from sqlalchemy.sql import func
from .database import Base

class User(Base):
    __tablename__ = "users"
    id_user = Column(Integer, primary_key=True, index=True)
    nama_lengkap = Column(String(100), nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    role = Column(String(20), default="petani")

class Penyakit(Base):
    __tablename__ = "penyakit"
    id_penyakit = Column(Integer, primary_key=True, index=True)
    nama_penyakit = Column(String(100), nullable=False)
    gejala_visual = Column(Text)
    penyebab = Column(Text)
    foto_referensi = Column(String(255))

class Rekomendasi(Base):
    __tablename__ = "rekomendasi"
    id_rekomendasi = Column(Integer, primary_key=True, index=True)
    id_penyakit = Column(Integer, ForeignKey("penyakit.id_penyakit"))
    langkah_penanganan = Column(Text)
    nama_obat = Column(String(100))

class RiwayatDeteksi(Base):
    __tablename__ = "riwayat_deteksi"
    id_riwayat = Column(Integer, primary_key=True, index=True)
    id_user = Column(Integer, ForeignKey("users.id_user"))
    id_penyakit = Column(Integer, ForeignKey("penyakit.id_penyakit"))
    file_foto_input = Column(String(255), nullable=False)
    tanggal_deteksi = Column(DateTime(timezone=True), server_default=func.now())
    hasil_prediksi = Column(String(100))
    tingkat_akurasi = Column(Float)

class DatasetCitra(Base):
    __tablename__ = "dataset_citra"
    id_dataset = Column(Integer, primary_key=True, index=True)
    id_admin_pengunggah = Column(Integer, ForeignKey("users.id_user"))
    nama_file = Column(String(255), nullable=False)
    label_kategori = Column(String(100))
    tanggal_unggah = Column(DateTime(timezone=True), server_default=func.now())