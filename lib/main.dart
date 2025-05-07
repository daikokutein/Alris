import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define logo color for consistent use throughout the app
    const logoColor = Color(0xFF00E5FF); // Cyan from the eye logo
    // Define dark purple color for the theme
    const darkPurple = Color(0xFF2D1B69);
    const deeperPurple = Color(0xFF1A0F3C);
    
    return MaterialApp(
      title: 'Alris',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: logoColor,
          brightness: Brightness.light,
          primary: logoColor,
          secondary: darkPurple,
          tertiary: const Color(0xFF38BDF8), // Light blue
          surface: Colors.white,
          surfaceTint: Colors.white.withOpacity(0.9),
          surfaceContainer: const Color(0xFFF8F9FA),
          error: const Color(0xFFEF4444),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).copyWith(
          displayLarge: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: deeperPurple,
          ),
          displayMedium: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: deeperPurple,
          ),
          headlineMedium: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: deeperPurple,
          ),
          titleLarge: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: deeperPurple,
          ),
          bodyLarge: GoogleFonts.inter(
            color: const Color(0xFF334155),
          ),
          bodyMedium: GoogleFonts.inter(
            color: const Color(0xFF64748B),
          ),
        ),
        appBarTheme: AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: deeperPurple,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: deeperPurple,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: logoColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: logoColor,
            textStyle: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: logoColor, width: 2),
          ),
          contentPadding: const EdgeInsets.all(16),
          hintStyle: GoogleFonts.inter(
            fontSize: 15,
            color: Colors.grey[400],
          ),
          labelStyle: GoogleFonts.inter(
            fontSize: 15,
            color: Colors.grey[700],
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          surfaceTintColor: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        dividerTheme: DividerThemeData(
          color: Colors.grey[200],
          thickness: 1,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: logoColor, 
          brightness: Brightness.dark,
          primary: logoColor, // Using the same cyan in dark mode
          secondary: const Color(0xFF81E6FF), // Lighter cyan
          tertiary: const Color(0xFF38BDF8), // Light blue
          error: const Color(0xFFF87171),
          surface: const Color(0xFF0A0A18),
          background: const Color(0xFF0A0A18),
          surfaceContainer: const Color(0xFF1A0F3C),
          surfaceTint: const Color(0xFF1A0F3C),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0A0A18),
        appBarTheme: AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: const Color(0xFF1A0F3C),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          color: const Color(0xFF1A0F3C),
          shadowColor: Colors.black.withOpacity(0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          surfaceTintColor: const Color(0xFF1A0F3C),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
          displayLarge: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          displayMedium: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineMedium: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleLarge: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyLarge: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.9),
          ),
          bodyMedium: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: logoColor,
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1A0F3C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[800]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[800]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: logoColor, width: 2),
          ),
          hintStyle: GoogleFonts.inter(
            fontSize: 15,
            color: Colors.grey[600],
          ),
          labelStyle: GoogleFonts.inter(
            fontSize: 15,
            color: Colors.grey[400],
          ),
        ),
        dividerTheme: DividerThemeData(
          color: Colors.grey[800],
          thickness: 1,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
