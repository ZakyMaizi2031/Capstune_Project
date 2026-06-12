class UserModel {
  final int idUser;
  final String namaLengkap;
  final String email;
  final String role; // 'petani' atau 'admin'

  UserModel({
    required this.idUser,
    required this.namaLengkap,
    required this.email,
    required this.role,
  });

  // 1. Factory method: Mengubah JSON dari FastAPI menjadi Object Dart
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['id_user'] ?? 0,
      namaLengkap: json['nama'] ?? json['nama_lengkap'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'petani', // Default ke petani jika null
    );
  }

  // 2. Method: Mengubah Object Dart menjadi JSON (untuk dikirim ke API atau disimpan lokal)
  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'nama_lengkap': namaLengkap,
      'email': email,
      'role': role,
    };
  }

  // 3. Helper: Mengecek apakah pengguna adalah Admin
  bool get isAdmin => role.toLowerCase() == 'admin';

  // 4. Helper: Mengecek apakah pengguna adalah Petani
  bool get isPetani => role.toLowerCase() == 'petani';
}