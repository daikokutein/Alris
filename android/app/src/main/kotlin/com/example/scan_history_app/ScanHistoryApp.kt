package com.example.scan_history_app

import io.flutter.app.FlutterApplication
import android.database.sqlite.SQLiteDatabase

class ScanHistoryApp : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        
        // Enable SQLite WAL mode at application level for better performance
        SQLiteDatabase.enableWriteAheadLogging()
        
        // Set SQLite memory cache size for better performance
        // This increases the amount of database content cached in memory
        val path = getDatabasePath("app_database.db").absolutePath
        val db = SQLiteDatabase.openOrCreateDatabase(path, null)
        db.execSQL("PRAGMA cache_size = 10000")
        db.close()
    }
} 