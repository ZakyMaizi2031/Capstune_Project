import 'package:flutter/material.dart';

/// Provider untuk mengelola data encyclopedia (database penyakit cabai)
class EncyclopediaProvider extends ChangeNotifier {
  // State Variables
  List<Map<String, dynamic>> _diseases = [];
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _selectedDisease;

  // Getters
  List<Map<String, dynamic>> get diseases => _diseases;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get selectedDisease => _selectedDisease;

  // ==========================================
  // FUNGSI UNTUK FETCH ENCYCLOPEDIA DATA
  // ==========================================

  /// Mengambil daftar semua penyakit dari backend
  Future<void> fetchDiseases() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      // TODO: Implementasi API call untuk fetch diseases
      // final response = await _apiRepository.getDiseases();
      // _diseases = response;
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      _setErrorMessage(e.toString().replaceAll("Exception: ", ""));
      notifyListeners();
    }
  }

  /// Mengambil detail dari penyakit tertentu
  Future<void> fetchDiseaseDetail(String diseaseId) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      // TODO: Implementasi API call untuk fetch disease detail
      // _selectedDisease = await _apiRepository.getDiseaseDetail(diseaseId);
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      _setErrorMessage(e.toString().replaceAll("Exception: ", ""));
      notifyListeners();
    }
  }

  /// Mencari penyakit berdasarkan keyword
  Future<void> searchDiseases(String keyword) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      // TODO: Implementasi API call untuk search diseases
      // _diseases = await _apiRepository.searchDiseases(keyword);
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      _setErrorMessage(e.toString().replaceAll("Exception: ", ""));
      notifyListeners();
    }
  }

  // ==========================================
  // PRIVATE HELPER METHODS
  // ==========================================

  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
  }

  /// Reset state encyclopedia
  void reset() {
    _diseases = [];
    _selectedDisease = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
