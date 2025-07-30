import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class AppTheme {
  // Light theme colors
  static const Color _lightBackgroundColor = Color(0xFFE0E5EC);
  static const Color _lightAccentColor = Color(0xFF7B68EE);
  static const Color _lightTextColor = Color(0xFF303030);
  
  // Dark theme colors
  static const Color _darkBackgroundColor = Color(0xFF333333);
  static const Color _darkAccentColor = Color(0xFF9370DB);
  static const Color _darkTextColor = Color(0xFFE0E0E0);

  // Common colors
  static const Color errorColor = Color(0xFFE57373);
  static const Color successColor = Color(0xFF81C784);

  // Light theme
  static NeumorphicThemeData lightTheme = NeumorphicThemeData(
    baseColor: _lightBackgroundColor,
    lightSource: LightSource.topLeft,
    depth: 10,
    intensity: 0.7,
    accentColor: _lightAccentColor,
    appBarTheme: NeumorphicAppBarThemeData(
      buttonStyle: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
        depth: 5,
        intensity: 0.7,
        color: _lightBackgroundColor,
      ),
      textStyle: const TextStyle(
        color: _lightTextColor,
        fontWeight: FontWeight.w600,
      ),
      color: _lightBackgroundColor,
      iconTheme: const IconThemeData(
        color: _lightTextColor,
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: _lightTextColor,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: _lightTextColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: _lightTextColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: _lightTextColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: _lightTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: _lightTextColor,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: _lightTextColor,
        fontSize: 14,
      ),
    ),
    buttonStyle: NeumorphicStyle(
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      depth: 8,
      intensity: 0.7,
      color: _lightBackgroundColor,
    ),
    iconTheme: IconThemeData(
      color: _lightTextColor,
    ),
  );

  // Dark theme
  static NeumorphicThemeData darkTheme = NeumorphicThemeData(
    baseColor: _darkBackgroundColor,
    lightSource: LightSource.topLeft,
    depth: 6,
    intensity: 0.6,
    accentColor: _darkAccentColor,
    shadowLightColor: Colors.white12,
    shadowDarkColor: Colors.black,
    appBarTheme: NeumorphicAppBarThemeData(
      buttonStyle: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
        depth: 5,
        intensity: 0.6,
        color: _darkBackgroundColor,
      ),
      textStyle: const TextStyle(
        color: _darkTextColor,
        fontWeight: FontWeight.w600,
      ),
      color: _darkBackgroundColor,
      iconTheme: const IconThemeData(
        color: _darkTextColor,
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: _darkTextColor,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: _darkTextColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: _darkTextColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: _darkTextColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: _darkTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: _darkTextColor,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: _darkTextColor,
        fontSize: 14,
      ),
    ),
    buttonStyle: NeumorphicStyle(
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      depth: 6,
      intensity: 0.6,
      color: _darkBackgroundColor,
    ),
    iconTheme: IconThemeData(
      color: _darkTextColor,
    ),
  );
}
