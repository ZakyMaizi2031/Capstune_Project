import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChiliTheme {
  // ==========================================
  // 1. PALET WARNA (SPESIFIKASI CHILICARE)
  // ==========================================
  static const Color tomatoRed = Color(0xFFFF6347);   // Merah Tomat Cerah
  static const Color mintGreen = Color(0xFF98FF98);   // Hijau Mint Segar
  static const Color lemonYellow = Color(0xFFFFFACD); // Kuning Lemon Lembut
  static const Color blackPop = Color(0xFF1A1A1A);    // Hitam Pekat (Outline)
  static const Color whitePop = Color(0xFFFFFFFF);    // Putih Bersih

  // ==========================================
  // 2. KONFIGURASI THEME DATA GLOBAL
  // ==========================================
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: lemonYellow,
      
      // Font Utama: Plus Jakarta Sans (Modern & Clean)
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w900, color: blackPop, fontSize: 32,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w800, color: blackPop, fontSize: 22,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600, color: blackPop,
        ),
      ),

      // Style AppBar Pop-Art
      appBarTheme: AppBarTheme(
        backgroundColor: tomatoRed,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w900, fontSize: 20, color: whitePop,
        ),
        iconTheme: const IconThemeData(color: whitePop),
        shape: const Border(
          bottom: BorderSide(color: blackPop, width: 3),
        ),
      ),

      // Style Tombol Utama
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mintGreen,
          foregroundColor: blackPop,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: blackPop, width: 3),
          ),
        ),
      ),

      // Style Input Field (TextFormField)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: whitePop,
        labelStyle: const TextStyle(color: blackPop, fontWeight: FontWeight.bold),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: blackPop, width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: tomatoRed, width: 3),
        ),
        contentPadding: const EdgeInsets.all(18),
      ),
    );
  }

  // ==========================================
  // 3. CUSTOM DECORATION (UTAMA)
  // ==========================================
  // Gunakan ini untuk Container, Card, dll agar bergaya Pop-Art
  static BoxDecoration popArtDecoration({
    Color color = whitePop, 
    double borderRadius = 20.0,
    bool hasShadow = true,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: blackPop, width: 3), // Outline Hitam Tebal
      boxShadow: hasShadow 
        ? [
            const BoxShadow(
              color: blackPop, 
              offset: Offset(6, 6), // Bayangan Kaku (Hard Shadow)
              blurRadius: 0,
            )
          ]
        : [],
    );
  }

  // Header Style Khusus untuk Judul di Dalam Page
  static TextStyle get headerTitle => GoogleFonts.bungee(
    fontSize: 28,
    color: blackPop,
  );
}