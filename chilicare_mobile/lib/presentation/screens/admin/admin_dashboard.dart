import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/themes/app_theme.dart';
import '../../../data/repositories/api_repository.dart';
import '../../providers/auth_provider.dart';
import 'manage_disease.dart';
import 'manage_users.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final ApiRepository _repo = ApiRepository();

  // Fungsi untuk refresh data saat ditarik ke bawah
  Future<void> _handleRefresh() async {
    setState(() {}); // Memicu FutureBuilder untuk mengambil data ulang
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: ChiliTheme.lemonYellow,
      appBar: AppBar(
        title: const Text("ADMIN DASHBOARD"),
        actions: [
          IconButton(
            onPressed: () {
              // Tambahkan logika logout di sini
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: ChiliTheme.tomatoRed,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _repo.getAdminStats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.black));
            }

            if (snapshot.hasError) {
              return Center(child: Text("Gagal memuat statistik: ${snapshot.error}"));
            }

            final stats = snapshot.data ?? {};

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GREETING SECTION
                  Text(
                    "Halo, Admin ${auth.userSession?['nama'] ?? ''}! 👋",
                    style: ChiliTheme.headerTitle,
                  ),
                  const Text(
                    "Pantau statistik ChiliCare hari ini.",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                  const SizedBox(height: 25),

                  // STATS CARDS SECTION
                  _buildStatCard(
                    title: "TOTAL PETANI",
                    value: stats['total_users'].toString(),
                    color: ChiliTheme.mintGreen,
                    icon: Icons.people_alt_rounded,
                  ),
                  const SizedBox(height: 15),
                  _buildStatCard(
                    title: "TOTAL SCAN CABAI",
                    value: stats['total_scans'].toString(),
                    color: Colors.orangeAccent,
                    icon: Icons.camera_enhance_rounded,
                  ),
                  const SizedBox(height: 15),
                  _buildStatCard(
                    title: "KATALOG PENYAKIT",
                    value: stats['total_diseases'].toString(),
                    color: Colors.lightBlueAccent,
                    icon: Icons.library_books_rounded,
                  ),

                  const SizedBox(height: 35),

                  // MANAGEMENT MENU SECTION
                  const Text(
                    "KONTROL MANAJEMEN",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 15),
                  
                  _buildMenuButton(
                    context,
                    title: "Kelola Database Pengguna",
                    subtitle: "Lihat dan pantau daftar petani",
                    icon: Icons.admin_panel_settings,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageUsers())),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuButton(
                    context,
                    title: "Manajemen Ensiklopedia",
                    subtitle: "Tambah & Edit data penyakit cabai",
                    icon: Icons.edit_note_rounded,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageDisease())),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // WIDGET HELPER: Kartu Statistik Pop-Art
  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: ChiliTheme.popArtDecoration(color: color),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 30, color: Colors.black),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
            ],
          )
        ],
      ),
    );
  }

  // WIDGET HELPER: Tombol Menu Pop-Art
  Widget _buildMenuButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: ChiliTheme.popArtDecoration(color: Colors.white),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: ChiliTheme.lemonYellow,
              child: Icon(icon, color: Colors.black),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}