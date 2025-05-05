# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.embedding.** { *; }

# SQLite optimization
-keep class org.sqlite.** { *; }
-keep class org.sqlite.database.** { *; }

# Floor database
-keep class com.example.scan_history_app.data.** { *; }
-keep class ** extends androidx.room.RoomDatabase
-keep class androidx.room.** { *; }
-keep @androidx.room.* class *

# Platform DB Helper
-keep class com.example.scan_history_app.ScanHistoryApp { *; }

# Model classes
-keep class com.example.scan_history_app.data.models.** { *; }
-keepclassmembers class com.example.scan_history_app.data.models.** {
    <fields>;
}

# Disable debug logs in release build
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
} 