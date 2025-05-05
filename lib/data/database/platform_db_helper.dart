import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Initialize platform-specific database configurations
Future<void> initializePlatformDb() async {
  if (kIsWeb) {
    // Web platform - no special configuration needed
    // Note: Floor has limited support on web, as SQLite is not natively supported
    print('Running on Web platform - SQLite functionality may be limited');
    return;
  }
  
  // Desktop platforms (Windows, Linux) need FFI
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    print('Initialized FFI for desktop platform');
  }
  
  // Android and iOS work with the standard implementation
  if (Platform.isAndroid) {
    // Android-specific optimizations
    final packageName = await _getPackageName();
    await databaseFactory.setDatabasesPath('/data/data/$packageName/databases');
    
    // Enable WAL mode for better performance on Android
    // WAL mode allows simultaneous reads and writes
    databaseFactory.openDatabase('dummy.db').then((db) async {
      await db.execute('PRAGMA journal_mode = WAL');
      await db.close();
    }).catchError((_) {
      // Ignore errors during optimization setup
    });
    
    print('Optimized SQLite for Android platform');
  } else if (Platform.isIOS) {
    print('Running on iOS platform - using standard SQLite implementation');
  }
}

// Helper to get package name for Android database path
Future<String> _getPackageName() async {
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  } catch (e) {
    return 'com.example.scan_history_app';
  }
} 