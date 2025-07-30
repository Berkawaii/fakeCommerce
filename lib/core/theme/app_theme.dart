import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class AppTheme {
  // Monochromatic, muted light theme colors
  static const Color _lightBackgroundColor = Color(0xFFF5F5F7);
  static const Color _lightSurfaceColor = Color(0xFFEBEBEF);
  static const Color _lightAccentColor = Color(0xFF6D6D80);
  static const Color _lightTextColor = Color(0xFF383844);
  static const Color _lightTextSecondaryColor = Color(0xFF71717A);

  // Monochromatic, muted dark theme colors
  static const Color _darkBackgroundColor = Color(0xFF1F1F28);
  static const Color _darkSurfaceColor = Color(0xFF2C2C35);
  static const Color _darkAccentColor = Color(0xFF9999AA);
  static const Color _darkTextColor = Color(0xFFE2E2E6);
  static const Color _darkTextSecondaryColor = Color(0xFFB0B0B8);

  // Common colors - more muted versions
  static const Color errorColor = Color(0xFFBF6E6E);
  static const Color successColor = Color(0xFF78A27A);
  static const Color warningColor = Color(0xFFB29E75);

  // Light theme
  static NeumorphicThemeData lightTheme = NeumorphicThemeData(
    baseColor: _lightBackgroundColor,
    lightSource: LightSource.topLeft,
    depth: 6, // Reduced depth for more subtle effect
    intensity: 0.5, // Reduced intensity for more muted look
    accentColor: _lightAccentColor,
    shadowDarkColor: Colors.grey.withOpacity(0.2), // Softer shadow
    shadowLightColor: Colors.white.withOpacity(0.8), // Softer highlight
    appBarTheme: NeumorphicAppBarThemeData(
      buttonStyle: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
        depth: 3, // More subtle depth
        intensity: 0.5,
        color: _lightSurfaceColor,
      ),
      textStyle: const TextStyle(
        color: _lightTextColor,
        fontWeight: FontWeight.w500, // Less bold for more subtle look
      ),
      color: _lightBackgroundColor,
      iconTheme: const IconThemeData(color: _lightTextColor),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: _lightTextColor,
        fontSize: 24, // Slightly smaller
        fontWeight: FontWeight.w600, // Less bold for more refined look
      ),
      headlineMedium: TextStyle(
        color: _lightTextColor,
        fontSize: 20, // Slightly smaller
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: _lightTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: _lightTextColor,
        fontSize: 16,
        fontWeight: FontWeight.w500, // Less bold
      ),
      titleMedium: TextStyle(
        color: _lightTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: _lightTextSecondaryColor, // Using secondary color for body text
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: _lightTextSecondaryColor, // Using secondary color for body text
        fontSize: 14,
      ),
    ),
    buttonStyle: NeumorphicStyle(
      boxShape: NeumorphicBoxShape.roundRect(
        BorderRadius.circular(10),
      ), // Slightly smaller radius
      depth: 5, // Less depth for more subtle effect
      intensity: 0.5, // Less intensity for muted look
      color: _lightSurfaceColor, // Using surface color for buttons
      shadowLightColor: Colors.white.withOpacity(0.8),
      shadowDarkColor: Colors.grey.withOpacity(0.2),
    ),
    iconTheme: IconThemeData(
      color: _lightAccentColor, // Using accent color for icons
      size: 22, // Slightly smaller icons
    ),
  );

  // Dark theme - monochromatic muted
  static NeumorphicThemeData darkTheme = NeumorphicThemeData(
    baseColor: _darkBackgroundColor,
    lightSource: LightSource.topLeft,
    depth: 4, // Less depth for subtle effect
    intensity: 0.4, // Less intensity for muted look
    accentColor: _darkAccentColor,
    shadowLightColor: Colors.white.withOpacity(
      0.05,
    ), // Very subtle light shadow
    shadowDarkColor: Colors.black.withOpacity(0.6), // Softer dark shadow
    appBarTheme: NeumorphicAppBarThemeData(
      buttonStyle: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
        depth: 3, // Less depth
        intensity: 0.4, // Less intensity
        color: _darkSurfaceColor, // Using surface color
      ),
      textStyle: const TextStyle(
        color: _darkTextColor,
        fontWeight: FontWeight.w500, // Less bold for refined look
      ),
      color: _darkBackgroundColor,
      iconTheme: const IconThemeData(
        color: _darkAccentColor, // Using accent color for icons
        size: 22, // Slightly smaller
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: _darkTextColor,
        fontSize: 24, // Slightly smaller
        fontWeight: FontWeight.w600, // Less bold for more refined look
      ),
      headlineMedium: TextStyle(
        color: _darkTextColor,
        fontSize: 20, // Slightly smaller
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: _darkTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: _darkTextColor,
        fontSize: 16,
        fontWeight: FontWeight.w500, // Less bold
      ),
      titleMedium: TextStyle(
        color: _darkTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: _darkTextSecondaryColor, // Using secondary color for body text
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: _darkTextSecondaryColor, // Using secondary color for body text
        fontSize: 14,
      ),
    ),
    buttonStyle: NeumorphicStyle(
      boxShape: NeumorphicBoxShape.roundRect(
        BorderRadius.circular(10),
      ), // Slightly smaller radius
      depth: 3, // Less depth for more subtle effect
      intensity: 0.4, // Less intensity for muted look
      color: _darkSurfaceColor, // Using surface color for buttons
      shadowLightColor: Colors.white.withOpacity(0.05),
      shadowDarkColor: Colors.black.withOpacity(0.7),
    ),
    iconTheme: IconThemeData(
      color: _darkAccentColor, // Using accent color for icons
      size: 22, // Slightly smaller icons
    ),
  );
}
