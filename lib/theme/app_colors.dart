import 'package:flutter/material.dart';

class AppColors {
  // Shared brand colors
  static const Color primary = Color(0xFFFFD700);       // Gold (matches logo)
  static const Color accentBlue = Color(0xFF00BFFF);    // Deep Sky Blue (matches logo)
  
  // Dark Theme Palette
  static const Color darkBackground = Color(0xFF0A0A0F);
  static const Color darkSurface = Color(0xFF12121A);
  static const Color darkSurfaceContainer = Color(0xFF1A1A26);
  static const Color darkSurfaceContainerHigh = Color(0xFF222233);
  static const Color darkSurfaceContainerHighest = Color(0xFF2A2A3F);
  static const Color darkOnSurface = Color(0xFFF5F5F7);
  static const Color darkOnSurfaceVariant = Color(0xFFA1A1B3);
  static const Color darkSecondary = Color(0xFF00E5FF);     // Cyan-Blue
  static const Color darkTertiary = Color(0xFFFFC107);      // Amber
  static const Color darkOutline = Color(0xFF32324D);

  // Light Theme Palette
  static const Color lightBackground = Color(0xFFF2F5FF);    // Softer blue-grey
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainer = Color(0xFFE8EEFB);
  static const Color lightSurfaceContainerHigh = Color(0xFFDEE6F7);
  static const Color lightSurfaceContainerHighest = Color(0xFFD4DEF2);
  static const Color lightOnSurface = Color(0xFF121221);
  static const Color lightOnSurfaceVariant = Color(0xFF4A4A6B);
  static const Color lightSecondary = Color(0xFF00A383);    
  static const Color lightTertiary = Color(0xFF9E8100);     
  static const Color lightOutline = Color(0xFFC5CBD9);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFFFF5E9B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkSecondaryGradient = LinearGradient(
    colors: [darkSecondary, Color(0xFF00BFA5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Helper getters (Legacy support - will be gradually replaced)
  static const Color background = darkBackground;
  static const Color surface = darkSurface;
  static const Color surfaceContainer = darkSurfaceContainer;
  static const Color surfaceContainerHigh = darkSurfaceContainerHigh;
  static const Color surfaceContainerHighest = darkSurfaceContainerHighest;
  static const Color onSurface = darkOnSurface;
  static const Color onSurfaceVariant = darkOnSurfaceVariant;
  static const Color secondary = darkSecondary;
  static const Color tertiary = darkTertiary;
  static const Color onPrimary = Color(0xFF1A0010);
  static const Color outline = darkOutline;
  static const Color error = Color(0xFFCF6679);

  // Neon glow opacities
  static Color primaryGlow(double opacity) => primary.withOpacity(opacity);
}
