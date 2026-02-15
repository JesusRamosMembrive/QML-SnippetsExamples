# Cómo Crear una Nueva Página de Ejemplos

Este documento explica cómo agregar nuevas páginas de ejemplos (como Buttons, Sliders, Charts, etc.) al dashboard QML.

## Estructura del Proyecto

Anteriormente, las páginas estaban en el directorio `/apps/` (calendar, inbox, webradio, etc.). Este directorio ha sido eliminado.

**Nueva estructura:** Las páginas ahora se crearán en un nuevo directorio llamado **`/examples/`** en la raíz del proyecto.

```
QML-Dashboard-jdqt-import/
├── docs/
├── examples/          ← NUEVO: Aquí van las páginas de ejemplos
│   ├── buttons/       ← Ejemplo: Página de botones
│   ├── sliders/       ← Ejemplo: Página de sliders
│   └── charts/        ← Ejemplo: Página de gráficas
├── imports/
├── mainui/
├── styles/
└── Main.qml
```

## Pasos para Crear una Nueva Página

### 1. Crear la estructura de directorios

Cada página de ejemplo debe tener su propia carpeta dentro de `/examples/`. Por ejemplo, para una página de botones:

```
examples/
└── buttons/
    ├── CMakeLists.txt
    ├── qmldir
    └── Main.qml
```

### 2. Crear el archivo Main.qml

Este es el componente principal de tu página. Ejemplo básico:

```qml
import QtQuick
import QtQuick.Controls
import utils

Item {
    id: root

    // Esta propiedad controla cuando la página ocupa toda la pantalla
    property bool fullSize: false

    // Animaciones de visibilidad
    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    // Ancho y alto cuando está en modo fullSize
    anchors.fill: parent

    // Tu contenido aquí
    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        Text {
            anchors.centerIn: parent
            text: "Página de Ejemplos de Botones"
            font.pixelSize: Style.resize(24)
            color: Style.mainColor
        }

        // Aquí agregarías tus ejemplos de botones
    }
}
```

### 3. Crear el archivo qmldir

Define el módulo QML. Ejemplo para `examples/buttons/qmldir`:

```
module buttons
Main 1.0 Main.qml
```

### 4. Crear el archivo CMakeLists.txt

Configura el módulo QML para CMake. Ejemplo para `examples/buttons/CMakeLists.txt`:

```cmake
qt_add_qml_module(buttonsplugin
    URI "buttons"
    VERSION 1.0
    QML_FILES
        Main.qml
    RESOURCES
)
```

Si tu página tiene componentes adicionales (paneles, controles, vistas, etc.), agrégalos al `QML_FILES`:

```cmake
qt_add_qml_module(buttonsplugin
    URI "buttons"
    VERSION 1.0
    QML_FILES
        Main.qml
        controls/CustomButton.qml
        views/ButtonGrid.qml
)
```

### 5. Actualizar el CMakeLists.txt principal de examples

Crea o actualiza `/examples/CMakeLists.txt`:

```cmake
add_subdirectory(buttons)
add_subdirectory(sliders)
add_subdirectory(charts)
```

### 6. Registrar el módulo en el sistema de build

Edita `/qmlmodules` y agrega:

1. El subdirectorio:
```cmake
add_subdirectory(examples)
```

2. El plugin en target_link_libraries:
```cmake
target_link_libraries(QDashboardApp PRIVATE
    qdashboardstyleplugin
    utilsplugin
    controlsplugin
    mainuiplugin
    buttonsplugin     # ← AGREGAR
    slidersplugin     # ← AGREGAR
    chartsplugin      # ← AGREGAR
)
```

### 7. Actualizar el CMakeLists.txt raíz

Edita `/CMakeLists.txt` y actualiza `QML_IMPORT_PATH`:

```cmake
set(QML_IMPORT_PATH
    ${CMAKE_CURRENT_LIST_DIR}/imports
    ${CMAKE_CURRENT_LIST_DIR}/examples  # ← AGREGAR
    CACHE STRING "" FORCE
)
```

### 8. Actualizar QDashBoardApp.qmlproject

Edita `/QDashBoardApp.qmlproject` y agrega "examples" al importPaths:

```
importPaths: [ ".", "styles", "imports", "mainui", "examples" ]
```

### 9. Agregar el item al menú lateral

Edita `/mainui/mainmenu/MainMenuList.qml` y agrega tu página al modelo:

```qml
ListModel {
    id: menuModel
    ListElement { text: "Dashboard" }
    ListElement { text: "Buttons" }      // ← AGREGAR
    ListElement { text: "Sliders" }      // ← AGREGAR
    ListElement { text: "Charts" }       // ← AGREGAR
}
```

**Nota:** El texto debe coincidir exactamente con el nombre que usarás en el estado del Dashboard.

### 10. Integrar la página en el Dashboard

Edita `/mainui/home/Dashboard.qml`:

1. Importa tu módulo:
```qml
import QtQuick
import QtCore
import utils
import buttons as Buttons    // ← AGREGAR
import sliders as Sliders     // ← AGREGAR
import charts as Charts       // ← AGREGAR
```

2. Agrega el componente:
```qml
Item {
    id: root
    state: "Dashboard"
    objectName: "Dashboard"

    Buttons.Main {
        visible: fullSize
        fullSize: (root.state === "Buttons")
    }

    Sliders.Main {
        visible: fullSize
        fullSize: (root.state === "Sliders")
    }

    Charts.Main {
        visible: fullSize
        fullSize: (root.state === "Charts")
    }
}
```

**Importante:** El valor del estado (`root.state === "Buttons"`) debe coincidir exactamente con el texto del menú.

## Estructura Completa de Ejemplo

```
examples/buttons/
├── CMakeLists.txt
├── qmldir
├── Main.qml
├── controls/                  # (Opcional) Controles personalizados
│   ├── CustomButton.qml
│   └── IconButton.qml
├── panels/                    # (Opcional) Paneles de la UI
│   └── ButtonsPanel.qml
└── views/                     # (Opcional) Vistas complejas
    └── ButtonGrid.qml
```

## Consejos

1. **Reutiliza componentes**: Usa los controles de `/imports/controls/` y utilidades de `/imports/utils/`
2. **Mantén consistencia**: Usa `Style.resize()` para todas las dimensiones
3. **Propiedad fullSize**: Siempre implementa la propiedad `fullSize` para controlar la visibilidad
4. **Estados**: El estado del Dashboard controla qué página se muestra
5. **Iconos del menú**: Los iconos se cargan automáticamente desde `Style.icon(text.toLowerCase())`
   - Asegúrate de tener un icono correspondiente en `/imports/assets/icons/`

## Rebuild del Proyecto

Después de agregar una nueva página, necesitas reconstruir el proyecto:

```bash
cmake -B build -S .
cmake --build build
```

O si usas Qt Creator, simplemente ejecuta "Build" → "Rebuild All".
