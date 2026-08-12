# Modern OpenGL (GLFW + GLAD + MinGW/MSYS2) 1-Click Setup & Automation

An automated setup package and comprehensive technical guide for configuring **Modern OpenGL (v3.3 Core Profile with GLFW and GLAD)** on Windows environments (Windows 10 / 11 64-Bit). Automates MSYS2 installation, `pacman` toolchain configuration (`base-devel`, `gcc`), environment variable (`PATH`) registration, `#include <KHR/khrplatform.h>` header fixes, and `glfw3.dll` deployment out of the box.

Some files are taken from: https://github.com/AudityGhosh/Computer_Graphics_and_Animations_Modern_OpenGL

---

> [!IMPORTANT]
> 📖 **Full Technical & Troubleshooting Guide Available**  
> For in-depth explanations of root causes, MSYS2 package manager configuration, header include fixes, Makefile automation, and driver diagnostics:  
> 👉 **[Read the complete technical guide in guide.md](guide.md)**

---

## ⚡ Quick Start (Automated Setup)

1. Right-click **`install_opengl_admin.bat`** and select **Run as Administrator** (or double-click to run).
2. Confirm the Windows UAC prompt.
3. The script auto-detects or installs **MSYS2 (`C:\msys64`)**, installs `g++.exe` and `make.exe` via `pacman`, and permanently updates your System `PATH`.
4. Optionally accept the built-in prompt to test build and run **`sample_projects/Lab0_Basic_Window`**.
5. To build any project manually, open **Command Prompt (CMD)** or **PowerShell** in any project folder (e.g. `sample_projects/Lab1_Color_Triangle`) and run:
   ```bash
   make win
   ```

To clean up built binaries or remove PATH entries, right-click **`uninstall_opengl_admin.bat`** and select **Run as Administrator**.

---

## ✨ Features & What's New

- ⚡ **1-Click Automated Setup**: Self-elevating Administrator installer configures MSYS2, GCC compiler, and Make build tools seamlessly.
- 📦 **Latest MSYS2 Toolchain**: Pre-packaged with the latest stable `msys2-x86_64-20260611.exe` installer in `Graphics_Lab_Install_AG`.
- 🛠️ **Automated Environment PATH Registration**: Safely adds `C:\msys64\usr\bin` and `C:\msys64\mingw64\bin` to Windows System Environment Variables without text truncation bugs.
- 🔧 **Header Include Fixes**: Resolves `#include <KHR/khrplatform.h>` GLAD compilation errors out of the box.
- 📁 **Cross-Platform Makefile Support**: Built-in target rules for Windows (`make win`) and Linux (`make linux`).
- 🎨 **Pre-Packaged Reference Labs**: Includes beginner to intermediate OpenGL labs demonstrating window creation, programmable shader triangles, and interactive input.

---

## 📂 Project File Structure

```
opengl_setup_script/
├── README.md                      # Project overview & quick start guide
├── guide.md                       # Comprehensive technical troubleshooting guide & manual setup
├── install_opengl_admin.bat       # Self-elevating Administrator installer (1-Click setup)
├── uninstall_opengl_admin.bat     # Administrator cleanup & uninstallation script
├── Dependencies/                   # Localized offline setup dependencies
│   ├── msys2_packages/            # Pre-downloaded pacman package archives (.pkg.tar.zst)
│   └── vscode_extensions/         # Localized VS Code Makefile Tools extension (.vsix)
├── Graphics_Lab_Install_AG/       # Core install dependencies & setup guide
│   ├── msys2-x86_64-20260611.exe # Updated latest MSYS2 64-bit installer executable
│   └── Setup.pdf                  # Setup instructions & original lab setup reference
├── sample_projects/               # Structured Modern OpenGL sample projects
│   ├── Lab0_Basic_Window/         # Basic GLFW window creation & background clear
│   ├── Lab1_Color_Triangle/       # OpenGL 3.3 Core Profile programmable shader RGB triangle
│   └── Lab2_Interactive_Input/    # Interactive keyboard callbacks & background color controls
└── notes/                         # Technical guides & Computer Graphics lab notes
    ├── setupGuide.md              # Consolidated setup, PATH, Makefile, & batch architecture guide
    ├── colorGuide.md              # OpenGL RGB color palettes & gradient interpolation guide
    └── circleGuide.md             # Circle drawing algorithms (Trig loops, Midpoint, GLSL Shaders)
```

---

👉 For detailed manual setup instructions, technical root causes, and Makefile specifications, see **[guide.md](guide.md)**.
