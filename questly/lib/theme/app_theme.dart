import 'package:flutter/material.dart';

import '../models/quest.dart';

/// All colors, gradients and the Material 3 theme live here so the whole
/// app looks consistent.
class AppTheme {
  AppTheme._();

  static const Color background = Color(0xFF0E0A22);
  static const Color surface = Color(0xFF1B1547);
  static const Color primary = Color(0xFF7C5CFF);
  static const Color accent = Color(0xFF3DDCFF);
  static const Color gold = Color(0xFFFFC94D);
  static const Color orange = Color(0xFFFFA726);
  static const Color success = Color(0xFF3DDC97);
  static const Color danger = Color(0xFFFF6B81);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF17113A), Color(0xFF0B0819)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C5CFF), Color(0xFF4527C9)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2A2060), Color(0xFF1E1750)],
  );

  static const LinearGradient completedGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B4D45), Color(0xFF173B3A)],
  );

  static const LinearGradient xpGradient = LinearGradient(
    colors: [Color(0xFF7C5CFF), Color(0xFF3DDCFF)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD86B), Color(0xFFFFA726)],
  );

  static const LinearGradient streakGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF8A3D), Color(0xFFE8384F)],
  );

  /// Returns a color for each priority level.
  static Color priorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return danger;
      case Priority.medium:
        return orange;
      case Priority.low:
        return success;
    }
  }

  /// Shared style for all form fields.
  static InputDecoration inputDecoration(String label, IconData icon) {
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: width),
        );
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.06),
      border: border(Colors.transparent, 0),
      enabledBorder: border(Colors.transparent, 0),
      focusedBorder: border(primary, 1.6),
      errorBorder: border(danger, 1.2),
      focusedErrorBorder: border(danger, 1.6),
    );
  }

  static ThemeData get darkTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      surface: surface,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withValues(alpha: 0.4),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
