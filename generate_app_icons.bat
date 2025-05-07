@echo off
echo Generating App Icons for Alris...

rem Check if convert command (from ImageMagick) is available
where convert >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: ImageMagick is not installed or not in PATH.
    echo Please install ImageMagick from https://imagemagick.org/script/download.php
    exit /b 1
)

rem Create necessary directories
if not exist "android\app\src\main\res\mipmap-hdpi" mkdir "android\app\src\main\res\mipmap-hdpi"
if not exist "android\app\src\main\res\mipmap-mdpi" mkdir "android\app\src\main\res\mipmap-mdpi"
if not exist "android\app\src\main\res\mipmap-xhdpi" mkdir "android\app\src\main\res\mipmap-xhdpi"
if not exist "android\app\src\main\res\mipmap-xxhdpi" mkdir "android\app\src\main\res\mipmap-xxhdpi"
if not exist "android\app\src\main\res\mipmap-xxxhdpi" mkdir "android\app\src\main\res\mipmap-xxxhdpi"
if not exist "ios\Runner\Assets.xcassets\AppIcon.appiconset" mkdir "ios\Runner\Assets.xcassets\AppIcon.appiconset"

rem First convert SVG to PNG with high resolution
echo Converting SVG to PNG...
convert -background none -size 1024x1024 assets\images\app_icon.svg assets\images\app_icon.png

rem Generate Android icons
echo Generating Android icons...
convert assets\images\app_icon.png -resize 72x72 android\app\src\main\res\mipmap-hdpi\ic_launcher.png
convert assets\images\app_icon.png -resize 48x48 android\app\src\main\res\mipmap-mdpi\ic_launcher.png
convert assets\images\app_icon.png -resize 96x96 android\app\src\main\res\mipmap-xhdpi\ic_launcher.png
convert assets\images\app_icon.png -resize 144x144 android\app\src\main\res\mipmap-xxhdpi\ic_launcher.png
convert assets\images\app_icon.png -resize 192x192 android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png

rem Generate iOS icons
echo Generating iOS icons...
convert assets\images\app_icon.png -resize 20x20 ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-20x20@1x.png
convert assets\images\app_icon.png -resize 40x40 ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-20x20@2x.png
convert assets\images\app_icon.png -resize 60x60 ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-20x20@3x.png
convert assets\images\app_icon.png -resize 29x29 ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-29x29@1x.png
convert assets\images\app_icon.png -resize 58x58 ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-29x29@2x.png
convert assets\images\app_icon.png -resize 87x87 ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-29x29@3x.png
convert assets\images\app_icon.png -resize 40x40 ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-40x40@1x.png
convert assets\images\app_icon.png -resize 80x80 ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-40x40@2x.png
convert assets\images\app_icon.png -resize 120x120 ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-40x40@3x.png
convert assets\images\app_icon.png -resize 120x120 ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-60x60@2x.png
convert assets\images\app_icon.png -resize 180x180 ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-60x60@3x.png
convert assets\images\app_icon.png -resize 76x76 ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-76x76@1x.png
convert assets\images\app_icon.png -resize 152x152 ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-76x76@2x.png
convert assets\images\app_icon.png -resize 167x167 ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-83.5x83.5@2x.png
convert assets\images\app_icon.png -resize 1024x1024 ios\Runner\Assets.xcassets\AppIcon.appiconset\Icon-App-1024x1024@1x.png

echo App icons generated successfully!
echo Note: For this to work, you need ImageMagick installed and in your PATH.
echo For a Flutter-specific solution, consider using the flutter_launcher_icons package. 