// required package imports
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

// Conditional import for platform-specific dependencies
import 'platform_db_helper.dart';

import '../dao/scan_dao.dart';
import '../models/scan_history.dart';

// This is needed to reference the generated code
part 'app_database.g.dart';

// Type converter for DateTime
class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}

@Database(version: 1, entities: [ScanHistory])
@TypeConverters([DateTimeConverter])
abstract class AppDatabase extends FloorDatabase {
  ScanDao get scanDao;

  // Singleton instance
  static AppDatabase? _instance;

  static Future<AppDatabase> getInstance() async {
    if (_instance == null) {
      // Initialize platform-specific database configuration
      await initializePlatformDb();
      
      _instance = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    }
    return _instance!;
  }
} 