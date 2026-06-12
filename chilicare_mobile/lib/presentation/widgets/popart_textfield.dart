import 'package:flutter/material.dart';
import '../../core/themes/app_theme.dart';

class PopArtTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;

  const PopArtTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas Input (jika ada)
        if (labelText != null) ...[
          Text(
            labelText!.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.2,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
        ],
        
        // Wadah Input bergaya Pop-Art
        Container(
          decoration: ChiliTheme.popArtDecoration(
            color: Colors.white,
            hasShadow: false, // Kita matikan shadow agar tidak bertumpuk saat mengetik
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            validator: validator,
            maxLines: maxLines,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
              prefixIcon: prefixIcon != null 
                  ? Icon(prefixIcon, color: Colors.black, size: 22) 
                  : null,
              
              // Menghilangkan border bawaan karena sudah ditangani oleh Container
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              
              // Efek saat error validasi
              errorStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: ChiliTheme.tomatoRed,
              ),
            ),
          ),
        ),
      ],
    );
  }
}