import os
import uuid
from ..core.config import settings

def save_image(file):
    """Logika menyimpan file gambar ke folder static/uploads/"""
    # Cek apakah folder static/uploads sudah ada, jika belum buat otomatis
    if not os.path.exists(settings.UPLOAD_DIR):
        os.makedirs(settings.UPLOAD_DIR)

    # Buat nama file unik menggunakan UUID agar tidak ada file yang tertimpa
    file_ext = file.filename.split(".")[-1]
    unique_filename = f"chili_{uuid.uuid4().hex}.{file_ext}"
    
    file_path = os.path.join(settings.UPLOAD_DIR, unique_filename)
    
    with open(file_path, "wb") as f:
        f.write(file.file.read())
        
    # Mengembalikan path file untuk disimpan di kolom 'file_foto_input' MySQL
    return file_path

# Alias untuk kompatibilitas dengan detection.py
def save_upload_file(file):
    """Wrapper untuk save_image - untuk kompatibilitas dengan detection.py"""
    return save_image(file)