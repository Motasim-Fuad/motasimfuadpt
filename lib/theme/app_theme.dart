import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color bg = Color(0xFFF3EEE4);
  static const Color surface = Color(0xFFFAF6EE);
  static const Color card = Color(0xFFFFFCF7);
  static const Color cardHover = Color(0xFFF6F0E4);
  static const Color border = Color(0xFFD9D0C0);
  static const Color ink = Color(0xFF1C1915);
  static const Color rust = Color(0xFFB54A2A);
  static const Color rustDim = Color(0x1AB54A2A);
  static const Color forest = Color(0xFF2F473D);
  static const Color forestDim = Color(0x1A2F473D);
  static const Color gold = Color(0xFFB0893A);

  static const Color cyan = rust;
  static const Color cyanDim = rustDim;
  static const Color purple = forest;
  static const Color purpleDim = forestDim;
  static const Color green = Color(0xFF3D6B4F);
  static const Color textPrimary = ink;
  static const Color textSecondary = Color(0xFF5C564C);
  static const Color textMuted = Color(0xFF8A8376);

  static const Color dashBg = Color(0xFF141210);
  static const Color dashSurface = Color(0xFF1C1916);
  static const Color dashCard = Color(0xFF24201C);
  static const Color dashBorder = Color(0xFF3A342C);
  static const Color dashText = Color(0xFFF3EEE4);
  static const Color dashMuted = Color(0xFF9A9286);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF3EEE4), Color(0xFFEDE6D8)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFB54A2A), Color(0xFF8F3A22)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFCF7), Color(0xFFF7F1E6)],
  );

  static const LinearGradient dashCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2A2622), Color(0xFF1C1916)],
  );
}

class AppTheme {
  static TextTheme _textTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: GoogleFonts.fraunces(
        color: primary,
        fontSize: 64,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.6,
        height: 0.95,
      ),
      displayMedium: GoogleFonts.fraunces(
        color: primary,
        fontSize: 44,
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
      ),
      displaySmall: GoogleFonts.fraunces(
        color: primary,
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: GoogleFonts.fraunces(
        color: primary,
        fontSize: 26,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.fraunces(
        color: primary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.outfit(
        color: secondary,
        fontSize: 16,
        height: 1.7,
      ),
      bodyMedium: GoogleFonts.outfit(
        color: secondary,
        fontSize: 14,
        height: 1.6,
      ),
      labelLarge: GoogleFonts.outfit(
        color: primary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.rust,
        secondary: AppColors.forest,
        surface: AppColors.surface,
        onPrimary: Color(0xFFFFF8F0),
        onSecondary: Colors.white,
        onSurface: AppColors.ink,
      ),
      textTheme: _textTheme(AppColors.ink, AppColors.textSecondary),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.rust,
        selectionColor: AppColors.rust.withValues(alpha: 0.22),
        selectionHandleColor: AppColors.rust,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.rust,
          foregroundColor: const Color(0xFFFFF8F0),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.ink, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.rust, width: 1.4),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textMuted),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondary),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.ink,
        elevation: 0,
        titleTextStyle: GoogleFonts.fraunces(
          color: AppColors.ink,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static ThemeData get dashboardTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.dashBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.rust,
        secondary: AppColors.gold,
        surface: AppColors.dashSurface,
        onPrimary: Color(0xFFFFF8F0),
        onSecondary: AppColors.ink,
        onSurface: AppColors.dashText,
      ),
      textTheme: _textTheme(AppColors.dashText, AppColors.dashMuted),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.rust,
        selectionColor: AppColors.rust.withValues(alpha: 0.28),
        selectionHandleColor: AppColors.rust,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.rust,
          foregroundColor: const Color(0xFFFFF8F0),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.dashText,
          side: const BorderSide(color: AppColors.dashBorder),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.dashCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.dashBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.dashBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.rust, width: 1.4),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.dashCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: AppColors.dashBorder),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.dashBorder),
      iconTheme: const IconThemeData(color: AppColors.dashMuted),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.dashSurface,
        foregroundColor: AppColors.dashText,
        elevation: 0,
        titleTextStyle: GoogleFonts.outfit(
          color: AppColors.dashText,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
