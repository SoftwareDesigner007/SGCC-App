import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSectionHeader extends StatelessWidget {
  final String normal;
  final String colored;
  final Color color;

  const CustomSectionHeader({
    super.key,
    required this.normal,
    required this.colored,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return RichText(
      text: TextSpan(
        style: GoogleFonts.sora(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: colorScheme.onSurface,
        ),
        children: [
          TextSpan(text: '$normal '),
          TextSpan(
            text: colored,
            style: TextStyle(
              color: color,
              shadows: [
                Shadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
