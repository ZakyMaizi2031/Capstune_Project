import tensorflow as tf
import numpy as np
from ..config import MODEL_PATH, CLASS_NAMES

model = None

def load_model():
    global model
    if model is None:
        print(f"[INFO] Loading model from {MODEL_PATH}")
        model = tf.keras.models.load_model(MODEL_PATH)
        print("[INFO] Model loaded successfully")
    return model

def predict(image: np.ndarray):
    """
    image: array (224,224,3) float32 sudah dinormalisasi 0-1
    return: (nama_kelas, confidence)
    """
    model = load_model()
    input_tensor = np.expand_dims(image, axis=0)
    preds = model.predict(input_tensor, verbose=0)[0]
    idx = np.argmax(preds)
    confidence = float(preds[idx])
    return CLASS_NAMES[idx], confidence