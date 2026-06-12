class DetectionModel {
  final String label;
  final double confidence;
  final String gejala;
  final String penyebab;
  final String langkahPenanganan;
  final String namaObat;

  DetectionModel({
    required this.label,
    required this.confidence,
    required this.gejala,
    required this.penyebab,
    required this.langkahPenanganan,
    required this.namaObat,
  });

  factory DetectionModel.fromJson(Map<String, dynamic> json) {
    // Mengambil data dari response FastAPI
    var penyakit = json['penyakit_info'];
    var rekomendasi = penyakit['rekomendasi'];
    
    return DetectionModel(
      label: json['label'],
      confidence: json['confidence'],
      gejala: penyakit['gejala_visual'],
      penyebab: penyakit['penyebab'],
      langkahPenanganan: rekomendasi['langkah_penanganan'],
      namaObat: rekomendasi['nama_obat'],
    );
  }
}