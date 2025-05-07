/*
ICON GENERATION INSTRUCTIONS
============================

To properly set up the app icons, follow these steps:

1. Create PNG versions of your logo:
   - Use an online SVG to PNG converter (like https://svgtopng.com/)
   - Convert your SVG logo (assets/images/logo.svg) to PNG
   - Create two versions:
     a) Full icon (1024x1024px) - save as assets/images/app_icon.png
     b) Foreground only (with transparent background, 1024x1024px) - save as assets/images/app_icon_foreground.png

2. Run the icon generator:
   - In your terminal, navigate to the project root
   - Run: flutter pub get (to make sure you have the dependencies)
   - Run: flutter pub run flutter_launcher_icons

3. Verify the icons:
   - Check the Android icons in android/app/src/main/res/
   - Check iOS icons in ios/Runner/Assets.xcassets/

4. Rebuild the app:
   - Run: flutter clean
   - Run: flutter build apk (for Android)
   - The new APK will have your custom icon

Note: If you're experiencing issues, make sure your PNG files:
- Have transparent backgrounds
- Are exactly 1024x1024 pixels
- Don't have any special characters in filenames
*/

// This file doesn't contain actual code, just instructions
// It's safe to leave in the project for future reference 