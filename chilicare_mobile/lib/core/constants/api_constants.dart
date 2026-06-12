import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  // 1. BASE URL
  // Untuk Web: localhost:8000
  // Untuk Mobile: 10.0.2.2:8000 (emulator) atau IP device
  static String baseUrl = kIsWeb 
      ? 'http://localhost:8000'
      : dotenv.get('BASE_URL', fallback: 'http://10.0.2.2:8000');
  
  // Versi API Prefix
  static String apiPrefix = "$baseUrl/api";

  // ==========================================
  // 2. AUTHENTICATION ENDPOINTS
  // ==========================================
  static String login = "$apiPrefix/auth/login";
  static String register = "$apiPrefix/auth/register";

  // ==========================================
  // 3. FITUR PETANI (USER) ENDPOINTS
  // ==========================================
  
  // Endpoint untuk Ensiklopedia (Read-Only untuk Petani)
  static String encyclopedia = "$apiPrefix/encyclopedia/";
  
  // Endpoint untuk Deteksi Citra (CNN)
  // Membutuhkan ID User sebagai parameter di Backend
  static String predict = "$apiPrefix/predict/";

  // ==========================================
  // 4. FITUR ADMIN (MANAGEMENT) ENDPOINTS
  // ==========================================
  
  // Dashboard Stats (Total User, Total Scan, dll)
  static String adminStats = "$apiPrefix/admin/stats";
  
  // User Management (Melihat & Menghapus Petani)
  static String adminUsers = "$apiPrefix/admin/users";
  
  // Encyclopedia CRUD (Tambah, Edit, Hapus Master Data)
  static String adminEncyclopedia = "$apiPrefix/admin/encyclopedia/";
  
  // Monitoring Riwayat Semua Petani
  static String adminHistory = "$apiPrefix/admin/history-monitor";

  // ==========================================
  // 5. STATIC FILES (ASSETS SERVER)
  // ==========================================
  
  // Digunakan untuk menampilkan foto hasil scan yang tersimpan di backend
  // Contoh penggunaan: Image.network("${ApiConstants.storageUrl}/nama_file.jpg")
  static String storageUrl = "$baseUrl/static/uploads";
}