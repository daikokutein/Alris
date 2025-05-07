@echo off
echo ===================================================
echo         Alris - Build Release Packages
echo ===================================================
echo.
echo This script will build release versions of the app:
echo  1. APK (Android Package)
echo  2. AAB (Android App Bundle)
echo.
echo Make sure you have updated the app version in pubspec.yaml
echo.
echo ===================================================
echo.

:: Check if Flutter is installed
where flutter >nul 2>nul
if %ERRORLEVEL% neq 0 (
  echo Error: Flutter is not installed or not in your PATH.
  echo Please install Flutter or add it to your PATH and try again.
  exit /b 1
)

:: Generate app icons first
echo Generating app icons...
call generate_app_icons.bat

:: Clean the project
echo.
echo Cleaning project...
call flutter clean

:: Get dependencies
echo.
echo Getting dependencies...
call flutter pub get

:: Build APK
echo.
echo Building APK...
call flutter build apk --release

if %ERRORLEVEL% neq 0 (
  echo Error: APK build failed.
  exit /b 1
)

:: Build App Bundle (AAB)
echo.
echo Building Android App Bundle (AAB)...
call flutter build appbundle --release

if %ERRORLEVEL% neq 0 (
  echo Error: AAB build failed.
  exit /b 1
)

echo.
echo ===================================================
echo Build completed successfully!
echo.
echo APK location:
echo   build\app\outputs\flutter-apk\app-release.apk
echo.
echo AAB location:
echo   build\app\outputs\bundle\release\app-release.aab
echo.
echo Install APK directly to connected device:
echo   flutter install
echo ===================================================
echo.

pause 