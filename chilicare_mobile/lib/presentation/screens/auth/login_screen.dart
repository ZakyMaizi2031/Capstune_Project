import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// Import Internal
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar("Email dan password wajib diisi!", isError: true);
      return;
    }

    String? role = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (role != null) {
      if (role == 'admin') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboard()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePetani()));
      }
    } else {
      _showSnackBar(authProvider.errorMessage ?? "Login Gagal!", isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF98FF98),
        content: Text(message, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih bersih
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            children: [
              const SizedBox(height: 60),
              
              // 1. LOGO DARI ASSETS
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12, width: 1),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      // Pakai file yang sudah terdaftar di pubspec.yaml
                      'assets/images/logo.jpeg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // 2. JUDUL & TAGLINE
              Text(
                "ChiliCare",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Solusi cerdas pertanian cabai Indonesia",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 50),

              // 3. INPUT EMAIL
              _buildLabel("Email"),
              _buildTextField(_emailController, "emile@ando.com", false),
              const SizedBox(height: 25),

              // 4. INPUT PASSWORD
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel("Kata Sandi"),
                  // const Text("Lupa Sandi?", 
                  //   style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              _buildTextField(_passwordController, "Password Anda", true),
              const SizedBox(height: 40),

              // 5. TOMBOL MASUK (Abu-abu Gelap sesuai gambar)
              Consumer<AuthProvider>(
                builder: (context, auth, _) => auth.isLoading
                  ? const CircularProgressIndicator(color: Color(0xFF7A7A7A))
                  : _buildPrimaryButton(
                      label: "Button Masuk",
                      icon: Icons.login_rounded,
                      onTap: _handleLogin,
                    ),
              ),

              const SizedBox(height: 30),

              // 6. DIVIDER ATAU
              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1.5, color: Colors.black12)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text("ATAU", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black38, fontSize: 12)),
                  ),
                  Expanded(child: Divider(thickness: 1.5, color: Colors.black12)),
                ],
              ),
              
              const SizedBox(height: 30),

              // 7. TOMBOL DAFTAR (Pill Shape dengan Border Hijau Mint)
              _buildSecondaryButton(
                label: "Daftar Akun Baru",
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
                },
              ),

              const SizedBox(height: 60),

              // 8. FOOTER
              const Text(
                "Dengan melanjutkan, Anda menyetujui\nSyarat & Ketentuan kami.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Helper: Label
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.black),
        ),
      ),
    );
  }

  // Widget Helper: TextField (Grey Background)
  Widget _buildTextField(TextEditingController controller, String hint, bool isPass) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9), // Warna abu-abu background input sesuai gambar
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPass,
        style: const TextStyle(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black26),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  // Widget Helper: Button Masuk (Dark Grey)
  Widget _buildPrimaryButton({required String label, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF7A7A7A), // Warna tombol masuk sesuai gambar
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // Widget Helper: Button Daftar (Mint Outline)
  Widget _buildSecondaryButton({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF2E7D32), width: 1.5), // Border Hijau Tua/Mint
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.black87),
          ],
        ),
      ),
    );
  }
}