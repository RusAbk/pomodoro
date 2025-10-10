import 'package:flutter/material.dart';
import 'ui/screens/home_page.dart';
import 'core/design_system.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Timer 🍅',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: AppColors.primaryColor,
      fontFamily: 'system-ui',
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      
      // Card Theme: use default CardTheme from Material; custom CardTheme removed to avoid SDK mismatch
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      // Button Themes
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      // Scaffold Theme
      scaffoldBackgroundColor: const Color(0xFFFAFBFC),
      
      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: -0.25,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        bodyLarge: TextStyle(
          letterSpacing: 0.15,
        ),
        bodyMedium: TextStyle(
          letterSpacing: 0.25,
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: AppColors.primaryColor,
      fontFamily: 'system-ui',
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      
      // Card Theme: use default CardTheme from Material; custom CardTheme removed to avoid SDK mismatch
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      
      // Button Themes
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      // Scaffold Theme
      scaffoldBackgroundColor: const Color(0xFF0D1117),
      
      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: -0.25,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        bodyLarge: TextStyle(
          letterSpacing: 0.15,
        ),
        bodyMedium: TextStyle(
          letterSpacing: 0.25,
        ),
      ),
    );
  }
}
