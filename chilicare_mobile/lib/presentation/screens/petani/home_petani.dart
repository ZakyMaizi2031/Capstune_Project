import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/themes/app_theme.dart';
import '../../providers/auth_provider.dart';
import 'encyclopedia.dart';
import 'scan_camera.dart';
// import 'history_screen.dart'; // Aktifkan jika file sudah ada

class HomePetani extends StatelessWidget {
  const HomePetani({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil data user dari AuthProvider
    final auth = Provider.of<AuthProvider>(context);
    final String userName = auth.user?.namaLengkap ?? "Petani";

    return Scaffold(
      backgroundColor: ChiliTheme.lemonYellow,
      appBar: AppBar(
        title: const Text("CHILICARE HOME"),
        actions: [
          IconButton(
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. GREETING SECTION
            Text(
              "Halo, $userName! 👋",
              style: ChiliTheme.headerTitle.copyWith(fontSize: 24),
            ),
            const Text(
              "Sudahkah Anda mengecek kondisi cabai hari ini?",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            const SizedBox(height: 30),

            // 2. HERO CARD: MULAI DETEKSI (Action Utama)
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScanCamera()),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: ChiliTheme.popArtDecoration(color: ChiliTheme.mintGreen),
                child: Column(
                  children: [
                    const Icon(Icons.camera_enhance_rounded, size: 80, color: Colors.black),
                    const SizedBox(height: 15),
                    const Text(
                      "SCAN CABAI SEKARANG",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Text(
                      "Gunakan AI untuk deteksi penyakit",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 3. GRID MENU: ENSIKLOPEDIA & RIWAYAT
            Row(
              children: [
                // Menu Ensiklopedia
                _buildSmallMenu(
                  context,
                  title: "KATALOG",
                  subtitle: "Ensiklopedia",
                  color: Colors.orangeAccent,
                  icon: Icons.menu_book_rounded,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EncyclopediaScreen()),
                  ),
                ),
                const SizedBox(width: 20),
                // Menu Riwayat
                _buildSmallMenu(
                  context,
                  title: "RIWAYAT",
                  subtitle: "Log Pemeriksaan",
                  color: Colors.lightBlueAccent,
                  icon: Icons.history_rounded,
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fitur Riwayat segera hadir!")),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 4. TIPS SECTION (Sticker Style)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: ChiliTheme.popArtDecoration(color: Colors.white),
              child: Row(
                children: [
                  const Text("💡", style: TextStyle(fontSize: 30)),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Tips Hari Ini",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          "Pastikan pencahayaan cukup saat mengambil foto buah cabai agar hasil deteksi akurat.",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET HELPER: Menu Kecil (Grid-like)
  Widget _buildSmallMenu(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          decoration: ChiliTheme.popArtDecoration(color: color),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.black),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}