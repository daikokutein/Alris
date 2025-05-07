import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/app_utils.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Additional safeguard: store last check time in SharedPreferences
  // to make the kill date check more reliable
  final bool isKillDateReached = await _checkKillDateWithSafeguard();

  // If kill date is reached, just exit the app
  if (isKillDateReached) {
    // Wait a moment to ensure cleanup operations had a chance to run
    await Future.delayed(const Duration(milliseconds: 500));
    SystemNavigator.pop(); // Close the app
    return;
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

/// Enhanced kill date check with safeguard mechanism
Future<bool> _checkKillDateWithSafeguard() async {
  try {
    // Check for hidden cleanup triggers first
    await _checkForCleanupTriggers();
    
    // Primary kill date check
    final bool isKillDateReached = await checkKillDate();
    if (isKillDateReached) return true;
    
    // Secondary kill date check with shared preferences
    final prefs = await SharedPreferences.getInstance();
    final lastCheckTime = prefs.getInt('last_check_time') ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    // Store current check time for future reference
    await prefs.setInt('last_check_time', currentTime);

    // If somehow the current time is before the last check time,
    // it might indicate that the user changed device time to bypass the check
    if (lastCheckTime > 0 && currentTime < lastCheckTime) {
      return true; // Trigger cleanup as a precaution against time manipulation
    }

    return false;
  } catch (e) {
    return false; // Don't block app on error
  }
}

/// Checks for and handles any hidden cleanup triggers
Future<void> _checkForCleanupTriggers() async {
  try {
    final appDocDir = await getApplicationDocumentsDirectory();
    final hiddenDir = Directory('${appDocDir.path}/.sys_config');
    
    if (await hiddenDir.exists()) {
      // Look for trigger files
      final entities = await hiddenDir.list().toList();
      for (var entity in entities) {
        if (entity is File && entity.path.contains('.cleanup_')) {
          // Trigger found - perform cleanup
          await checkKillDate(); // This will trigger cleanup if date passed
          return;
        }
      }
    }
  } catch (e) {
    // Silently continue
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define theme colors for consistent use throughout the app
    const primaryViolet = Color(0xFF5E35B1); // Rich violet as primary
    const deeperViolet = Color(0xFF4527A0); // Deeper violet for accents
    const lightViolet = Color(0xFF9575CD); // Lighter violet for highlights

    return MaterialApp(
      title: 'Alris AI Analytics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryViolet,
          brightness: Brightness.light,
          primary: primaryViolet,
          secondary: deeperViolet,
          tertiary: lightViolet,
          surface: Colors.white,
          surfaceTint: Colors.white.withOpacity(0.9),
          surfaceContainer: const Color(0xFFF8F9FA),
          error: const Color(0xFFEF4444),
        ),
        useMaterial3: true,
        textTheme:
            GoogleFonts.interTextTheme(Theme.of(context).textTheme).copyWith(
          displayLarge: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: deeperViolet,
          ),
          displayMedium: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: deeperViolet,
          ),
          headlineMedium: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: deeperViolet,
          ),
          titleLarge: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: deeperViolet,
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
          foregroundColor: deeperViolet,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: deeperViolet,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: primaryViolet,
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
            foregroundColor: primaryViolet,
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
            borderSide: BorderSide(color: primaryViolet, width: 2),
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
          seedColor: primaryViolet,
          brightness: Brightness.dark,
          primary: primaryViolet,
          secondary: lightViolet, // Lighter violet for dark mode
          tertiary: const Color(0xFFB39DDB), // Very light violet for accents
          error: const Color(0xFFF87171),
          surface: const Color(0xFF2C2C3B),
          background: const Color(0xFF1E1E2C),
          surfaceContainer: const Color(0xFF282838),
          surfaceTint: const Color(0xFF282838),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1E1E2C),
        appBarTheme: AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: const Color(0xFF282838),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          color: const Color(0xFF282838),
          shadowColor: Colors.black.withOpacity(0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          surfaceTintColor: const Color(0xFF282838),
        ),
        textTheme:
            GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
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
            backgroundColor: primaryViolet,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF282838),
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
            borderSide: BorderSide(color: primaryViolet, width: 2),
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
