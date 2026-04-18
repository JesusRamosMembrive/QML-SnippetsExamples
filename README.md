🇪🇸 [Versión en español](README.es.md)

# Qt Quick / QML Examples Collection

> **66 copy-paste-ready QML examples** — from buttons and sliders to full avionics displays, industrial HMIs, shaders, and C++ integration.

[![Qt](https://img.shields.io/badge/Qt-6.4%2B-41CD52?logo=qt&logoColor=white)](https://www.qt.io/)
[![CMake](https://img.shields.io/badge/CMake-3.16%2B-064F8C?logo=cmake&logoColor=white)](https://cmake.org/)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Windows-lightgrey)](#-quick-start)
[![Build](https://github.com/JesusRamosMembrive/QML-SnippetsExamples/actions/workflows/build.yml/badge.svg)](https://github.com/JesusRamosMembrive/QML-SnippetsExamples/actions/workflows/build.yml)

<p align="center">
  <img src="gifs/HUD.gif" alt="Head-Up Display" width="720"/>
</p>

---

## Table of Contents

- [Featured Components](#-featured-components)
- [Component Catalog](#-component-catalog)
- [Quick Start](#-quick-start)
- [Requirements](#-requirements)
- [Project Structure](#-project-structure)
- [Documentation](#-documentation)
- [Contributing](#-contributing)
- [License](#-license)
- [About the Author](#-about-the-author)

---

## ✈️ Featured Components

The highlight of this collection — components you won't find in a basic Qt tutorial.

<table>
  <tr>
    <td align="center"><img src="gifs/HUD.gif" width="360"/><br><b>Head-Up Display (HUD)</b></td>
    <td align="center"><img src="gifs/PrimaryFlightDisplay.gif" width="360"/><br><b>Primary Flight Display (PFD)</b></td>
  </tr>
  <tr>
    <td align="center"><img src="gifs/NavigationDisplay.gif" width="360"/><br><b>Navigation Display (ND)</b></td>
    <td align="center"><img src="gifs/ECAM.gif" width="360"/><br><b>ECAM System Display</b></td>
  </tr>
  <tr>
    <td align="center"><img src="gifs/FrostGlass.gif" width="360"/><br><b>Frosted Glass Effect</b></td>
    <td align="center"><img src="gifs/LensMagnification.gif" width="360"/><br><b>Lens Magnification</b></td>
  </tr>
  <tr>
    <td align="center"><img src="gifs/shaderandeffects.gif" width="360"/><br><b>Custom GLSL Shaders</b></td>
    <td align="center"><img src="gifs/Multiplane.gif" width="360"/><br><b>Multiplane Parallax</b></td>
  </tr>
</table>

👉 **[View the full gallery (66 components) →](docs/GALLERY.md)**

---

## 🧩 Component Catalog

### Controls & Inputs
`Buttons` · `Sliders` · `RangeSlider` · `ComboBox` · `Switch` · `TextInput` · `Date` · `MenuBar` · `TabBar` · `ToolBar`

### Views & Containers
`ListView` · `GridView` · `PathView` · `TreeView` · `TableView` · `SwipeView` · `SplitView` · `ScrollView` · `Flickable` · `Drawer` · `Popup & Dialog` · `Toast` · `Cards`

### Layouts
`Layouts` · `Portal`

### Visual Effects & Rendering
`Animations` · `Frosted Glass` · `Lens Magnification` · `Lens Tabs` · `Multiplane Parallax` · `Particles` · `GLSL Shaders` · `Transforms` · `Visual Effects` · `Diorama` · `Sprite Stack` · `3D Graphics`

### ✈️ Aviation & Industrial HMI
`Head-Up Display (HUD)` · `Primary Flight Display (PFD)` · `Navigation Display` · `ECAM` · `Indicators & Dials` · `Aircraft Map`

### Data, Charts & Canvas
`Canvas` · `3D Charts` · `Graphs` · `Shapes`

### System, Network & Integration
`Database (SQLite)` · `Ethernet` · `File Dialogs` · `Images` · `Multimedia` · `Network` · `PDF Reader` · `Street Maps` · `Settings` · `WebSockets` · `Loader`

### C++ Integration
`Async C++` · `QML–C++ Bridge` · `C++ Theory` · `Threads`

### QML Patterns
`States & Transitions` · `Custom Items` · `Chat UI`

---

## 🚀 Quick Start

```bash
git clone https://github.com/JesusRamosMembrive/QML-SnippetsExamples.git
cd QML-SnippetsExamples

# Configure (point to your Qt installation if needed)
cmake -B build -S . -DCMAKE_PREFIX_PATH="/path/to/Qt/6.x.x/gcc_64"

# Build
cmake --build build

# Run (Linux)
./build/QMLSnippetsExamples

# Run (Windows)
build\Debug\QMLSnippetsExamples.exe
```

### Full clean rebuild (required after CMake structural changes)

```bash
rm -rf build
cmake -B build -S . -DCMAKE_PREFIX_PATH="/path/to/Qt/6.x.x/gcc_64"
cmake --build build
```

> **Windows users:** replace `/path/to/Qt/6.x.x/gcc_64` with your actual Qt path,
> e.g. `C:/Qt/6.11.0/msvc2022_64` or `C:/Qt/6.11.0/mingw_64`.

---

## 🛠️ Requirements

| Dependency | Version |
|---|---|
| Qt | 6.4+ |
| CMake | 3.16+ |
| C++ compiler | C++17 (GCC, Clang, MSVC) |

**Qt modules used:** Quick · QuickControls2 · Graphs · WebSockets · Location · Positioning · Pdf · PdfQuick · Sql · Multimedia · Concurrent · Network · ShaderTools · Quick3D · QuickEffects · Qt5Compat.GraphicalEffects

---

## 📁 Project Structure

```
QML-SnippetsExamples/
├── examples/                  # 66 example pages (one module each)
│   ├── hud/                   #   Head-Up Display
│   ├── pfd/                   #   Primary Flight Display
│   ├── navdisplay/            #   Navigation Display
│   ├── ecam/                  #   ECAM system display
│   ├── buttons/               #   Button examples
│   ├── sliders/               #   Slider examples
│   └── ...                    #   (63 more)
├── imports/
│   ├── assets/                # Icons, images, fonts
│   ├── controls/              # Reusable custom controls (BaseCard, Separator)
│   └── utils/                 # Style singleton (colors, fonts, resize helper)
├── mainui/
│   ├── home/                  # Dashboard shell and page switcher
│   └── mainmenu/              # Sidebar navigation
├── styles/
│   └── qmlsnippetsstyle/      # Qt Quick Controls 2 style overrides
│       └── buttons/           # GlowButton, GradientButton, PulseButton, NeumorphicButton
├── src/
│   └── main.cpp               # Application entry point
├── docs/                      # Documentation and guides
├── gifs/                      # Demo GIFs for the gallery
├── Main.qml                   # Root QML entry point
├── SplashScreen.qml           # Splash screen
├── CMakeLists.txt             # Root build configuration
├── qmlmodules                 # Module registration (included by CMakeLists.txt)
└── qtquickcontrols2.conf      # Qt Quick Controls 2 style config
```

### Navigation Architecture

Each example page has a `fullSize` bool property. `Dashboard.qml` drives visibility by matching a `state` string to menu item text:

```qml
// Dashboard.qml
Hud.Main { fullSize: (root.state === "Hud") }

// Each example's Main.qml
property bool fullSize: false
opacity: fullSize ? 1.0 : 0.0
visible: opacity > 0.0
Behavior on opacity { NumberAnimation { duration: 200 } }
```

### Style Singleton

`imports/utils/Style.qml` is a `pragma Singleton`. Use `Style.resize(value)` for all dimensions and `Style.mainColor`, `Style.bgColor` etc. for colors — never hardcode either.

---

## 📚 Documentation

| Document | Description |
|---|---|
| [Full Gallery](docs/GALLERY.md) | All 66 component GIFs organized by category |
| [Creating a New Page](docs/CREATING_NEW_PAGE.md) | Step-by-step guide to adding a new example page |
| [Crear una Nueva Página (ES)](docs/CREAR_NUEVA_PAGINA.md) | Versión en español de la guía anterior |

### Common Error: "module plugin not found"

If you see `module "buttons" plugin "buttonspluginplugin" not found`, you need a full clean rebuild:

```bash
rm -rf build && cmake -B build -S . && cmake --build build
```

See [Creating a New Page](docs/CREATING_NEW_PAGE.md#️-critical-error-module-plugin-not-found) for the full explanation.

---

## 🤝 Contributing

Contributions are welcome! To add a new example page:

1. Fork the repo and create a feature branch
2. Follow the guide in [docs/CREATING_NEW_PAGE.md](docs/CREATING_NEW_PAGE.md)
3. Make sure the project builds cleanly: `cmake -B build -S . && cmake --build build`
4. Add a demo GIF to `gifs/` and update [docs/GALLERY.md](docs/GALLERY.md)
5. Open a pull request

Please read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting.

---

## 📄 License

This project is licensed under the **GNU General Public License v3.0** — see [LICENSE](LICENSE) for details.

> **Note:** The author is considering relicensing to MIT for broader adoption.
> If that matters to you, leave a comment on the issue tracker.

---

## 👤 About the Author

Built and maintained by **Jesús Ramos Membrive** — C++/Qt developer specializing in
industrial HMIs, embedded systems, and avionics displays. Based in Madrid, Spain.

🔗 LinkedIn: [linkedin.com/in/jesus-ramos-membrive-91a896101](https://www.linkedin.com/in/jesus-ramos-membrive-91a896101)

💼 Available for Qt/QML consulting and HMI development projects.
