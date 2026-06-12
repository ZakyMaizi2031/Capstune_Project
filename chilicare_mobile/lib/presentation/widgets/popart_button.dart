import 'package:flutter/material.dart';
import '../../core/themes/app_theme.dart';

class PopArtButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final Color color;
  final IconData? icon;
  final bool isLoading;
  final double? width;

  const PopArtButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color = ChiliTheme.mintGreen, // Default warna ceria
    this.icon,
    this.isLoading = false,
    this.width,
  });

  @override
  State<PopArtButton> createState() => _PopArtButtonState();
}

class _PopArtButtonState extends State<PopArtButton> {
  // State untuk melacak apakah tombol sedang ditekan
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Logika animasi saat ditekan
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.isLoading ? null : widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.width ?? double.infinity,
        // Saat ditekan, tombol bergeser sedikit ke bawah-kanan (sesuai arah shadow)
        transform: _isPressed 
            ? Matrix4.translationValues(4, 4, 0) 
            : Matrix4.translationValues(0, 0, 0),
        decoration: ChiliTheme.popArtDecoration(
          color: widget.color,
          // Saat ditekan, bayangan dihilangkan/dikurangi agar terlihat menempel ke lantai
          hasShadow: !_isPressed, 
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Center(
          child: widget.isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 3,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: Colors.black, size: 22),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      widget.text.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}