# Modern OpenGL (GLFW + GLAD + MinGW/MSYS2) Setup & Technical Guide

## 1. Overview
This technical guide documents the complete automated setup and manual configuration of Modern OpenGL (v3.3 Core Profile using GLFW and GLAD) on Windows 10/11 using MSYS2 and MinGW-w64. It addresses PATH registration, pacman package installation, `#include <KHR/khrplatform.h>` header issues, dynamic DLL loading, and Makefile automation.

---

## 2. Technical Causes of Setup Errors & Solutions

### 1. Missing Compiler Toolchain (`'g++' or 'make' not recognized`)
* **Problem**: Windows command prompt does not natively recognize `g++` or `make`.
* **Root Cause**: Fresh Windows installations lack a GNU C++ compiler suite and build utility.
* **Fix**: Installed MSYS2 and executed `pacman -Sy --noconfirm base-devel gcc`, placing `make.exe` in `C:\msys64\usr\bin` and `g++.exe` in `C:\msys64\mingw64\bin`.

### 2. Missing System PATH Environment Variable
* **Problem**: Terminal shows command not found errors even after installing MSYS2.
* **Root Cause**: `C:\msys64\usr\bin` and `C:\msys64\mingw64\bin` are not in System `PATH`.
* **Fix**: `install_opengl_admin.bat` uses PowerShell environment registry modification to permanently register both directories without truncating long PATH variables.

### 3. GLAD Header Include Error (`fatal error: KHR/khrplatform.h: No such file or directory`)
* **Problem**: Building GLAD throws a missing header error for `KHR/khrplatform.h`.
* **Root Cause**: The auto-generated `glad.h` specifies `#include <KHR/khrplatform.h>`, expecting a `KHR` subfolder in the include path.
* **Fix**: Placed `khrplatform.h` in `include/` and updated `glad.h` to use relative `#include "khrplatform.h"`.

### 4. Dynamic DLL Search Failure (`glfw3.dll not found`)
* **Problem**: Executable fails to launch with a missing DLL dialog.
* **Root Cause**: Windows dynamic linker (`LoadLibrary`) searches current working directory (`./build/`) and system paths for `glfw3.dll`.
* **Fix**: Automatically deploy `glfw3.dll` into `./build/` alongside `main.exe`.

### 5. GLFW Window Creation Failure (`OpenGL 3.3 unsupported`)
* **Problem**: Console output: `Failed to create GLFW window`.
* **Root Cause**: The system display driver lacks OpenGL 3.3 Core Profile support.
* **Fix**: Diagnostic check with **GLView** (RealTech VR) to verify GPU driver capabilities.

---

## 3. Automated 1-Click Setup (`install_opengl_admin.bat`)

To automatically install MSYS2, package dependencies, and update PATH environment variables:

1. Right-click **`install_opengl_admin.bat`** and select **Run as administrator**.
2. Click **Yes** on the Windows UAC elevation prompt.
3. The script will:
   - Check for MSYS2 at `C:\msys64` (installs `msys2-x86_64-20260611.exe` if missing).
   - Execute `pacman -Sy --noconfirm base-devel gcc` to install `g++` and `make`.
   - Update System `PATH` with `C:\msys64\usr\bin` and `C:\msys64\mingw64\bin`.
   - Option to automatically build and run reference `Graphics_Lab_Install_AG/Lab0` (`make win`).

### Uninstallation & Cleanup (`uninstall_opengl_admin.bat`):
To clean up compiled binaries, uninstall packages, or completely remove MSYS2:
1. Right-click **`uninstall_opengl_admin.bat`** and select **Run as administrator**.
2. Select your desired option:
   - **`[1]`** Remove MSYS2 paths from System `PATH`
   - **`[2]`** Delete output binaries (`main.exe`) across sample projects
   - **`[3]`** Uninstall pacman packages (`base-devel`, `gcc`) and clear cache
   - **`[4]`** **Full Uninstallation** (Completely remove `C:\msys64` folder, clean System `PATH`, and delete output binaries)

---

## 4. How to Build & Run OpenGL Projects

### Using Makefile (Recommended)
Open **Command Prompt (CMD)**, **PowerShell**, or **VS Code Terminal**, navigate to any lab folder (e.g. `sample_projects/Lab0_Basic_Window` or `sample_projects/Lab1_Color_Triangle`), and execute:

```bash
# Windows Command Prompt (CMD) or PowerShell
make win

# Linux Terminal
make linux
```

### Manual Command Line Compilation
```cmd
g++.exe -fdiagnostics-color=always -I./include ./src/main.cpp ./src/glad.c -o ./build/main.exe -Llib -lglfw3 -lopengl32 -lgdi32
./build/main.exe
```

---

## 5. Sample Projects Included

1. **`Lab0_Basic_Window`**: Basic GLFW window creation, viewport callback, GLAD initialization, and buffer clearing.
2. **`Lab1_Color_Triangle`**: OpenGL 3.3 Core Profile programmable shader pipeline, VBO/VAO setup, shader compilation, and uniform color manipulation.
3. **`Lab2_Interactive_Input`**: Keyboard input callbacks (`ESC` to exit, `R`/`G`/`B` to tweak background RGB, `SPACE` to reset).
