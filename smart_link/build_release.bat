@echo off
echo ===================================
echo Alris App Release Build Script
echo ===================================
echo.

echo Step 1: Clean project...
call flutter clean

echo Step 2: Getting dependencies...
call flutter pub get

echo Step 3: Checking for launcher icon setup...
if exist "assets\images\app_icon.png" (
  echo App icon found! Generating launcher icons...
  call flutter pub run flutter_launcher_icons
) else (
  echo WARNING: app_icon.png not found in assets\images folder.
  echo Please create the app icon before running this script.
  echo Continuing without regenerating icons...
)

echo Step 4: Building release APK...
call flutter build apk --release

echo.
echo ===================================
echo Build complete!
echo.
echo Your APK is located at:
echo build\app\outputs\flutter-apk\app-release.apk
echo.
echo Copy this file to your device to install Alris.
echo ===================================

pause 