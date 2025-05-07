@echo off
echo Setting up Alris with the new eye logo...

rem Get dependencies
echo Getting Flutter dependencies...
flutter pub get

rem Generate icons from the SVG
echo Generating app icons...
flutter pub run flutter_launcher_icons

rem Clean and build
echo Cleaning and rebuilding the app...
flutter clean
flutter pub get

rem Run the app in Chrome
echo Starting Alris in Chrome...
flutter run -d chrome

echo Done! 