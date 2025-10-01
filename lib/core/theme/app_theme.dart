import 'package:flutter/material.dart';

class AppTheme {
  /// Light Theme
  static ThemeData light = ThemeData.light().copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.grey[200],
    primaryColor:
        Colors.blue, // historically primary, but overridden by colorScheme
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary:
          Colors.blueAccent, // same as `secondary` field before Material 3
      surface: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStatePropertyAll(5),
        shadowColor: WidgetStatePropertyAll(Colors.grey[300]),
        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        foregroundColor: WidgetStatePropertyAll(Colors.grey[800]),
        textStyle: WidgetStatePropertyAll(
          TextStyle(
            shadows: [Shadow(color: Colors.white, blurRadius: 10)],
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: WidgetStatePropertyAll(Colors.grey[400]!),
      ),
    ),

    textTheme: Typography.blackMountainView, // Material baseline black text
  );

  /// Dark Theme
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[300],
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.grey,
      primary: Colors.grey[300]!,
      secondary: Colors.blueAccent,
      background: Colors.black,
      brightness: Brightness.dark,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
      labelLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white30),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: const TextStyle(color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        foregroundColor: Colors.black,
      ),
    ),
  );
}
