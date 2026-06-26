import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return _baseTheme(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Color(0xFF1A0010),
        secondary: AppColors.darkSecondary,
        onSecondary: Color(0xFF003D31),
        tertiary: AppColors.darkTertiary,
        onTertiary: Color(0xFF3D2E00),
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
        outline: AppColors.darkOutline,
        error: Color(0xFFCF6679),
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      onSurfaceVariant: AppColors.darkOnSurfaceVariant,
      surfaceContainer: AppColors.darkSurfaceContainer,
      surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
    );
  }

  static ThemeData get lightTheme {
    return _baseTheme(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.lightSecondary,
        onSecondary: Colors.white,
        tertiary: AppColors.lightTertiary,
        onTertiary: Colors.white,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
        surfaceContainerHighest: AppColors.lightSurfaceContainerHighest,
        outline: AppColors.lightOutline,
        error: Color(0xFFB00020),
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      onSurfaceVariant: AppColors.lightOnSurfaceVariant,
      surfaceContainer: AppColors.lightSurfaceContainer,
      surfaceContainerHigh: AppColors.lightSurfaceContainerHigh,
    );
  }

  static ThemeData _baseTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color scaffoldBackgroundColor,
    required Color onSurfaceVariant,
    required Color surfaceContainer,
    required Color surfaceContainerHigh,
  }) {
    final isDark = brightness == Brightness.dark;
    
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.sora(
          fontSize: 36, fontWeight: FontWeight.w800, color: colorScheme.onSurface,
          letterSpacing: -1.5,
        ),
        displayMedium: GoogleFonts.sora(
          fontSize: 28, fontWeight: FontWeight.w700, color: colorScheme.onSurface,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.sora(
          fontSize: 22, fontWeight: FontWeight.w700, color: colorScheme.onSurface,
        ),
        headlineLarge: GoogleFonts.sora(
          fontSize: 20, fontWeight: FontWeight.w700, color: colorScheme.onSurface,
        ),
        headlineMedium: GoogleFonts.sora(
          fontSize: 18, fontWeight: FontWeight.w600, color: colorScheme.onSurface,
        ),
        headlineSmall: GoogleFonts.sora(
          fontSize: 16, fontWeight: FontWeight.w600, color: colorScheme.onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w400, color: colorScheme.onSurface,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w400, color: onSurfaceVariant,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w400, color: onSurfaceVariant,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w700, color: onSurfaceVariant,
          letterSpacing: 1.5,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 11, fontWeight: FontWeight.w600, color: onSurfaceVariant,
          letterSpacing: 1.2,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 10, fontWeight: FontWeight.w600, color: onSurfaceVariant,
          letterSpacing: 1.0,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceContainer,
        indicatorColor: colorScheme.secondary.withOpacity(0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.sora(
              fontSize: 10, fontWeight: FontWeight.w800, color: colorScheme.secondary,
            );
          }
          return GoogleFonts.inter(
            fontSize: 10, fontWeight: FontWeight.w500, color: onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.secondary, size: 24);
          }
          return IconThemeData(color: onSurfaceVariant, size: 22);
        }),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackgroundColor.withOpacity(0.95),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.sora(
          fontSize: 18, fontWeight: FontWeight.w800, color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.secondary),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainer,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(isDark ? 0.5 : 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colorScheme.outline.withOpacity(0.2), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.secondary, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(color: onSurfaceVariant.withOpacity(0.5)),
        labelStyle: GoogleFonts.inter(color: onSurfaceVariant),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withOpacity(0.3),
        thickness: 1,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceContainer,
        selectedColor: colorScheme.secondary.withOpacity(0.15),
        labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        side: BorderSide(color: colorScheme.outline.withOpacity(0.4)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
