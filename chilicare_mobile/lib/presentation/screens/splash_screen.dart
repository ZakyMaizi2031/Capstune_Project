import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/themes/app_theme.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';
import 'petani/home_petani.dart';
import 'admin/admin_dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Setup Animasi Logo (Efek Pop-up)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut, // Efek membal khas Pop-Art
    );

    _controller.forward();

    // 2. Jalankan logika pindah halaman setelah 3 detik
    _startSplashScreen();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // LOGIKA NAVIGASI OTOMATIS
  _startSplashScreen() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      _checkSession();
    });
  }

  void _checkSession() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Cek apakah user sudah terautentikasi (Sesi aktif)
    if (authProvider.isAuthenticated) {
      // Jika sudah login, arahkan berdasarkan ROLE
      if (authProvider.user?.role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePetani()),
        );
      }
    } else {
      // Jika belum login, arahkan ke halaman Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChiliTheme.lemonYellow, // Background Kuning Lemon
      body: Stack(
        children: [
          // Elemen Dekoratif Dot/Titik (Style Komik)
          Positioned(
            top: -50,
            left: -50,
            child: _buildDecorativeCircle(ChiliTheme.tomatoRed, 150),
          ),
          Positioned(
            bottom: -30,
            right: -30,
            child: _buildDecorativeCircle(ChiliTheme.mintGreen, 120),
          ),

          // Konten Utama
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Animasi
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: ChiliTheme.popArtDecoration(color: Colors.white),
                    child: const Icon(
                      Icons.local_florist, // Icon tanaman/bunga untuk cabai
                      size: 100,
                      color: ChiliTheme.tomatoRed,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Nama Aplikasi dengan Border Hitam (Style Bungee)
                Text(
                  "CHILICARE",
                  style: ChiliTheme.headerTitle.copyWith(
                    fontSize: 40,
                    letterSpacing: 2,
                  ),
                ),
                
                const Text(
                  "Healthy Chili, Happy Farmer",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 50),

                // Indikator Loading Modern
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 5,
                  ),
                ),
              ],
            ),
          ),

          // Footer Version
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Text(
                "v 1.0.0 - ChiliCare Team",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Widget Pembantu untuk dekorasi Pop-Art
  Widget _buildDecorativeCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 3),
      ),
    );
  }
}