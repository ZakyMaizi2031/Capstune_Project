import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import '../models/disease_model.dart';
// import '../models/history_model.dart';

class ApiRepository {
  // Helper untuk Header JSON
  Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  // ==========================================
  // 1. AUTHENTICATION
  // ==========================================

  Future<UserModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.login),
      headers: _headers,
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? "Gagal Login");
    }
  }

  Future<bool> register(String nama, String email, String password) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/api/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nama": nama,
        "email": email,
        "password": password,
        // Kita tidak perlu mengirim role karena sudah dikunci di Backend
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? "Registrasi gagal");
    }
  }

  // ==========================================
  // 2. FITUR PETANI (USER)
  // ==========================================

  // Ambil Data Ensiklopedia untuk Katalog
  Future<List<DiseaseModel>> getEncyclopedia() async {
    final response = await http.get(Uri.parse(ApiConstants.encyclopedia));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => DiseaseModel.fromJson(item)).toList();
    } else {
      throw Exception("Gagal memuat ensiklopedia");
    }
  }

  // Upload Gambar ke CNN & Ambil Hasil Deteksi
  Future<Map<String, dynamic>> predictDisease(
    File imageFile,
    int idUser,
  ) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstants.predict),
    );

    // Menambahkan field id_user
    request.fields['id_user'] = idUser.toString();

    // Menambahkan file gambar
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal melakukan deteksi");
    }
  }

  // Upload Gambar dari BYTES (untuk Web)
  Future<Map<String, dynamic>> predictDiseaseFromBytes(
    Uint8List imageBytes,
    int idUser,
  ) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstants.predict),
    );

    // Menambahkan field id_user
    request.fields['id_user'] = idUser.toString();

    // Menambahkan file gambar dari bytes
    request.files.add(
      http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg'),
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal melakukan deteksi dari bytes");
    }
  }

  // ==========================================
  // 3. FITUR ADMIN (MANAGEMENT)
  // ==========================================

  // Ambil Statistik Dashboard Admin
  Future<Map<String, dynamic>> getAdminStats() async {
    final response = await http.get(Uri.parse(ApiConstants.adminStats));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal memuat statistik");
    }
  }

  // Ambil Daftar Semua User (Untuk Tabel User Admin)
  Future<List<UserModel>> getAllUsers() async {
    final response = await http.get(Uri.parse(ApiConstants.adminUsers));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => UserModel.fromJson(item)).toList();
    } else {
      throw Exception("Gagal memuat data user");
    }
  }

  // Hapus User
  Future<bool> deleteUser(int idUser) async {
    final response = await http.delete(
      Uri.parse("${ApiConstants.adminUsers}/$idUser"),
    );
    return response.statusCode == 200;
  }

  // Tambah Penyakit Baru (Admin CRUD)
  Future<bool> createDisease(Map<String, dynamic> diseaseData) async {
    final response = await http.post(
      Uri.parse(ApiConstants.adminEncyclopedia),
      headers: _headers,
      body: jsonEncode(diseaseData),
    );
    return response.statusCode == 200;
  }

  // Update Penyakit (Admin CRUD)
  Future<bool> updateDisease(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("${ApiConstants.adminEncyclopedia}$id"),
      headers: _headers,
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }

  // Hapus Penyakit (Admin CRUD)
  Future<bool> deleteDisease(int id) async {
    final response = await http.delete(
      Uri.parse("${ApiConstants.adminEncyclopedia}$id"),
    );
    return response.statusCode == 200;
  }

  // Ambil Monitoring Riwayat Scan Semua Petani
  Future<List<dynamic>> getHistoryMonitor() async {
    final response = await http.get(Uri.parse(ApiConstants.adminHistory));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal memuat riwayat");
    }
  }

  Future<dynamic> uploadImage(File image, int userId) async {}
}
