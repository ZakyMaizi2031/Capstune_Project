import '../../core/constants/api_constants.dart';

class HistoryModel {
  final int idRiwayat;
  final int idUser;
  final int idPenyakit;
  final String fileFotoInput;
  final DateTime tanggalDeteksi;
  final String hasilPrediksi;
  final double tingkatAkurasi;

  // Field tambahan (Opsional: Jika backend mengirimkan nama penyakit hasil Join)
  final String? namaPenyakit;

  HistoryModel({
    required this.idRiwayat,
    required this.idUser,
    required this.idPenyakit,
    required this.fileFotoInput,
    required this.tanggalDeteksi,
    required this.hasilPrediksi,
    required this.tingkatAkurasi,
    this.namaPenyakit,
  });

  // Factory method untuk mengubah JSON dari API menjadi Object Dart
  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      idRiwayat: json['id_riwayat'],
      idUser: json['id_user'],
      idPenyakit: json['id_penyakit'],
      // Logic: Menambahkan base URL ke path foto agar bisa ditampilkan oleh Image.network
      fileFotoInput: json['file_foto_input'].startsWith('http') 
          ? json['file_foto_input'] 
          : "${ApiConstants.baseUrl}/${json['file_foto_input']}",
      // Parsing string tanggal dari MySQL menjadi object DateTime Dart
      tanggalDeteksi: DateTime.parse(json['tanggal_deteksi']),
      hasilPrediksi: json['hasil_prediksi'] ?? '',
      tingkatAkurasi: (json['tingkat_akurasi'] as num).toDouble(),
      namaPenyakit: json['nama_penyakit'],
    );
  }

  // Helper untuk mendapatkan persentase akurasi dalam format teks (Contoh: 98.5%)
  String get formattedAkurasi => "${(tingkatAkurasi * 100).toStringAsFixed(1)}%";

  // Helper untuk mendapatkan format tanggal yang cantik (Contoh: 27 Okt 2023)
  String get formattedDate {
    List<String> months = [
      "Jan", "Feb", "Mar", "Apr", "Mei", "Jun", 
      "Jul", "Agu", "Sep", "Okt", "Nov", "Des"
    ];
    return "${tanggalDeteksi.day} ${months[tanggalDeteksi.month - 1]} ${tanggalDeteksi.year}";
  }
}