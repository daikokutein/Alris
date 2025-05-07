@echo off
echo ===================================================
echo           Alris App Icon Generator
echo ===================================================
echo.
echo This script will generate app icons for all platforms
echo using the Flutter Launcher Icons package.
echo.
echo Make sure your pubspec.yaml has the flutter_launcher_icons
echo configuration section correctly set up.
echo.
echo Icons will be generated from assets/images/app_icon.svg
echo.
echo ===================================================

:: Check if Flutter is installed
where flutter >nul 2>nul
if %ERRORLEVEL% neq 0 (
  echo Error: Flutter is not installed or not in your PATH.
  echo Please install Flutter or add it to your PATH and try again.
  exit /b 1
)

:: Make sure we're in the project directory
if not exist pubspec.yaml (
  echo Error: pubspec.yaml not found.
  echo Please run this script from the project root directory.
  exit /b 1
)

echo Checking for flutter_launcher_icons in pubspec.yaml...
findstr "flutter_launcher_icons" pubspec.yaml >nul
if %ERRORLEVEL% neq 0 (
  echo Error: flutter_launcher_icons not found in pubspec.yaml.
  echo Please add the configuration to your pubspec.yaml file.
  exit /b 1
)

echo Running Flutter pub get...
call flutter pub get

if %ERRORLEVEL% neq 0 (
  echo Error: Flutter pub get failed. Please check your dependencies.
  exit /b 1
)

echo Generating app icons...
call flutter pub run flutter_launcher_icons

if %ERRORLEVEL% neq 0 (
  echo Error: Icon generation failed. Please check your configuration.
  exit /b 1
)

echo.
echo ===================================================
echo Icon generation completed successfully!
echo App icons have been updated for all configured platforms.
echo ===================================================
echo.

pause 