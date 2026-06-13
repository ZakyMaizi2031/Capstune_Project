import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/themes/app_theme.dart';
import '../../providers/scan_provider.dart';
import 'home_petani.dart';

/// Halaman untuk menampilkan hasil deteksi penyakit cabai
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);
    final result = scanProvider.result;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("HASIL DETEKSI")),
        body: const Center(
          child: Text("Tidak ada data hasil deteksi"),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("HASIL DETEKSI CABAI"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. CARD HASIL DETEKSI (BOLD & BOXY)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: ChiliTheme.popArtDecoration(
                color: ChiliTheme.brightOrange,
                borderWidth: 3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline, size: 50, color: Colors.black),
                  const SizedBox(height: 15),
                  const Text(
                    "HASIL ANALISIS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    result.label.toUpperCase(),
                    style: ChiliTheme.headingMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Kepastian: ${(result.confidence * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 2. DETAIL PENYAKIT
            const Text(
              "INFORMASI PENYAKIT",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: ChiliTheme.cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    "Nama Penyakit",
                    result.label,
                  ),
                  const Divider(height: 20),
                  _buildInfoRow(
                    "Penyebab",
                    result.penyebab,
                  ),
                  const Divider(height: 20),
                  _buildInfoRow(
                    "Gejala Visual",
                    result.gejala,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 3. REKOMENDASI PENANGANAN
            const Text(
              "REKOMENDASI PENANGANAN",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: ChiliTheme.popArtDecoration(
                color: ChiliTheme.mintGreen,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb_outline, size: 24, color: Colors.black),
                      SizedBox(width: 10),
                      Text(
                        "SARAN PENANGANAN",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    result.langkahPenanganan,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 4. TOMBOL AKSI
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Kembali ke camera screen
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("SCAN ULANG"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ChiliTheme.tomatoRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePetani()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.home),
                    label: const Text("KE BERANDA"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ChiliTheme.mintGreen,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Widget helper untuk menampilkan info row
  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
