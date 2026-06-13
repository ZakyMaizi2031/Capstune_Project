import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// Import Internal
import '../../providers/auth_provider.dart';
import 'encyclopedia.dart';
import 'scan_camera.dart';
import 'history_screen.dart';
import '../../providers/history_provider.dart';
// import '../../../data/models/history_model.dart';
import 'profile_screen.dart'; // Import halaman profil baru

class HomePetani extends StatelessWidget {
  const HomePetani({super.key});

  // Warna Hijau Mint Custom sesuai desain baru
  static const Color mintGreen = Color(0xFF98FF98);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    // final String userName = auth.user?.namaLengkap ?? "Petani";

    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih bersih
      appBar: _buildAppBar(context, auth),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            
            // 1. HERO SECTION: TOMBOL SCAN BESAR (LINGKARAN)
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ScanCamera()),
                    ),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFE0E0E0), // Abu-abu muda
                          width: 10,
                        ),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_a_photo_outlined,
                            size: 60,
                            color: Colors.black87,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Scan Now",
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Point camera at a chili leaf to start diagnosis",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // 2. RIWAYAT TERAKHIR SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Riwayat Terakhir",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HistoryScreen()),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Lihat Semua",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const Icon(Icons.arrow_forward, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Ambil riwayat deteksi dari database (hasil scan)
                  // Note: Untuk memastikan data tampil, implementasikan HistoryProvider di HomePetani.
                  // Saat belum ada data, fallback akan tetap menampilkan placeholder.
                  Builder(
                    builder: (context) {
                      final userId = auth.user?.idUser;
                      if (userId == null) {
                        return Column(
                          children: [
                            _buildHistoryItem("Belum ada riwayat", "-"),
                          ],
                        );
                      }
                      final historyProvider = Provider.of<HistoryProvider>(context);
                      final items = historyProvider.myHistory;

                      if (historyProvider.isLoading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (items.isEmpty) {
                        return Column(
                          children: [
                            _buildHistoryItem("Belum ada riwayat", "Silakan scan terlebih dahulu"),
                          ],
                        );
                      }

                      final latest = items.take(4).toList();
                      return Column(
                        children: latest.map((e) {
                          final title = (e.namaPenyakit?.isNotEmpty == true)
                              ? e.namaPenyakit!
                              : e.hasilPrediksi;
                          // HistoryModel belum punya formattedTimeAgo, gunakan formattedDate dari tanggalDeteksi
                          return _buildHistoryItem(title, e.formattedDate);
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100), // Memberi ruang untuk BottomNav
          ],
        ),
      ),
      
      // 3. CUSTOM BOTTOM NAVIGATION BAR
      bottomNavigationBar: _buildBottomNav(context),
      floatingActionButton: _buildCenterFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // --- WIDGET HELPER: APPBAR ---
  PreferredSizeWidget _buildAppBar(BuildContext context, AuthProvider auth) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      toolbarHeight: 80,
      title: Row(
        children: [
          // Logo Assets
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo.jpeg',
                fit: BoxFit.cover,
                errorBuilder: (context, e, s) => const Center(child: Text("logo", style: TextStyle(fontSize: 10))),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Text(
            "ChiliCare",
            style: GoogleFonts.plusJakartaSans(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          const Spacer(),
          // Profile Action
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen()),
            ),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9), // Abu-abu profile
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black12, width: 1),
              ),
              child: Center(
                child: Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    final foto = auth.user?.fotoProfil;
                    if (foto == null || foto.isEmpty) {
                      return const Text(
                        "Profil",
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
                      );
                    }
                    return ClipOval(
                      child: Image.network(
                        foto,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text(
                            "Profil",
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: ITEM RIWAYAT ---
  Widget _buildHistoryItem(String title, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFF0F0F0), width: 2),
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              Text(
                time,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.black45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: BOTTOM NAV ---
  Widget _buildBottomNav(BuildContext context) {
    return BottomAppBar(
      notchMargin: 10,
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      elevation: 20,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.home_outlined, size: 30, color: Colors.black)),
            IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
              icon: const Icon(Icons.history, size: 30, color: Colors.black),
            ),
            const SizedBox(width: 40), // Space for FAB
            IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EncyclopediaScreen())),
              icon: const Icon(Icons.menu_book_outlined, size: 30, color: Colors.black),
            ),
            IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen())),
              icon: const Icon(Icons.person_outline, size: 30, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER: TOMBOL SCAN TENGAH ---
  Widget _buildCenterFab(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE0E0E0), width: 2),
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 0,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScanCamera())),
        child: const Icon(Icons.camera, color: Colors.black, size: 40),
      ),
    );
  }
}