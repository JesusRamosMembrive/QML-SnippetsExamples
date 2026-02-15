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
    buttonspluginplugin     # ← AGREGAR (con sufijo "plugin" duplicado)
    sliderspluginplugin     # ← AGREGAR (con sufijo "plugin" duplicado)
    chartspluginplugin      # ← AGREGAR (con sufijo "plugin" duplicado)
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

## ⚠️ ERROR RECURRENTE: "module plugin not found"

### Síntoma

Al ejecutar la aplicación después de crear una nueva página, obtienes un error como:

```
QQmlApplicationEngine failed to load component
qrc:/qt/qml/mainui/home/Dashboard.qml:6:1: module "sliders" plugin "sliderspluginplugin" not found
```

O variantes como:
```
module "buttons" plugin "buttonspluginplugin" not found
module "charts" plugin "chartspluginplugin" not found
```

### Causa

Este error ocurre porque **CMakeLists.txt del módulo está mal configurado**. El problema está en que estás creando un módulo QML **sin una biblioteca estática**.

### ❌ Configuración INCORRECTA

```cmake
# examples/sliders/CMakeLists.txt - ¡INCORRECTO!
qt_add_qml_module(slidersplugin
    URI "sliders"
    VERSION 1.0
    QML_FILES
        Main.qml
)
```

En esta configuración:
- No se crea una biblioteca estática
- Qt busca un plugin llamado `sliderspluginplugin` que no existe
- El sistema de módulos QML falla al cargar

### ✅ Configuración CORRECTA

```cmake
# examples/sliders/CMakeLists.txt - ¡CORRECTO!
qt_add_library(slidersplugin STATIC)
qt_add_qml_module(slidersplugin
    URI "sliders"
    VERSION 1.0
    QML_FILES
        Main.qml
)
```

### Explicación Técnica

1. **`qt_add_library(slidersplugin STATIC)`** - Crea una biblioteca estática con el nombre `slidersplugin`
2. **`qt_add_qml_module(slidersplugin ...)`** - Asocia el módulo QML con esa biblioteca
3. Qt automáticamente agrega el sufijo `plugin` al nombre, resultando en `sliderspluginplugin` internamente
4. Si no existe la biblioteca, Qt no puede cargar el módulo

### Patrón de Nombres

Para evitar confusión, sigue este patrón:

| Módulo URI | Nombre de Biblioteca | Target para Link              |
|------------|---------------------|-------------------------------|
| `"buttons"` | `buttonsplugin`      | `buttonspluginplugin`         |
| `"sliders"` | `slidersplugin`      | `sliderspluginplugin`         |
| `"charts"`  | `chartsplugin`       | `chartspluginplugin`          |

**Importante:** Cuando usas `qt_add_qml_module(buttonsplugin ...)`, Qt crea automáticamente **dos targets**:
1. **`buttonsplugin`** - La biblioteca estática base
2. **`buttonspluginplugin`** - El plugin QML que incluye los metadatos y archivos QML

En `target_link_libraries`, debes usar el target **con el sufijo `plugin` duplicado**: `buttonspluginplugin`, `sliderspluginplugin`, etc.

### Solución Paso a Paso

Si encuentras este error:

1. **Abre el CMakeLists.txt del módulo afectado** (ej: `examples/sliders/CMakeLists.txt`)

2. **Verifica que tenga esta estructura:**
   ```cmake
   qt_add_library(slidersplugin STATIC)  # ← DEBE existir esta línea
   qt_add_qml_module(slidersplugin
       URI "sliders"
       VERSION 1.0
       QML_FILES
           Main.qml
   )
   ```

3. **Verifica que esté linkeado en `/qmlmodules`:**
   ```cmake
   target_link_libraries(QDashboardApp PRIVATE
       qdashboardstyleplugin
       utilsplugin
       controlsplugin
       mainuiplugin
       buttonspluginplugin     # ← Nota el sufijo "plugin" duplicado
       sliderspluginplugin     # ← Debe estar presente con sufijo "plugin"
   )
   ```

   **IMPORTANTE**: Usa el nombre con `plugin` duplicado (ej: `buttonspluginplugin`) porque `qt_add_qml_module` genera automáticamente ese target.

4. **Reconstruye completamente el proyecto:**
   ```bash
   # Opción 1: Desde terminal
   rm -rf build
   cmake -B build -S .
   cmake --build build

   # Opción 2: Desde Qt Creator
   Build → Clean All Projects
   Build → Rebuild All Projects
   ```

5. **Verifica que se haya creado el plugin:**
   ```bash
   ls build/examples/sliders/
   # Deberías ver: libslidersplugin.a (Linux/macOS) o slidersplugin.lib (Windows)
   ```

### Otros Errores Relacionados

#### Error: "Cannot find module 'sliders'"

**Causa:** El módulo no está en el `QML_IMPORT_PATH`

**Solución:** Verifica `/CMakeLists.txt`:
```cmake
set(QML_IMPORT_PATH
    ${CMAKE_CURRENT_LIST_DIR}/imports
    ${CMAKE_CURRENT_LIST_DIR}/examples  # ← Debe incluir examples
    CACHE STRING "" FORCE
)
```

#### Error: "Type Main unavailable"

**Causa:** El archivo `qmldir` no está correctamente configurado o falta

**Solución:** Verifica `examples/sliders/qmldir`:
```
module sliders
Main 1.0 Main.qml
```

#### Advertencias del IDE pero funciona al ejecutar

**Causa:** El IDE no ha detectado los cambios de CMake

**Solución:**
1. En Qt Creator: Tools → QML/JS → Reset Code Model
2. O cierra y vuelve a abrir el proyecto

### Checklist de Verificación

Usa esta lista para verificar que todo esté correcto:

- [ ] Existe `qt_add_library(nombreplugin STATIC)` en el CMakeLists.txt del módulo
- [ ] Existe `qt_add_qml_module(nombreplugin ...)` después de la biblioteca
- [ ] El URI del módulo coincide con el nombre usado en los imports
- [ ] El módulo está agregado en `examples/CMakeLists.txt` con `add_subdirectory()`
- [ ] El plugin está agregado en `/qmlmodules` en `target_link_libraries()`
- [ ] El directorio `examples` está en `QML_IMPORT_PATH` en `/CMakeLists.txt`
- [ ] Existe el archivo `qmldir` en el directorio del módulo
- [ ] El proyecto se recompiló completamente después de los cambios

Si todos los puntos están marcados y el error persiste, ejecuta:
```bash
rm -rf build
cmake -B build -S . && cmake --build build
```

## 🔴 ERROR CRÍTICO: Cambiar nombre de biblioteca requiere rebuild completo

### Síntoma Específico

Después de **cambiar el nombre de una biblioteca** en CMakeLists.txt (por ejemplo, de `buttons` a `buttonsplugin`), obtienes:

```
module "buttons" plugin "buttonspluginplugin" not found
```

Incluso después de ejecutar "Build" o "Rebuild" en Qt Creator.

### ¿Por qué ocurre?

Cuando cambias el nombre de una biblioteca estática en CMake:

```cmake
# Cambio realizado:
# ANTES: qt_add_library(buttons STATIC)
# AHORA: qt_add_library(buttonsplugin STATIC)
```

El sistema de build de Qt hace lo siguiente:

1. **Build incremental** no detecta que el *nombre* de la biblioteca cambió
2. Sigue buscando el archivo antiguo `libbuttons.a` (o `buttons.lib` en Windows)
3. El nuevo archivo `libbuttonsplugin.a` se crea, pero Qt no lo encuentra
4. Los archivos de metadatos QML (.qmltypes, plugin registry) quedan desactualizados
5. El motor QML busca un plugin que ya no existe con el nombre antiguo

### ⚠️ SOLUCIÓN OBLIGATORIA: Clean Build Completo

**NO es suficiente** hacer "Rebuild" en Qt Creator. Debes hacer un clean build desde cero:

#### Opción 1: Desde Terminal (RECOMENDADO)

```bash
# 1. Eliminar completamente el directorio build
rm -rf build

# 2. Regenerar configuración de CMake desde cero
cmake -B build -S .

# 3. Compilar todo de nuevo
cmake --build build
```

#### Opción 2: Desde Qt Creator

```bash
# 1. Cerrar Qt Creator completamente
# 2. Desde terminal:
rm -rf build

# 3. Volver a abrir Qt Creator
# 4. Build → Run CMake
# 5. Build → Build All Projects
```

#### Opción 3: Script de rebuild completo

Crea un archivo `rebuild.sh` en la raíz del proyecto:

```bash
#!/bin/bash
echo "🗑️  Eliminando directorio build..."
rm -rf build

echo "🔧 Configurando CMake..."
cmake -B build -S .

echo "🔨 Compilando proyecto..."
cmake --build build

echo "✅ Rebuild completo terminado"
```

Luego ejecútalo:
```bash
chmod +x rebuild.sh
./rebuild.sh
```

### ¿Por qué "Rebuild All" NO funciona?

Qt Creator y CMake hacen builds **incrementales** por defecto:

- **Build**: Compila solo lo que cambió
- **Rebuild**: Elimina objetos compilados, pero **NO** regenera la configuración de CMake
- **Clean**: Elimina outputs, pero mantiene la caché de CMake

Ninguna de estas opciones regenera completamente los archivos de metadatos de los plugins QML cuando cambias el nombre de una biblioteca.

### Cuándo es necesario un clean build completo

Debes hacer `rm -rf build` y regenerar cuando:

- ✅ **Cambias el nombre de una biblioteca** en CMakeLists.txt
- ✅ **Cambias el URI de un módulo QML**
- ✅ **Agregas o eliminas `qt_add_library()`**
- ✅ **Cambias `target_link_libraries()`**
- ✅ **Mueves archivos QML entre directorios**
- ✅ **Modificas archivos `qmldir`**
- ✅ **Agregas/eliminas módulos QML completos**

### Cuándo NO es necesario

Un rebuild normal es suficiente cuando:

- ❌ Modificas contenido de archivos .qml (código QML)
- ❌ Cambias propiedades de componentes
- ❌ Agregas nuevos archivos .qml a un módulo existente (solo si agregas al CMakeLists.txt después)
- ❌ Modificas archivos .cpp/.h

### Verificación Post-Rebuild

Después del rebuild completo, verifica que los plugins se crearon:

```bash
# Linux/macOS
ls -la build/examples/buttons/
# Debes ver: libbuttonsplugin.a

ls -la build/examples/sliders/
# Debes ver: libslidersplugin.a

# Windows
dir build\examples\buttons\
# Debes ver: buttonsplugin.lib

dir build\examples\sliders\
# Debes ver: slidersplugin.lib
```

### Resumen: Regla de Oro

**SIEMPRE que cambies algo en CMakeLists.txt relacionado con nombres de bibliotecas, módulos QML o estructura de plugins:**

```bash
rm -rf build && cmake -B build -S . && cmake --build build
```

No confíes en "Rebuild" de Qt Creator para estos casos. Un clean build completo es la única garantía de que los cambios se apliquen correctamente.
