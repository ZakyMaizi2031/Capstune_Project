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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Animasi
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: ChiliTheme.mintGreen.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'assets/images/logo.jpeg',
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Nama Aplikasi
                    const Text(
                      "CHILICARE",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: ChiliTheme.mintGreen,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    const Text(
                      "Healthy Chili, Happy Farmer",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ChiliTheme.mintGreen,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Indikator Loading Modern
            const CircularProgressIndicator(
              color: ChiliTheme.mintGreen,
              strokeWidth: 3,
            ),
            const SizedBox(height: 32),

            // Footer Version
            const Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Text(
                "v 1.0.0 - ChiliCare Team",
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: ChiliTheme.mintGreen,
                  fontSize: 12,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
