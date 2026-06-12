import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/scan_provider.dart';
import '../../../core/themes/app_theme.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scanPro = Provider.of<ScanProvider>(context);
    final data = scanPro.result;

    return Scaffold(
      appBar: AppBar(
        title: const Text("HASIL DIAGNOSIS", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: ChiliTheme.tomatoRed,
      ),
      body: data == null 
        ? const Center(child: Text("Tidak ada data"))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 1. KARTU HASIL DIAGNOSIS (Pop-Art Style)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: ChiliTheme.popArtDecoration(color: ChiliTheme.mintGreen),
                  child: Column(
                    children: [
                      const Text("TERDETEKSI:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(data.label.toUpperCase(), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      Text("Akurasi: ${(data.confidence * 100).toStringAsFixed(2)}%", 
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // 2. KARTU PENANGANAN & REKOMENDASI
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: ChiliTheme.popArtDecoration(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.medical_services, color: ChiliTheme.tomatoRed),
                          SizedBox(width: 10),
                          Text("LANGKAH PENANGANAN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                      const Divider(color: Colors.black, thickness: 2),
                      const Text("Gejala:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(data.gejala),
                      const SizedBox(height: 15),
                      const Text("Cara Mengatasi:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(data.langkahPenanganan),
                      const SizedBox(height: 15),
                      const Text("Rekomendasi Obat:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: ChiliTheme.lemonYellow, border: Border.all(width: 1)),
                        child: Text(data.namaObat, style: const TextStyle(fontStyle: FontStyle.italic)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}