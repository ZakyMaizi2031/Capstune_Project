import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// Import Internal
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller untuk menangkap input
  final namaC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  @override
  void dispose() {
    namaC.dispose();
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan notifikasi (menggantikan yang lama)
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF98FF98),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white, // Background putih bersih sesuai desain
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // 1. LOGO LINGKARAN DI ATAS
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0), // Abu-abu placeholder
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12, width: 1),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.jpeg', // Ganti dengan path logo Anda
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Text("logo")),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2. JUDUL CHILICARE & TAGLINE
              Text(
                "ChiliCare",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Solusi cerdas pertanian cabai Indonesia",
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              // 3. SUBTITLE CREATE ACCOUNT
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Create Account",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // 4. FORM INPUTS (Abu-abu tanpa outline tebal)
              _buildLabel("Full Name"),
              _buildTextField(namaC, "Enter your legal name", false),
              const SizedBox(height: 20),

              _buildLabel("Email Address"),
              _buildTextField(emailC, "you@example.com", false),
              const SizedBox(height: 20),

              _buildLabel("Password"),
              _buildTextField(passC, "Create a strong password", true),

              const SizedBox(height: 30),

              // 5. TEKS PERSETUJUAN
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "By registering, you agree to ChiliCare's Terms of Service and Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 6. TOMBOL REGISTER
              auth.isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : _buildRegisterButton(
                      label: "Register",
                      onTap: () async {
                        // Validasi form kosong
                        if (namaC.text.isEmpty || emailC.text.isEmpty || passC.text.isEmpty) {
                          _showSnackBar("Semua kolom wajib diisi!", isError: true);
                          return;
                        }

                        // Memanggil fungsi register lama Anda
                        bool success = await auth.registerProcess(
                          namaC.text.trim(),
                          emailC.text.trim(),
                          passC.text.trim(),
                        );

                        if (success) {
                          _showSnackBar("Berhasil Daftar! Silakan Login.");
                          if (context.mounted) Navigator.pop(context); // Kembali ke Login
                        } else {
                          _showSnackBar("Registrasi Gagal! Silakan coba lagi.", isError: true);
                        }
                      },
                    ),

              const SizedBox(height: 25),

              // 7. FOOTER LOGIN
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Log In",
                      style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Helper: Teks Label di atas Input
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

  // Widget Helper: TextField (Background abu-abu terang)
  Widget _buildTextField(TextEditingController controller, String hint, bool isPass) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9), // Sesuai warna abu-abu desain Anda
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPass,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38, fontWeight: FontWeight.w600),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  // Widget Helper: Tombol Register (Bentuk Kapsul + Outline Hijau)
  Widget _buildRegisterButton({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9), // Latar belakang sangat terang
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF2E7D32), width: 1.5), // Garis luar Hijau
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 17,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 15),
            const Icon(Icons.arrow_forward_rounded, color: Colors.black87, size: 22),
          ],
        ),
      ),
    );
  }
}