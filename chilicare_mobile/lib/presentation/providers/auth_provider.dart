import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/api_repository.dart';
import 'dart:io';

class AuthProvider with ChangeNotifier {
  final ApiRepository _apiRepository = ApiRepository();

  // State Variables
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  // Getter userSession yang diperbaiki untuk kebutuhan UI (Admin/Petani)
  Map<String, dynamic>? get userSession => _user != null ? {
    'id_user': _user!.idUser,
    'nama': _user!.namaLengkap,
    'email': _user!.email,
    'role': _user!.role,
    'foto_profil': _user!.fotoProfil,
  } : null;

  // ==========================================
  // 1. LOGIKA LOGIN
  // ==========================================
  Future<String?> login(String email, String password) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _user = await _apiRepository.login(email, password);
      
      _setLoading(false);
      notifyListeners();
      return _user?.role;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage(e.toString().replaceAll("Exception: ", ""));
      return null;
    }
  }

  // ==========================================
  // 2. LOGIKA REGISTRASI
  // ==========================================
  Future<bool> registerProcess(String nama, String email, String password) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      bool isSuccess = await _apiRepository.register(nama, email, password);
      _setLoading(false);
      return isSuccess;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage(e.toString().replaceAll("Exception: ", ""));
      return false;
    }
  }

  // ==========================================
  // 3. UPDATE FOTO PROFIL (LOKAL & SERVER)
  // ==========================================
  Future<bool> updateProfilePicture(File imageFile) async {
    if (_user == null) return false;
    
    _setLoading(true);
    try {
      // 1. Kirim file ke backend
      String? newPath = await _apiRepository.uploadProfilePhoto(imageFile, _user!.idUser);
      
      if (newPath != null) {
        // 2. Update object user di memori (Lokal)
        _user = UserModel(
          idUser: _user!.idUser,
          namaLengkap: _user!.namaLengkap,
          email: _user!.email,
          role: _user!.role,
          fotoProfil: newPath, // Path baru dari server
        );
        
        _setLoading(false);
        notifyListeners(); // Memicu UI (AppBar, Profile Screen) untuk update foto
        return true;
      }
      _setLoading(false);
      return false;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage("Gagal mengupload foto");
      return false;
    }
  }

  // Fungsi pembantu untuk update path foto jika diperlukan secara manual
  void updateLocalFoto(String path) {
    if (_user != null) {
      _user = UserModel(
        idUser: _user!.idUser,
        namaLengkap: _user!.namaLengkap,
        email: _user!.email,
        role: _user!.role,
        fotoProfil: path,
      );
      notifyListeners();
    }
  }

  // ==========================================
  // 4. LOGIKA LOGOUT
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