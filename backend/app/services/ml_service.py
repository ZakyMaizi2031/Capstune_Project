import tensorflow as tf
import numpy as np
from PIL import Image
from ..core.config import settings
import os

model = None

def load_model():
    global model
    # Gunakan path absolut untuk memastikan lokasi file benar di Windows
    current_dir = os.getcwd()
    model_path = os.path.join(current_dir, "ml_models", "mobilenetv2_chili_final.h5")
    
    print(f">>> [DEBUG] Mencari model di: {model_path}")
    
    if os.path.exists(model_path):
        try:
            model = tf.keras.models.load_model(model_path)
            print(f">>> [ML SUCCESS] Model berhasil dimuat!")
        except Exception as e:
            print(f">>> [ML ERROR] Gagal load file .h5: {e}")
    else:
        print(f">>> [ML DANGER] FILE .H5 TIDAK DITEMUKAN!")

load_model()

def run_inference(image_path):
    try:
        if model is None:
            return "Model Error", 0.0

        # 1. Load Gambar & Konversi ke RGB
        img = Image.open(image_path).convert('RGB')
        
        # 2. Resize ke 224x224 (Sesuai IMG_SIZE di Colab)
        img = img.resize((224, 224))
        
        # 3. Konversi ke Numpy Array
        img_array = np.array(img, dtype=np.float32)
        
        # 4. NORMALISASI 1./255 (Harus sama dengan ImageDataGenerator di Colab)
        img_array = img_array / 255.0
        
        # 5. Tambah Dimensi Batch
        img_array = np.expand_dims(img_array, axis=0)

        # 6. Prediksi
        predictions = model.predict(img_array, verbose=0)
        result_index = int(np.argmax(predictions[0]))
        akurasi = float(np.max(predictions[0]))
        
        # 7. URUTAN LABEL ALFABETIS (ASCII) - SESUAI FOLDER COLAB
        # Urutan: A-Z (Besar) baru a-z (kecil)
        labels = ["Antraknosa", "BusukBasah", "Sehat", "busukKering", "virus"]
        
        label_hasil = labels[result_index]
        
        return label_hasil, akurasi
        
    except Exception as e:
        print(f">>> [CRASH] ml_service error: {e}")
        return "Error", 0.0