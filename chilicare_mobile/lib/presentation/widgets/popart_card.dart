import 'package:flutter/material.dart';
import '../../core/themes/app_theme.dart';

class PopArtCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final double borderRadius;
  final double padding;
  final VoidCallback? onTap;
  final bool hasShadow;

  const PopArtCard({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.borderRadius = 20.0,
    this.padding = 16.0,
    this.onTap,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Margin default agar shadow tidak terpotong di dalam list
        margin: const EdgeInsets.only(bottom: 12, right: 6),
        padding: EdgeInsets.all(padding),
        decoration: ChiliTheme.popArtDecoration(
          color: color,
          hasShadow: hasShadow,
        ),
        child: child,
      ),
    );
  }
}

// Widget Tambahan: Judul di dalam Card agar Konsisten
class PopArtCardHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color iconColor;

  const PopArtCardHeader({
    super.key,
    required this.title,
    this.icon,
    this.iconColor = ChiliTheme.tomatoRed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Icon(icon, color: Colors.black, size: 20),
          ),
          const SizedBox(width: 12),
        ],
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}