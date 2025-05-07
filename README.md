# Alris - URL Analyzer & History Tracker

<div align="center">
  <img src="assets/images/app_icon.svg" width="180" alt="Alris Logo">
  <h3>Smart URL Analysis</h3>
</div>

## Overview

Alris is a sleek, privacy-focused URL analyzer that lets users check links and maintain a local history of scanned URLs. The app features a modern UI with glowing cyan accents, smooth animations, dark mode support, and intuitive navigation.

## Features

- **URL Analysis**: Enter any URL to get a smart analysis result
- **Local Storage**: All data is stored locally on your device - no cloud or remote servers
- **History Tracking**: Keep track of all analyzed URLs with timestamps
- **Privacy First**: No data leaves your device
- **Dark Mode Support**: Automatically adapts to your system preferences with a beautiful dark theme
- **Modern UI**: Smooth animations and eye-catching cyan accents
- **Responsive Design**: Works well on all screen sizes

## Screenshots

| Home Screen | Results Screen | History Screen |
|-------------|---------------|----------------|
| [Home]      | [Results]     | [History]      |

## AI Integration

Alris is designed with a modular architecture to support AI-based URL analysis:

- **Placeholder Module**: The app includes a placeholder for AI functionality in `lib/ai_models/`
- **Planned Features**:
  - URL safety analysis (phishing detection, malware checking)
  - Content categorization
  - Threat scoring and risk assessment
  - Intelligent result explanation

AI teams can implement this functionality following the interface defined in `ai_analyzer.dart`.
For collaboration details, see [CONTRIBUTING.md](CONTRIBUTING.md).

## Running the App

### Step-by-Step Instructions

#### Quick Start

Run the included script:
```
run_with_new_logo.bat
```

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

#### Option 2: Run on Android Emulator

1. **Start the emulator** from Android Studio or command line

2. **Run on emulator**:
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

## Technical Details

### Design Elements

- **Eye Logo**: The glowing cyan eye with digital connections represents the app's security focus
- **Color Scheme**: Primarily uses cyan (#00E5FF) with dark backgrounds for contrast
- **Animations**: Subtle pulse and scale animations bring the UI to life
- **Typography**: Clean, readable Inter font from Google Fonts

### Architecture

- **Built with**: Flutter (Dart)
- **State Management**: Simple StatefulWidget pattern
- **Local Storage**: SharedPreferences
- **Design Pattern**: Screen-based navigation with shared theme
- **AI Module**: Interface-based design for easy integration

## Customizing the Logo

The eye logo is available in SVG format and can be customized:

1. Edit the SVG files in `assets/images/logo.svg` and `assets/images/app_icon.svg`
2. Generate new app icons with:
   ```
   flutter pub run flutter_launcher_icons
   ```

Alternatively, use the included `generate_app_icons.bat` script if you have ImageMagick installed.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

- Eye logo: Custom designed for Alris
- Font: Google Fonts (Inter)
