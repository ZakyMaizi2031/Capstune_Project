class DiseaseModel {
  final int idPenyakit;
  final String namaPenyakit;
  final String gejalaVisual;
  final String penyebab;
  final String? fotoReferensi;
  final RecommendationModel? rekomendasi;

  DiseaseModel({
    required this.idPenyakit,
    required this.namaPenyakit,
    required this.gejalaVisual,
    required this.penyebab,
    this.fotoReferensi,
    this.rekomendasi,
  });

  // Factory method untuk mengubah JSON dari API (FastAPI) menjadi Object Dart
  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      idPenyakit: json['id_penyakit'],
      namaPenyakit: json['nama_penyakit'] ?? '',
      gejalaVisual: json['gejala_visual'] ?? '',
      penyebab: json['penyebab'] ?? '',
      fotoReferensi: json['foto_referensi'],
      // Memetakan data rekomendasi jika ada (nested object)
      rekomendasi: json['rekomendasi'] != null
          ? RecommendationModel.fromJson(json['rekomendasi'])
          : null,
    );
  }

  // Method untuk mengubah Object Dart kembali menjadi JSON (untuk keperluan POST/PUT Admin)
  Map<String, dynamic> toJson() {
    return {
      'id_penyakit': idPenyakit,
      'nama_penyakit': namaPenyakit,
      'gejala_visual': gejalaVisual,
      'penyebab': penyebab,
      'foto_referensi': fotoReferensi,
      'langkah_penanganan': rekomendasi?.langkahPenanganan,
      'nama_obat': rekomendasi?.namaObat,
    };
  }
}

class RecommendationModel {
  final int? idRekomendasi;
  final String langkahPenanganan;
  final String namaObat;

  RecommendationModel({
    this.idRekomendasi,
    required this.langkahPenanganan,
    required this.namaObat,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      idRekomendasi: json['id_rekomendasi'],
      langkahPenanganan: json['langkah_penanganan'] ?? 'Tidak ada data penanganan.',
      namaObat: json['nama_obat'] ?? 'N/A',
    );
  }
}