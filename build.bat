@echo off
setlocal EnableDelayedExpansion

echo ===================================================
echo Hey, here is the updated Fast Items mod for 1.21.11!
echo ===================================================
echo.

:: -----------------------------------------------
:: Check if running from inside a zip file
:: -----------------------------------------------
if not exist "%~dp0\gradlew.bat" (
    echo [ERROR] You are running this script directly from inside a zip archive!
    echo Please extract the entire folder first, then run build.bat from the extracted folder.
    echo.
    pause
    exit /b 1
)

:: -----------------------------------------------
:: Check if Java 21 is available on PATH
:: -----------------------------------------------

set NEED_JAVA=1

for /f "tokens=3" %%V in ('java -version 2^>^&1 ^| findstr /i "version"') do (
    set "RAW_VER=%%~V"
    echo Detected Java: !RAW_VER!
    echo !RAW_VER! | findstr /b "21" >nul
    if !ERRORLEVEL! equ 0 set NEED_JAVA=0
)

if !NEED_JAVA! equ 0 (
    echo Java 21 confirmed.
    goto :build
)

:: -----------------------------------------------
:: Java 21 not found - download portable JDK
:: -----------------------------------------------

echo Java 21 not detected. Fetching a portable JDK 21 into .gradle\jdk21...
echo This is a one-time download of ~190 MB.
echo.

set "JDK_DIR=%CD%\.gradle\jdk21"
set "JDK_ZIP=%CD%\.gradle\jdk21.zip"
set "JDK_TMP=%CD%\.gradle\jdk21_extracted"
set "JDK_URL=https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.2%%2B13/OpenJDK21U-jdk_x64_windows_hotspot_21.0.2_13.zip"

if not exist "%CD%\.gradle" mkdir "%CD%\.gradle"

if not exist "!JDK_DIR!" (
    echo Downloading...
    powershell -NoProfile -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri '!JDK_URL!' -OutFile '!JDK_ZIP!'"
    if !ERRORLEVEL! neq 0 (
        echo [ERROR] Download failed. Check your internet connection and try again.
        pause
        exit /b 1
    )

    echo Extracting...
    powershell -NoProfile -Command "Expand-Archive -Path '!JDK_ZIP!' -DestinationPath '!JDK_TMP!' -Force"
    if !ERRORLEVEL! neq 0 (
        echo [ERROR] Extraction failed.
        pause
        exit /b 1
    )

    for /d %%D in ("!JDK_TMP!\*") do move "%%D" "!JDK_DIR!" >nul
    del "!JDK_ZIP!"
    rd /s /q "!JDK_TMP!"
)

set "JAVA_HOME=!JDK_DIR!"
set "PATH=!JDK_DIR!\bin;%PATH%"
echo Portable Java 21 ready.

:: -----------------------------------------------
:: Build
:: -----------------------------------------------

:build
echo.
echo Running Gradle build...
echo.

call gradlew.bat clean build
if !ERRORLEVEL! neq 0 (
    echo.
    echo [ERROR] Build failed. See log output above for details.
    pause
    exit /b !ERRORLEVEL!
)

echo.
echo ===================================================
echo  Build complete.
echo ===================================================
echo.
echo If you didn't have Java 21 installed, this script automatically downloaded a portable version of Java 
echo and the required Minecraft modding tools safely in the background.
echo.
echo Output locations:
echo   Fabric:    fabric\build\libs\
echo   NeoForge:  neoforge\build\libs\
echo.
echo Copy the .jar file(s) from the folders above into your Minecraft mods folder, 
echo launch the game, and enjoy!
echo.
pause