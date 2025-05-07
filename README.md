# Alris - URL Analyzer & History Tracker

<img src="assets/images/logo.svg" width="100" alt="Alris Logo">

## Overview

Alris is a sleek, privacy-focused URL analyzer that lets users check links and maintain a local history of scanned URLs. The app features a modern UI with animations, dark mode support, and intuitive navigation.

## Features

- **URL Analysis**: Enter any URL to get a dummy analysis result
- **Local Storage**: All data is stored locally on your device - no cloud or remote servers
- **History Tracking**: Keep track of all analyzed URLs with timestamps
- **Privacy First**: No data leaves your device
- **Dark Mode Support**: Automatically adapts to your system preferences
- **Modern UI**: Beautiful animations and transitions
- **Responsive Design**: Works well on all screen sizes

## AI Module for URL Analysis

The application includes a placeholder for AI-based URL analysis that can be implemented by dedicated AI teams:

- **AI Module Location**: `lib/ai_models/`
- **Documentation**: See [`lib/ai_models/README.md`](lib/ai_models/README.md) for detailed instructions and requirements

The AI module provides:
- Interface definitions for URL analysis
- Data structures for analysis results
- Dummy implementation for testing
- Comprehensive test suite for validation

AI teams can implement various detection capabilities:
- Phishing detection
- Malware identification
- URL safety analysis
- Content categorization

For collaboration details, refer to the [AI models README](lib/ai_models/README.md).

## Running the App

### Step-by-Step Instructions

#### Option 1: Run in Chrome (Web)

1. **Navigate to project folder**:
   ```
   cd path/to/alris
   ```

2. **Get dependencies**:
   ```
   flutter pub get
   ```

3. **Run in Chrome**:
   ```
   flutter run -d chrome
   ```

4. **Wait for build** - Chrome will open automatically when ready

#### Option 2: Run on Android Emulator

1. **Start the emulator** from Android Studio or command line

2. **Check available devices**:
   ```
   flutter devices
   ```

3. **Run on emulator**:
   ```
   flutter run
   ```

#### Option 3: Run on Physical Device

1. **Connect device via USB** and enable USB debugging

2. **Check device connection**:
   ```
   flutter devices
   ```

3. **Run on device**:
   ```
   flutter run
   ```

### Building an APK

1. **Create release APK**:
   ```
   flutter build apk --release
   ```

2. **Find the APK** at:
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

3. **Install on device** by transferring and opening the APK

## Technical Details

### Storage

Alris uses SharedPreferences to store URL history directly on your device. This means:
- No internet connection required
- Complete privacy - no data is sent to any servers
- Data persists between app sessions
- Uninstalling the app will remove all stored data

### Architecture

- **Built with**: Flutter (Dart)
- **State Management**: Simple StatefulWidget pattern
- **Local Storage**: SharedPreferences
- **Design Pattern**: Screen-based navigation

### Screens

1. **Home Screen**: URL input with form validation
2. **Result Screen**: Displays analysis results (demo data)
3. **History Screen**: Chronological list of all analyzed URLs

## Getting Started

### Prerequisites

- Android 5.0 (API level 21) or higher
- iOS 11.0 or higher (if built for iOS)

### Installation

1. Download the APK from the releases section
2. Enable "Install from Unknown Sources" in your device settings
3. Open the APK file to install

### Building from Source

1. Ensure Flutter is installed on your machine
2. Clone the repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter build apk` for Android or `flutter build ios` for iOS
5. Find the built APK at `build/app/outputs/flutter-apk/app-release.apk`

### Changing the App Icon

To use the custom eye logo as the app icon (instead of the default Flutter icon):

1. Create PNG versions of the logo:
   - Convert the SVG logo (in assets/images/logo.svg) to PNG format
   - Create a full icon (1024x1024px) and save as `assets/images/app_icon.png`
   - Create a foreground-only version with transparent background and save as `assets/images/app_icon_foreground.png`

2. Run the icon generator:
   ```
   flutter pub run flutter_launcher_icons
   ```

3. Build a new APK:
   ```
   flutter build apk --release
   ```

Alternatively, run the included `build_release.bat` script which will handle the entire process.

## Privacy Policy

Alris does not:
- Collect any personal information
- Send any data to external servers
- Track user behavior
- Require any permissions beyond the minimum needed to function

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

- Icons and graphics: Custom designed for Alris
- Font: Google Fonts (Poppins)
- Animations: Flutter Animate package
