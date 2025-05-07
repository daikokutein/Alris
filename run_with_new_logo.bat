@echo off
echo ===================================================
echo    Alris - Running App with New Eye Logo
echo ===================================================
echo.

:: Generate app icons first
echo Generating app icons...
call generate_app_icons.bat

echo.
echo ===================================================
echo Starting the app...
echo ===================================================
echo.

:: Run the Flutter app
call flutter run

echo.
echo ===================================================
echo App closed. Thank you for using Alris!
echo =================================================== 