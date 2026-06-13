import 'package:flutter/material.dart';

/// Definisi warna dan tema untuk ChiliCare App
/// Menggunakan desain Pop-Art / Neubrutalism dengan warna-warna cerah dan bold
class ChiliTheme {
  // ==========================================
  // WARNA UTAMA (Pop-Art / Neubrutalism)
  // ==========================================
  
  /// Warna Merah Tomat - Warna Dominan untuk ChiliCare
  static const Color tomatoRed = Color(0xFFE74C3C);
  
  /// Warna Kuning Lemon - Background dan Accent
  static const Color lemonYellow = Color(0xFFFFFDC4);
  
  /// Warna Hijau Mint - Button dan Success States
  static const Color mintGreen = Color(0xFF27AE60);

  /// Warna Putih-krim untuk background kartu (agar hijau-putih terasa lebih hangat)
  static const Color creamWhite = Color(0xFFFFFBF2);

  /// Warna hijau yang lebih muda untuk highlight/secondary background
  static const Color mintSoft = Color(0xFFBDF7D1);


  
  /// Warna Orange Cerah - Warning dan Secondary Accent
  static const Color brightOrange = Color(0xFFF39C12);
  
  /// Warna Purple Berani - Accent Sekunder
  static const Color boldPurple = Color(0xFF8E44AD);
  
  /// Warna Pink Cerah
  static const Color brightPink = Color(0xFFE91E63);
  
  // ==========================================
  // WARNA TAMBAHAN
  // ==========================================
  
  /// Warna Biru Langit untuk accent
  static const Color skyBlue = Color(0xFF87CEEB);
  
  // ==========================================
  // WARNA NETRAL
  // ==========================================
  
  /// Hitam Bold untuk Border dan Text
  static const Color darkBlack = Color(0xFF1A1A1A);
  
  /// Putih Bersih
  static const Color cleanWhite = Color(0xFFFFFFFF);
  
  /// Abu-abu Terang
  static const Color lightGray = Color(0xFFF5F5F5);
  
  /// Abu-abu Gelap
  static const Color darkGray = Color(0xFF333333);
  
  // ==========================================
  // UTILITY COLORS
  // ==========================================
  
  /// Warna Error/Danger
  static const Color errorRed = Color(0xFFC0392B);
  
  /// Warna Success
  static const Color successGreen = Color(0xFF229954);
  
  /// Warna Warning
  static const Color warningOrange = Color(0xFFD68910);
  
  /// Warna Info
  static const Color infoBlue = Color(0xFF3498DB);
  
  // ==========================================
  // SHADOW & BORDERS
  // ==========================================
  
  static const double boldBorderWidth = 2.5;
  static const double normalBorderWidth = 1.5;
  static const double thinBorderWidth = 1.0;
  
  static const double standardBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  static const double smallBorderRadius = 8.0;
  
  // ==========================================
  // TEXT STYLES
  // ==========================================
  
  /// Large Heading (Bold & Boxy)
  static TextStyle headingLarge = const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: darkBlack,
    letterSpacing: 0.5,
  );
  
  /// Medium Heading
  static TextStyle headingMedium = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: darkBlack,
    letterSpacing: 0.3,
  );
  
  /// Small Heading
  static TextStyle headingSmall = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: darkBlack,
    letterSpacing: 0.2,
  );
  
  /// Body Text Regular
  static TextStyle bodyRegular = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: darkBlack,
    height: 1.5,
  );
  
  /// Body Text Small
  static TextStyle bodySmall = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: darkGray,
    height: 1.4,
  );
  
  /// Caption Text
  static TextStyle caption = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: darkGray,
    height: 1.3,
  );
  
  /// Button Text (Bold & Large)
  static TextStyle buttonText = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: darkBlack,
    letterSpacing: 0.5,
  );

  // ==========================================
  // DECORATION BUILDERS
  // ==========================================

  /// Pop-Art Decoration Box (Bold Borders & Warna Cerah)
  static BoxDecoration popArtDecoration({
    Color color = Colors.white,
    Color borderColor = Colors.black,
    double borderWidth = boldBorderWidth,
    double radius = standardBorderRadius,
    bool hasShadow = true,
  }) {
    return BoxDecoration(
      color: color,
      border: Border.all(color: borderColor, width: borderWidth),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: hasShadow
          ? [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.15),
                offset: const Offset(4, 4),
                blurRadius: 0,
              ),
            ]
          : [],
    );
  }

  /// Decoration untuk Card (Neubrutalism Style)
  static BoxDecoration cardDecoration({
    Color color = Colors.white,
    Color borderColor = Colors.black,
    double borderWidth = normalBorderWidth,
  }) {
    return BoxDecoration(
      color: color,
      border: Border.all(color: borderColor, width: borderWidth),
      borderRadius: BorderRadius.circular(standardBorderRadius),
      boxShadow: [
        BoxShadow(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(2, 2),
          blurRadius: 0,
        ),
      ],
    );
  }

  // ==========================================
  // LEGACY TEXT STYLES (untuk compatibility)
  // ==========================================

  /// Header Title (sama dengan headingLarge)
  static TextStyle headerTitle = headingLarge;

  /// Subtitle Style
  static TextStyle subtitle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: darkGray,
    letterSpacing: 0.3,
  );
}
