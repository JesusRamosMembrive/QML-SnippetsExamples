# How to Add a New Example Page

This guide explains how to add new example pages (e.g., Charts, TextInputs, Maps) to the QML dashboard.

🇪🇸 [Versión en español](CREAR_NUEVA_PAGINA.md)

---

## Project Structure

Each example page lives in its own folder under `/examples/`, as a self-contained QML module:

```
QML-SnippetsExamples/
├── examples/
│   ├── buttons/       ← example: buttons page
│   ├── sliders/       ← example: sliders page
│   └── charts/        ← new page goes here
├── imports/
├── mainui/
├── styles/
└── Main.qml
```

---

## Step-by-Step

### 1. Create the directory structure

```
examples/
└── charts/
    ├── CMakeLists.txt
    ├── qmldir
    └── Main.qml
```

### 2. Create Main.qml

The `fullSize` property controls visibility. The Dashboard sets it to `true` when this page is active.

```qml
import QtQuick
import QtQuick.Controls
import utils

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        Text {
            anchors.centerIn: parent
            text: "Charts Example Page"
            font.pixelSize: Style.resize(24)
            color: Style.mainColor
        }
    }
}
```

### 3. Create qmldir

```
module charts
Main 1.0 Main.qml
```

### 4. Create CMakeLists.txt

The `qt_add_library` line is **mandatory** — without it you'll get "module plugin not found" at runtime.

```cmake
qt_add_library(chartsplugin STATIC)
qt_add_qml_module(chartsplugin
    URI "charts"
    VERSION 1.0
    QML_FILES
        Main.qml
)
```

If your page has sub-components, list them under `QML_FILES`:

```cmake
qt_add_library(chartsplugin STATIC)
qt_add_qml_module(chartsplugin
    URI "charts"
    VERSION 1.0
    QML_FILES
        Main.qml
        components/BarChart.qml
        components/LineChart.qml
)
```

### 5. Register in examples/CMakeLists.txt

```cmake
add_subdirectory(buttons)
add_subdirectory(sliders)
add_subdirectory(charts)   # ← add this
```

### 6. Link in /qmlmodules

Add the plugin target (note the doubled `plugin` suffix — this is intentional):

```cmake
target_link_libraries(QMLSnippetsExamples PRIVATE
    ...
    buttonspluginplugin
    sliderspluginplugin
    chartspluginplugin   # ← add this
)
```

### 7. Add a menu entry in MainMenuList.qml

Edit `mainui/mainmenu/MainMenuList.qml`. The `text` value must match the Dashboard state exactly.

```qml
ListModel {
    id: menuModel
    ListElement { text: "Dashboard" }
    ListElement { text: "Buttons" }
    ListElement { text: "Charts" }   // ← add this
}
```

### 8. Wire up in Dashboard.qml

Edit `mainui/home/Dashboard.qml`:

```qml
import charts as Charts   // ← add import

// Inside the Dashboard Item:
Charts.Main {
    anchors.fill: parent
    fullSize: (root.state === "Charts")   // must match ListElement text
}
```

### 9. Add an icon

Place a PNG icon (25×26px, teal `#00D1A9`, transparent background) at:

```
imports/assets/icons/charts.png
```

The icon filename must be the lowercase version of the menu text.

### 10. Clean rebuild

After any CMake structural change, always do a full clean rebuild:

```bash
rm -rf build
cmake -B build -S .
cmake --build build
```

---

## Naming Convention

| Module URI | Library name | Link target |
|---|---|---|
| `"buttons"` | `buttonsplugin` | `buttonspluginplugin` |
| `"sliders"` | `slidersplugin` | `sliderspluginplugin` |
| `"charts"` | `chartsplugin` | `chartspluginplugin` |

`qt_add_qml_module` automatically appends `plugin` to the library name when creating the QML plugin target. That's why the link target has `plugin` twice.

---

## ⚠️ Critical Error: "module plugin not found"

### Symptom

```
QQmlApplicationEngine failed to load component
qrc:/qt/qml/mainui/home/Dashboard.qml:6:1: module "charts" plugin "chartspluginplugin" not found
```

### Cause

The module's `CMakeLists.txt` is missing the static library declaration.

### ❌ Wrong

```cmake
qt_add_qml_module(chartsplugin
    URI "charts"
    ...
)
```

### ✅ Correct

```cmake
qt_add_library(chartsplugin STATIC)   # ← this line is required
qt_add_qml_module(chartsplugin
    URI "charts"
    ...
)
```

### Fix

1. Add `qt_add_library(chartsplugin STATIC)` before `qt_add_qml_module` in the module's CMakeLists.txt
2. Verify the plugin is listed in `/qmlmodules` with the `pluginplugin` suffix
3. Full clean rebuild: `rm -rf build && cmake -B build -S . && cmake --build build`

---

## 🔴 Critical: Renaming a library requires a full clean rebuild

Incremental builds (`cmake --build build`) do not detect library renames. If you rename a library in CMakeLists.txt, always do:

```bash
rm -rf build && cmake -B build -S . && cmake --build build
```

This is required whenever you:
- Change a library name in CMakeLists.txt
- Change a module URI
- Add or remove `qt_add_library()` / `qt_add_qml_module()`
- Modify `target_link_libraries()`
- Move QML files between directories
- Modify `qmldir` files

---

## Verification Checklist

- [ ] `qt_add_library(<name>plugin STATIC)` exists in the module's CMakeLists.txt
- [ ] `qt_add_qml_module(<name>plugin ...)` follows immediately after
- [ ] Module URI matches the import statement in Dashboard.qml
- [ ] `add_subdirectory(<name>)` added to `examples/CMakeLists.txt`
- [ ] `<name>pluginplugin` added to `target_link_libraries` in `/qmlmodules`
- [ ] `qmldir` file exists with correct module name and `Main 1.0 Main.qml`
- [ ] Menu text in `MainMenuList.qml` matches Dashboard state string exactly
- [ ] Icon PNG placed at `imports/assets/icons/<lowercase-name>.png`
- [ ] Full clean rebuild completed
