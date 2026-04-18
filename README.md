# QML Snippets Examples - Component Library

Proyecto QML Snippets Examples para crear una biblioteca de componentes reutilizables y ejemplos.

## 👀 Feedback Visual

La galería visual del proyecto está dividida en dos bloques para mantener una historia de commits más manejable.

<details open>
<summary><strong>Galería 1 de 2</strong></summary>

<p><img src="gifs/animationsExample.gif" alt="animationsExample" width="720" /></p>
<p><img src="gifs/AsyncCpp.gif" alt="AsyncCpp" width="720" /></p>
<p><img src="gifs/ButtonExample.gif" alt="ButtonExample" width="720" /></p>
<p><img src="gifs/Canvas.gif" alt="Canvas" width="720" /></p>
<p><img src="gifs/card2d5.gif" alt="card2d5" width="720" /></p>
<p><img src="gifs/Chatui.gif" alt="Chatui" width="720" /></p>
<p><img src="gifs/ComboBox.gif" alt="ComboBox" width="720" /></p>
<p><img src="gifs/DatabaBase.gif" alt="DatabaBase" width="720" /></p>
<p><img src="gifs/Date.gif" alt="Date" width="720" /></p>
<p><img src="gifs/Drawer.gif" alt="Drawer" width="720" /></p>
<p><img src="gifs/ECAM.gif" alt="ECAM" width="720" /></p>
<p><img src="gifs/FileDialog.gif" alt="FileDialog" width="720" /></p>
<p><img src="gifs/flickable.gif" alt="flickable" width="720" /></p>
<p><img src="gifs/FrostGlass.gif" alt="FrostGlass" width="720" /></p>
<p><img src="gifs/Graphs.gif" alt="Graphs" width="720" /></p>
<p><img src="gifs/Gridview.gif" alt="Gridview" width="720" /></p>
<p><img src="gifs/HUD.gif" alt="HUD" width="720" /></p>
<p><img src="gifs/images.gif" alt="images" width="720" /></p>
<p><img src="gifs/InidicatorsAndDials.gif" alt="InidicatorsAndDials" width="720" /></p>
<p><img src="gifs/Layouts.gif" alt="Layouts" width="720" /></p>
<p><img src="gifs/LensMagnification.gif" alt="LensMagnification" width="720" /></p>
<p><img src="gifs/LensTab.gif" alt="LensTab" width="720" /></p>
<p><img src="gifs/Lists.gif" alt="Lists" width="720" /></p>
<p><img src="gifs/MENUbAR.gif" alt="MENUbAR" width="720" /></p>
<p><img src="gifs/Multimedia.gif" alt="Multimedia" width="720" /></p>

</details>

<details open>
<summary><strong>Galería 2 de 2</strong></summary>

<p><img src="gifs/Multiplane.gif" alt="Multiplane" width="720" /></p>
<p><img src="gifs/NavigationDisplay.gif" alt="NavigationDisplay" width="720" /></p>
<p><img src="gifs/NetWork.gif" alt="NetWork" width="720" /></p>
<p><img src="gifs/Particles.gif" alt="Particles" width="720" /></p>
<p><img src="gifs/Pathview.gif" alt="Pathview" width="720" /></p>
<p><img src="gifs/pdfReader.gif" alt="pdfReader" width="720" /></p>
<p><img src="gifs/popupAndDialog.gif" alt="popupAndDialog" width="720" /></p>
<p><img src="gifs/PrimaryFlightDisplay.gif" alt="PrimaryFlightDisplay" width="720" /></p>
<p><img src="gifs/RangeSlider.gif" alt="RangeSlider" width="720" /></p>
<p><img src="gifs/ScrollView.gif" alt="ScrollView" width="720" /></p>
<p><img src="gifs/shaderandeffects.gif" alt="shaderandeffects" width="720" /></p>
<p><img src="gifs/Shapes.gif" alt="Shapes" width="720" /></p>
<p><img src="gifs/SliderExample.gif" alt="SliderExample" width="720" /></p>
<p><img src="gifs/SplitView.gif" alt="SplitView" width="720" /></p>
<p><img src="gifs/states.gif" alt="states" width="720" /></p>
<p><img src="gifs/StreetMaps.gif" alt="StreetMaps" width="720" /></p>
<p><img src="gifs/SwipeView.gif" alt="SwipeView" width="720" /></p>
<p><img src="gifs/Switch.gif" alt="Switch" width="720" /></p>
<p><img src="gifs/tabbar.gif" alt="tabbar" width="720" /></p>
<p><img src="gifs/TextInput.gif" alt="TextInput" width="720" /></p>
<p><img src="gifs/Toast.gif" alt="Toast" width="720" /></p>
<p><img src="gifs/Toolbar.gif" alt="Toolbar" width="720" /></p>
<p><img src="gifs/Transforms.gif" alt="Transforms" width="720" /></p>
<p><img src="gifs/TreeView.gif" alt="TreeView" width="720" /></p>
<p><img src="gifs/websockets.gif" alt="websockets" width="720" /></p>

</details>

## 🚀 Inicio Rápido

### Compilar el proyecto

```bash
cmake -B build -S .
cmake --build build
./build/QMLSnippetsExamples
```

### Rebuild completo (recomendado después de cambios estructurales)

```bash
./rebuild.sh
```

## 📚 Documentación

- **[Cómo crear una nueva página de ejemplos](docs/CREAR_NUEVA_PAGINA.md)** - Guía completa para agregar nuevas páginas al dashboard

## 🎨 Componentes Especializados

El proyecto incluye componentes reutilizables en `styles/qmlsnippetsstyle/buttons/`:

- **GlowButton** - Botón con efecto de resplandor
- **GradientButton** - Botón con gradiente de colores
- **PulseButton** - Botón con animación de pulso
- **NeumorphicButton** - Botón con estilo neumórfico (sombras suaves 3D)

Estos componentes son **completamente reutilizables** entre diferentes páginas de ejemplos.

## 📋 Páginas de Ejemplos

### Buttons
Muestra ejemplos de todos los tipos de botones:
- Botones estándar (default, highlighted, flat, disabled)
- Botones de iconos (ToolButton)
- Estados e interacciones (pressed, hovered, checkable)
- Botones personalizados (colores, estilos)
- Componentes especializados reutilizables

### Sliders
Demuestra el uso de sliders y la reutilización de componentes:
- Sliders horizontales y verticales
- Sliders con pasos (stepped)
- Control interactivo de propiedades de componentes
- Ejemplo de reutilización: GlowButton controlado por sliders

## ⚠️ Problemas Comunes

### Error: "module plugin not found"

Si ves un error como:
```
module "buttons" plugin "buttonspluginplugin" not found
```

**Solución:**
```bash
./rebuild.sh
```

Este error ocurre cuando:
- Cambias el nombre de una biblioteca en CMakeLists.txt
- Agregas o eliminas módulos QML
- Modificas la estructura de plugins

Ver [documentación completa](docs/CREAR_NUEVA_PAGINA.md#-error-recurrente-module-plugin-not-found) para más detalles.

## 🏗️ Estructura del Proyecto

```
QML-Dashboard-jdqt-import/
├── docs/                      # Documentación
├── examples/                  # Páginas de ejemplos
│   ├── buttons/              # Ejemplo: Botones
│   └── sliders/              # Ejemplo: Sliders
├── imports/                   # Assets y utilidades
│   ├── assets/               # Iconos, imágenes, fuentes
│   ├── controls/             # Controles personalizados
│   └── utils/                # Utilidades (Style singleton)
├── mainui/                    # UI principal del dashboard
│   ├── home/                 # Página principal y dashboard
│   └── mainmenu/             # Menú lateral
├── styles/                    # Estilos y temas
│   └── qmlsnippetsstyle/      # Estilo de los snippets
│       └── buttons/          # Componentes especializados de botones
├── Main.qml                   # Punto de entrada
├── rebuild.sh                 # Script de rebuild completo
└── CMakeLists.txt            # Configuración principal de CMake
```

## 🛠️ Requisitos

- Qt 6.4 o superior
- CMake 3.16 o superior
- C++ compiler compatible

## 📝 Crear una Nueva Página

Para agregar una nueva página de ejemplos (Charts, TextInputs, etc.), sigue la [guía completa](docs/CREAR_NUEVA_PAGINA.md).

Resumen rápido:
1. Crear directorio en `examples/nuevapagina/`
2. Crear archivos: `Main.qml`, `CMakeLists.txt`, `qmldir`
3. Actualizar `examples/CMakeLists.txt`
4. Actualizar `/qmlmodules`
5. Agregar entrada al menú en `mainui/mainmenu/MainMenuList.qml`
6. Importar en `mainui/home/Dashboard.qml`
7. Ejecutar `./rebuild.sh`

## 📄 Licencia

Este es un proyecto de ejemplo basado en Qt Dashboard Examples.
