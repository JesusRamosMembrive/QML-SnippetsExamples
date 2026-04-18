# QML Snippets Examples - Component Library

Proyecto QML Snippets Examples para crear una biblioteca de componentes reutilizables y ejemplos.

## 👀 Feedback Visual

La galería visual del proyecto está dividida en dos bloques para mantener una historia de commits más manejable.

<details open>
<summary><strong>Galería 1 de 2</strong></summary>

<p>
  <img src="gifs/animationsExample.gif" alt="animationsExample" width="280" />
  <img src="gifs/AsyncCpp.gif" alt="AsyncCpp" width="280" />
  <img src="gifs/ButtonExample.gif" alt="ButtonExample" width="280" />
  <img src="gifs/Canvas.gif" alt="Canvas" width="280" />
  <img src="gifs/card2d5.gif" alt="card2d5" width="280" />
  <img src="gifs/Chatui.gif" alt="Chatui" width="280" />
  <img src="gifs/ComboBox.gif" alt="ComboBox" width="280" />
  <img src="gifs/DatabaBase.gif" alt="DatabaBase" width="280" />
  <img src="gifs/Date.gif" alt="Date" width="280" />
  <img src="gifs/Drawer.gif" alt="Drawer" width="280" />
  <img src="gifs/ECAM.gif" alt="ECAM" width="280" />
  <img src="gifs/FileDialog.gif" alt="FileDialog" width="280" />
  <img src="gifs/flickable.gif" alt="flickable" width="280" />
  <img src="gifs/FrostGlass.gif" alt="FrostGlass" width="280" />
  <img src="gifs/Graphs.gif" alt="Graphs" width="280" />
  <img src="gifs/Gridview.gif" alt="Gridview" width="280" />
  <img src="gifs/HUD.gif" alt="HUD" width="280" />
  <img src="gifs/images.gif" alt="images" width="280" />
  <img src="gifs/InidicatorsAndDials.gif" alt="InidicatorsAndDials" width="280" />
  <img src="gifs/Layouts.gif" alt="Layouts" width="280" />
  <img src="gifs/LensMagnification.gif" alt="LensMagnification" width="280" />
  <img src="gifs/LensTab.gif" alt="LensTab" width="280" />
  <img src="gifs/Lists.gif" alt="Lists" width="280" />
  <img src="gifs/MENUbAR.gif" alt="MENUbAR" width="280" />
  <img src="gifs/Multimedia.gif" alt="Multimedia" width="280" />
</p>

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
