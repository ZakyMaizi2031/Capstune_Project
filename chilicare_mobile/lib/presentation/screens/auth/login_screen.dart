import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import Internal
import '../../../core/themes/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../petani/home_petani.dart';
import '../admin/admin_dashboard.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller untuk menangkap input teks
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fungsi untuk menangani proses login
  void _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Validasi sederhana
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar("Email dan password tidak boleh kosong!", isError: true);
      return;
    }

    // Memanggil fungsi login di AuthProvider
    String? role = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (role != null) {
      _showSnackBar("Selamat datang, ${authProvider.user?.namaLengkap}!");
      
      // LOGIKA ROLE-BASED ROUTING
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePetani()),
        );
      }
    } else {
      // Tampilkan pesan error jika login gagal
      _showSnackBar(authProvider.errorMessage ?? "Login Gagal!", isError: true);
    }
  }

  // Helper untuk menampilkan notifikasi ala Pop-Art
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? ChiliTheme.tomatoRed : ChiliTheme.mintGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black, width: 2),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChiliTheme.lemonYellow,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. LOGO & JUDUL (Style Pop-Art)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: ChiliTheme.popArtDecoration(color: Colors.white),
                child: Column(
                  children: [
                    const Icon(Icons.healing, size: 80, color: ChiliTheme.tomatoRed),
                    const SizedBox(height: 10),
                    Text(
                      "CHILICARE",
                      style: ChiliTheme.headerTitle.copyWith(fontSize: 32),
                    ),
                    const Text(
                      "Deteksi Penyakit Cabai Merah",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // 2. INPUT EMAIL
              _buildPopArtField(
                controller: _emailController,
                label: "Email Petani",
                icon: Icons.email_rounded,
                hint: "masukkan email anda",
              ),
              const SizedBox(height: 20),

              // 3. INPUT PASSWORD
              _buildPopArtField(
                controller: _passwordController,
                label: "Password",
                icon: Icons.lock_rounded,
                hint: "masukkan password",
                isPassword: true,
              ),
              const SizedBox(height: 40),

              // 4. TOMBOL LOGIN (Mint Green)
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return auth.isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : InkWell(
                          onTap: _handleLogin,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: ChiliTheme.popArtDecoration(color: ChiliTheme.mintGreen),
                            child: const Center(
                              child: Text(
                                "MASUK KE SISTEM",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        );
                },
              ),
              const SizedBox(height: 25),

              // 5. NAVIGASI KE REGISTER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun?", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterScreen()),
                      );
                    },
                    child: const Text(
                      "Daftar Petani",
                      style: TextStyle(
                        color: ChiliTheme.tomatoRed,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Reusable untuk Input Field bergaya Pop-Art
  Widget _buildPopArtField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        Container(
          decoration: ChiliTheme.popArtDecoration(hasShadow: false),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: Icon(icon, color: Colors.black),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(18),
            ),
          ),
        ),
      ],
    );
  }
}