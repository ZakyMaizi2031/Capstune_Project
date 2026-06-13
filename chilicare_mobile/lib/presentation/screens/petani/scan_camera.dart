import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/themes/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/scan_provider.dart';
import 'result_screen.dart'; // Import hasil screen

class ScanCamera extends StatefulWidget {
  const ScanCamera({super.key});

  @override
  State<ScanCamera> createState() => _ScanCameraState();
}

class _ScanCameraState extends State<ScanCamera> {
  File? _selectedImage;
  Uint8List? _selectedImageBytes; // Untuk kompatibilitas Flutter Web
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  // 1. FUNGSI MENGAMBIL GAMBAR
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Kompresi sedikit agar upload lebih cepat
      );

      if (pickedFile != null) {
        // Untuk web, baca bytes lebih dulu
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          if (mounted) {
            setState(() {
              _selectedImageBytes = bytes;
              _selectedImage = null; // Jangan gunakan File di web
            });
          }
        } else {
          // Untuk mobile/desktop, gunakan File
          if (mounted) {
            setState(() {
              _selectedImage = File(pickedFile.path);
              _selectedImageBytes = null;
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  // 2. FUNGSI PROSES SCAN (KIRIM KE BACKEND)
  Future<void> _processScan() async {
    if (_selectedImage == null && _selectedImageBytes == null) return;

    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Ambil ID User untuk pencatatan riwayat di MySQL
    final int userId = authProvider.user?.idUser ?? 0;

    setState(() {
      isLoading = true;
    });

    try {
      // Jalankan deteksi sesuai platform
      if (kIsWeb && _selectedImageBytes != null) {
        // Web: Upload menggunakan bytes
        await scanProvider.detectDiseaseFromBytes(_selectedImageBytes!, userId);
      } else if (_selectedImage != null) {
        // Mobile: Upload menggunakan file
        await scanProvider.detectDisease(_selectedImage!, userId);
      }

      if (!mounted) return;

      // Cek hasil deteksi
      if (scanProvider.result != null) {
        // Jika berhasil, arahkan ke halaman hasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ResultScreen()),
        );
      } else {
        // Jika gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              scanProvider.errorMessage ?? "Gagal memproses gambar. Coba lagi!",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint("Error di _processScan: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ScanProvider>().isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("DETEKSI CABAI"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // PRATINJAU GAMBAR (Pop-Art Frame)
            Container(
              width: double.infinity,
              height: 350,
              decoration: ChiliTheme.popArtDecoration(color: Colors.white),
              child: (kIsWeb && _selectedImageBytes != null) || (!kIsWeb && _selectedImage != null)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: kIsWeb
                          ? Image.memory(_selectedImageBytes!, fit: BoxFit.cover)
                          : Image.file(_selectedImage!, fit: BoxFit.cover),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.image_search_rounded, size: 80, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("Belum ada foto terpilih", 
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      ],
                    ),
            ),
            const SizedBox(height: 30),

            // TOMBOL AKSI (KAMERA & GALERI)
            Row(
              children: [
                _buildActionButton(
                  label: "KAMERA",
                  icon: Icons.camera_alt_rounded,
                  color: Colors.orangeAccent,
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                const SizedBox(width: 15),
                _buildActionButton(
                  label: "GALERI",
                  icon: Icons.photo_library_rounded,
                  color: ChiliTheme.skyBlue,
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // TOMBOL SCAN SEKARANG
            isLoading
                ? const CircularProgressIndicator(color: Colors.black)
                : InkWell(
                    onTap: (kIsWeb && _selectedImageBytes != null) || (!kIsWeb && _selectedImage != null) ? _processScan : null,
                    child: Opacity(
                      opacity: ((kIsWeb && _selectedImageBytes != null) || (!kIsWeb && _selectedImage != null)) ? 1.0 : 0.5,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: ChiliTheme.popArtDecoration(color: ChiliTheme.mintGreen),
                        child: const Center(
                          child: Text(
                            "MULAI DETEKSI (CNN)",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // WIDGET HELPER: Tombol Aksi Kecil
  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: ChiliTheme.popArtDecoration(color: color),
          child: Column(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(height: 5),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
