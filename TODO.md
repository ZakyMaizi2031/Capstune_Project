# TODO - Perbaikan Backend ChiliCare

- [x] Update `backend/app/core/config.py` untuk path absolut: STATIC_DIR, UPLOAD_DIR, MODEL_PATH
- [x] Update `backend/app/main.py` mount StaticFiles pakai STATIC_DIR
- [x] Update `backend/app/services/storage.py` agar mengembalikan URL `/static/uploads/<file>` dan menyimpan ke folder yang benar
- [x] Perbaikan error upload profil: kolom `users.foto_profil` belum ada di MySQL
- [ ] (Opsional) Jalankan migrasi/ALTER TABLE permanen di database kamu dan restart backend

