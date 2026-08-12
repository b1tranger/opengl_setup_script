@echo off
:: Self-elevating Administrator script for OpenGL (GLFW + GLAD + MinGW/MSYS2) setup
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

setlocal EnableDelayedExpansion
cd /d "%~dp0"
for %%I in ("%~dp0.") do set "PROJECT_ROOT=%%~fI"

echo ============================================================
echo   Automated Modern OpenGL (GLFW + GLAD + MSYS2) Setup
echo   Supports: Windows 10/11 64-Bit Environments
echo ============================================================
echo.

set "MSYS2_DIR=C:\msys64"
set "INSTALLER_EXE=%PROJECT_ROOT%\Graphics_Lab_Install_AG\msys2-x86_64-20260611.exe"
set "LAB0_DIR=%PROJECT_ROOT%\sample_projects\Lab0_Basic_Window"
set "LOCAL_PKG_DIR=%PROJECT_ROOT%\Dependencies\msys2_packages"
set "LOCAL_VSIX=%PROJECT_ROOT%\Dependencies\vscode_extensions\ms-vscode.makefile-tools.vsix"

:: 1. Check MSYS2 Installation
echo [1/5] Checking MSYS2 package manager installation...
if exist "%MSYS2_DIR%\usr\bin\bash.exe" goto MSYS_OK

echo [NOT FOUND] MSYS2 is not installed at "%MSYS2_DIR%".
if not exist "%INSTALLER_EXE%" goto INSTALLER_MISSING

echo Launching MSYS2 installer: msys2-x86_64-20260611.exe...
echo Please complete the setup wizard using default path C:\msys64
start /wait "" "%INSTALLER_EXE%"
goto CHECK_MSYS_AGAIN

:INSTALLER_MISSING
echo [ERROR] MSYS2 installer executable not found at: "%INSTALLER_EXE%"
echo Please download MSYS2 manually from https://www.msys2.org/ and install to C:\msys64.
pause
exit /b 1

:CHECK_MSYS_AGAIN
if exist "%MSYS2_DIR%\usr\bin\bash.exe" goto MSYS_OK

echo [ERROR] MSYS2 installation path "%MSYS2_DIR%\usr\bin\bash.exe" not found after installer completed.
pause
exit /b 1

:MSYS_OK
echo [FOUND] MSYS2 detected at: "%MSYS2_DIR%"

:: Remove stale pacman lock file if present from a previous interrupted run
if exist "%MSYS2_DIR%\var\lib\pacman\db.lck" (
    echo [CLEANUP] Removing stale pacman lock file /var/lib/pacman/db.lck ...
    del /F /Q "%MSYS2_DIR%\var\lib\pacman\db.lck" >nul 2>&1
)

:: 2. Localize MSYS2 Package Installation (Offline-First)
echo.
echo [2/5] Installing C++ compiler (gcc/g++) and build tools (make)...

if not exist "%MSYS2_DIR%\var\cache\pacman\pkg" mkdir "%MSYS2_DIR%\var\cache\pacman\pkg"

if exist "%LOCAL_PKG_DIR%\*.pkg.tar.zst" (
    echo [LOCAL DETECTED] Found offline package archives in Dependencies\msys2_packages.
    echo Populating MSYS2 local pacman cache...
    del /F /Q "%MSYS2_DIR%\var\cache\pacman\pkg\*.pkg.tar.zst" >nul 2>&1
    xcopy /Y /Q "%LOCAL_PKG_DIR%\*.pkg.tar.zst" "%MSYS2_DIR%\var\cache\pacman\pkg\" >nul 2>&1
) else (
    echo [NETWORK FALLBACK] Local package archives not found. Will download via network...
)

echo Installing packages via MSYS2 pacman...
"%MSYS2_DIR%\usr\bin\bash.exe" -lc "export MSYSTEM=MSYS MSYS=winsymlinks:nativestrict && pacman -U --needed --noconfirm /var/cache/pacman/pkg/*.pkg.tar.zst"

:: 3. Configure System Environment Variables (PATH)
echo.
echo [3/5] Registering MSYS2 binaries in System Environment PATH...
powershell -Command ^
    "$sysPath = [System.Environment]::GetEnvironmentVariable('Path', 'Machine'); " ^
    "$usrBin = 'C:\msys64\usr\bin'; $mingwBin = 'C:\msys64\mingw64\bin'; " ^
    "$newPath = $sysPath; " ^
    "if (-not ($sysPath -split ';' -contains $usrBin)) { $newPath = $usrBin + ';' + $newPath }; " ^
    "if (-not ($sysPath -split ';' -contains $mingwBin)) { $newPath = $mingwBin + ';' + $newPath }; " ^
    "if ($newPath -ne $sysPath) { [System.Environment]::SetEnvironmentVariable('Path', $newPath, 'Machine'); Write-Host '[SUCCESS] System PATH updated.' } else { Write-Host '[OK] MSYS2 paths already present in System PATH.' }"

:: Refresh local script environment PATH for current session
set "PATH=%MSYS2_DIR%\usr\bin;%MSYS2_DIR%\mingw64\bin;%PATH%"

:: 4. Verify g++ and make executables
echo.
echo [4/5] Verifying compiler and build tool availability...
where g++ >nul 2>&1
if %errorLevel% equ 0 (
    echo   - Compiler g++.exe is accessible in PATH.
) else (
    echo   [!] Warning: g++.exe not immediately visible in session PATH. Restart terminal after setup.
)

where make >nul 2>&1
if %errorLevel% equ 0 (
    echo   - Build tool make.exe is accessible in PATH.
) else (
    echo   [!] Warning: make.exe not immediately visible in session PATH. Restart terminal after setup.
)

:: 5. VS Code Makefile Tools Extension Localization
echo.
echo [5/5] Checking VS Code editor integration...
set "VSC_CMD="
where code >nul 2>&1 && set "VSC_CMD=code"
if not defined VSC_CMD if exist "%LocalAppData%\Programs\Microsoft VS Code\bin\code.cmd" set "VSC_CMD=%LocalAppData%\Programs\Microsoft VS Code\bin\code.cmd"
if not defined VSC_CMD if exist "C:\Program Files\Microsoft VS Code\bin\code.cmd" set "VSC_CMD=C:\Program Files\Microsoft VS Code\bin\code.cmd"
if not defined VSC_CMD if exist "%ProgramFiles(x86)%\Microsoft VS Code\bin\code.cmd" set "VSC_CMD=%ProgramFiles(x86)%\Microsoft VS Code\bin\code.cmd"

if defined VSC_CMD (
    echo [FOUND] VS Code editor detected on this computer.
    set /p INSTALL_VSC="Would you like to install the VS Code Makefile Tools extension (ms-vscode.makefile-tools)? [Y/N]: "
    if /i "!INSTALL_VSC!"=="Y" (
        if exist "%LOCAL_VSIX%" (
            echo Installing localized Makefile Tools extension from Dependencies...
            call "!VSC_CMD!" --install-extension "%LOCAL_VSIX%" --force
        ) else (
            echo [NETWORK FALLBACK] Local .vsix file not found. Installing from extension marketplace...
            call "!VSC_CMD!" --install-extension ms-vscode.makefile-tools
        )
    )
) else (
    echo [INFO] VS Code is not installed on this system. Skipping extension setup.
)

echo.
echo ============================================================
echo   SUCCESS! OpenGL C++ Build Environment configured!
echo ============================================================
echo.

set /p BUILD_TEST="Would you like to build and run the reference Lab0 (Lab0_Basic_Window) now? [Y/N]: "
if /i "%BUILD_TEST%"=="Y" goto DO_TEST_BUILD
goto FINISH

:DO_TEST_BUILD
echo.
if not exist "%LAB0_DIR%" (
    echo [ERROR] Sample project directory not found at "%LAB0_DIR%"
    goto FINISH
)
echo Navigating to "%LAB0_DIR%" and executing 'make win'...
cd /d "%LAB0_DIR%"
if exist "%MSYS2_DIR%\usr\bin\make.exe" (
    "%MSYS2_DIR%\usr\bin\make.exe" win
) else (
    make win
)

:FINISH
echo.
pause
exit /b 0
