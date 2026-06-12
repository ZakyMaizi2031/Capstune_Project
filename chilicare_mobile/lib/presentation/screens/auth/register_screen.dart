import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/themes/app_theme.dart';

class RegisterScreen extends StatelessWidget {
  final namaC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("DAFTAR AKUN PETANI")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildInput(namaC, "Nama Lengkap", Icons.person),
            const SizedBox(height: 20),
            _buildInput(emailC, "Email", Icons.email),
            const SizedBox(height: 20),
            _buildInput(passC, "Password", Icons.lock, obscure: true),
            const SizedBox(height: 40),
            auth.isLoading 
              ? const CircularProgressIndicator()
              : InkWell(
                  onTap: () async {
                    bool success = await auth.registerProcess(namaC.text, emailC.text, passC.text);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Berhasil Daftar! Silakan Login."))
                      );
                      Navigator.pop(context); // Kembali ke Login
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Registrasi Gagal!"))
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: ChiliTheme.popArtDecoration(color: ChiliTheme.mintGreen),
                    child: const Center(
                      child: Text("DAFTAR SEKARANG", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String hint, IconData icon, {bool obscure = false}) {
    return Container(
      decoration: ChiliTheme.popArtDecoration(),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}