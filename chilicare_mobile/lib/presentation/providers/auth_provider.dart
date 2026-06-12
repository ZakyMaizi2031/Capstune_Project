import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/api_repository.dart';

class AuthProvider with ChangeNotifier {
  // Instance dari repository untuk akses ke API
  final ApiRepository _apiRepository = ApiRepository();

  // State Variables
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters (Agar UI bisa membaca data tanpa mengubahnya langsung)
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Mengecek apakah sudah ada user yang login
  bool get isAuthenticated => _user != null;

  get userSession => null;

  // ==========================================
  // 1. LOGIKA LOGIN
  // ==========================================
  Future<String?> login(String email, String password) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      // Memanggil fungsi login di repository
      _user = await _apiRepository.login(email, password);
      
      _setLoading(false);
      notifyListeners();
      
      // Mengembalikan role ('admin' atau 'petani') untuk routing di UI
      return _user?.role;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage(e.toString().replaceAll("Exception: ", ""));
      return null;
    }
  }

  // ==========================================
  // 2. LOGIKA REGISTRASI (KHUSUS PETANI)
  // ==========================================
  Future<bool> register(String nama, String email, String password) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      // Backend akan otomatis memberikan role 'petani'
      bool isSuccess = await _apiRepository.register(nama, email, password);
      
      _setLoading(false);
      if (!isSuccess) {
        _setErrorMessage("Gagal mendaftarkan akun. Silakan coba lagi.");
      }
      return isSuccess;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage(e.toString().replaceAll("Exception: ", ""));
      return false;
    }
  }

  // Alias untuk registerProcess (untuk kompatibilitas dengan UI)
  Future<bool> registerProcess(String nama, String email, String password) {
    return register(nama, email, password);
  }

  // ==========================================
  // 3. LOGIKA LOGOUT
  // ==========================================
  void logout() {
    _user = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // ==========================================
  // HELPER METHODS (PRIVATE)
  // ==========================================
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}