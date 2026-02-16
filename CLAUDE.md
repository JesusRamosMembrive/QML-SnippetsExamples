# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

QML Snippets Examples — a Qt 6 / QML component library and example showcase app. It displays reusable UI component examples (buttons, sliders, etc.) in a dashboard with a sidebar menu. The project is written in Spanish (docs, comments).

## Build Commands

```bash
# Configure and build
cmake -B build -S .
cmake --build build

# Run (Linux)
./build/QMLSnippetsExamples

# Full clean rebuild (required after CMake structural changes)
rm -rf build && cmake -B build -S . && cmake --build build
# Or on Linux: ./rebuild.sh
```

**When clean rebuild is mandatory:** changing library names, URIs, adding/removing `qt_add_library()`, modifying `target_link_libraries()`, moving QML files between directories, modifying `qmldir` files, adding/removing entire QML modules.

## Requirements

- Qt 6.4+ (modules: Quick, QuickControls2)
- CMake 3.16+
- Qt5Compat.GraphicalEffects (used for Glow, DropShadow, InnerShadow effects)

## Architecture

### Module System

The app is split into static QML modules, each with its own `CMakeLists.txt` and `qmldir`. Module registration happens in `/qmlmodules` (included by root CMakeLists.txt).

| Module URI | Library name | Link target (for `target_link_libraries`) |
|---|---|---|
| `utils` | utilsplugin | `utilsplugin` |
| `controls` | controlsplugin | `controlsplugin` |
| `qmlsnippetsstyle` | qmlsnippetsstyle | `qmlsnippetsstyleplugin` |
| `mainui` | mainui | `mainuiplugin` |
| `buttons` | buttonsplugin | `buttonspluginplugin` |
| `sliders` | slidersplugin | `sliderspluginplugin` |

**Critical pattern for example modules:** `qt_add_qml_module` auto-appends `plugin` to the library name, so a library named `buttonsplugin` produces link target `buttonspluginplugin`. Each example module CMakeLists.txt **must** have `qt_add_library(<name> STATIC)` before `qt_add_qml_module()` or you get "module plugin not found" errors.

### Key Directories

- `examples/` — Example pages (buttons, sliders). Each is a self-contained QML module with `Main.qml`, `CMakeLists.txt`, `qmldir`.
- `imports/utils/` — `Style.qml` singleton (colors, fonts, dimensions, asset helpers).
- `imports/controls/` — Reusable custom controls (`BaseCard`, `Separator`).
- `styles/qmlsnippetsstyle/` — Qt Quick Controls 2 style overrides + specialized buttons (`GlowButton`, `GradientButton`, `PulseButton`, `NeumorphicButton`).
- `mainui/` — Dashboard shell: `HomePage.qml` (layout), `Dashboard.qml` (page switcher), `MainMenuList.qml` (sidebar menu).

### Navigation Pattern

`Dashboard.qml` uses a `state` property matching menu item text exactly. Each example page has a `fullSize` bool property that controls visibility with a 200ms opacity animation:

```qml
// In Dashboard.qml
Buttons.Main { fullSize: (root.state === "Buttons") }

// In each example page Main.qml
property bool fullSize: false
opacity: fullSize ? 1.0 : 0.0
visible: opacity > 0.0
Behavior on opacity { NumberAnimation { duration: 200 } }
```

### Style Singleton (`imports/utils/Style.qml`)

`pragma Singleton`. Access via `import utils` then `Style.<property>`. Use `Style.resize(value)` for all hardcoded dimensions. Use `Style.mainColor`, `Style.bgColor` etc. instead of hardcoded colors. Asset helpers: `Style.icon(name)`, `Style.gfx(name)`.

### Custom Controls Style

`qtquickcontrols2.conf` sets the app style to `qmlsnippetsstyle`, which overrides default Qt controls (Button, Slider, Label, etc.).

## Adding a New Example Page

Full guide: `docs/CREAR_NUEVA_PAGINA.md`. Summary:

1. Create `examples/<name>/` with `Main.qml`, `CMakeLists.txt`, `qmldir`
2. Add `qt_add_library(<name>plugin STATIC)` + `qt_add_qml_module(...)` in its CMakeLists.txt
3. Add `add_subdirectory(<name>)` to `examples/CMakeLists.txt`
4. Add link target `<name>pluginplugin` to `target_link_libraries` in `/qmlmodules`
5. Add menu entry in `mainui/mainmenu/MainMenuList.qml` (text must match Dashboard state exactly)
6. Import and wire up in `mainui/home/Dashboard.qml`
7. Add a matching icon PNG in `imports/assets/icons/`
8. Clean rebuild
