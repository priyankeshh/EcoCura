import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Clean White & Green Design - Modern & Fresh
  static const Color primaryGreen = Color(0xFF4CAF50);      // Clean bright green
  static const Color lightGreen = Color(0xFFC8E6C9);        // Very light green
  static const Color darkGreen = Color(0xFF2E7D32);         // Darker green for contrast
  static const Color accentGreen = Color(0xFF81C784);       // Soft green accent
  static const Color leafGreen = Color(0xFFA5D6A7);         // Gentle leaf green

  // Background & Surface Colors - Clean White Design
  static const Color backgroundColor = Color(0xFFFFFFFF);    // Pure white background
  static const Color cardColor = Color(0xFFFFFFFF);         // White cards
  static const Color surfaceColor = Color(0xFFF1F8E9);      // Very light green surface
  static const Color headerColor = Color(0xFFC8E6C9);       // Light green header

  // Text Colors - Better Contrast
  static const Color textPrimary = Color(0xFF212121);       // Dark gray text
  static const Color textSecondary = Color(0xFF757575);     // Medium gray text
  static const Color textLight = Color(0xFF9E9E9E);         // Light gray text

  // Accent Colors
  static const Color warningColor = Color(0xFFFF9800);      // Orange for warnings
  static const Color errorColor = Color(0xFFE53935);        // Red for errors
  static const Color successColor = Color(0xFF4CAF50);      // Green for success

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.light,
        primary: primaryGreen,
        secondary: accentGreen,
        surface: backgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.w600),
        headlineLarge: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.poppins(color: textPrimary),
        bodyMedium: GoogleFonts.poppins(color: textSecondary),
      ),

      // AppBar Theme - Clean light green header
      appBarTheme: AppBarTheme(
        backgroundColor: headerColor,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Theme - Enhanced for presentation
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 3,
        shadowColor: primaryGreen.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Button Themes - Enhanced for presentation
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryGreen.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentGreen,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // Input Decoration Theme - Fixed for better text visibility
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryGreen),
        ),
        filled: true,
        fillColor: Colors.white,
        // Explicitly set text colors for better visibility
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: TextStyle(color: Colors.grey[600]),
      ),
      
      // Scaffold Background
      scaffoldBackgroundColor: backgroundColor,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.dark,
        primary: primaryGreen,
        secondary: accentGreen,
        surface: const Color(0xFF1E1E1E),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        headlineLarge: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.poppins(color: Colors.white),
        bodyMedium: GoogleFonts.poppins(color: Colors.white70),
      ),

      // AppBar Theme for dark mode
      appBarTheme: AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Theme for dark mode
      cardTheme: CardThemeData(
        color: const Color(0xFF2D2D2D),
        elevation: 3,
        shadowColor: primaryGreen.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Input Decoration Theme for dark mode - Fixed for better text visibility
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryGreen),
        ),
        filled: true,
        fillColor: const Color(0xFF2D2D2D),
        // Explicitly set text colors for dark mode
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white54),
      ),

      scaffoldBackgroundColor: const Color(0xFF121212),
    );
  }
}

// Custom Text Styles
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppTheme.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppTheme.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppTheme.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppTheme.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppTheme.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppTheme.textSecondary,
  );
}
