@echo off
echo ===================================
echo Alris - Running in Chrome
echo ===================================
echo.

echo Step 1: Getting dependencies...
call flutter pub get

echo Step 2: Starting Chrome...
call flutter run -d chrome

pause 