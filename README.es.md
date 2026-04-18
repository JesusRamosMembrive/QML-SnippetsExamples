🇬🇧 [English version](README.md)

# Qt Quick / QML — Colección de Ejemplos

> **66 ejemplos QML listos para copiar** — desde botones y sliders hasta visualizaciones de aviónica completas, HMIs industriales, shaders y integración con C++.

[![Qt](https://img.shields.io/badge/Qt-6.4%2B-41CD52?logo=qt&logoColor=white)](https://www.qt.io/)
[![CMake](https://img.shields.io/badge/CMake-3.16%2B-064F8C?logo=cmake&logoColor=white)](https://cmake.org/)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![Plataforma](https://img.shields.io/badge/Plataforma-Linux%20%7C%20Windows-lightgrey)](#-inicio-rápido)
[![Build](https://github.com/JesusRamosMembrive/QML-SnippetsExamples/actions/workflows/build.yml/badge.svg)](https://github.com/JesusRamosMembrive/QML-SnippetsExamples/actions/workflows/build.yml)

<p align="center">
  <img src="gifs/HUD.gif" alt="Head-Up Display" width="720"/>
</p>

---

## Tabla de Contenidos

- [Componentes Destacados](#-componentes-destacados)
- [Catálogo de Componentes](#-catálogo-de-componentes)
- [Inicio Rápido](#-inicio-rápido)
- [Requisitos](#-requisitos)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Documentación](#-documentación)
- [Contribuir](#-contribuir)
- [Licencia](#-licencia)
- [Sobre el Autor](#-sobre-el-autor)

---

## ✈️ Componentes Destacados

Lo más diferenciador de esta colección — componentes que no encontrarás en un tutorial básico de Qt.

<table>
  <tr>
    <td align="center"><img src="gifs/HUD.gif" width="360"/><br><b>Head-Up Display (HUD)</b></td>
    <td align="center"><img src="gifs/PrimaryFlightDisplay.gif" width="360"/><br><b>Primary Flight Display (PFD)</b></td>
  </tr>
  <tr>
    <td align="center"><img src="gifs/NavigationDisplay.gif" width="360"/><br><b>Navigation Display (ND)</b></td>
    <td align="center"><img src="gifs/ECAM.gif" width="360"/><br><b>ECAM — Pantalla de sistemas</b></td>
  </tr>
  <tr>
    <td align="center"><img src="gifs/FrostGlass.gif" width="360"/><br><b>Efecto de Cristal Esmerilado</b></td>
    <td align="center"><img src="gifs/LensMagnification.gif" width="360"/><br><b>Lupa con Shader</b></td>
  </tr>
  <tr>
    <td align="center"><img src="gifs/shaderandeffects.gif" width="360"/><br><b>Shaders GLSL Personalizados</b></td>
    <td align="center"><img src="gifs/Multiplane.gif" width="360"/><br><b>Paralaje Multiplano</b></td>
  </tr>
</table>

👉 **[Ver la galería completa (66 componentes) →](docs/GALLERY.md)**

---

## 🧩 Catálogo de Componentes

### Controles e Inputs
`Botones` · `Sliders` · `RangeSlider` · `ComboBox` · `Switch` · `TextInput` · `Fecha` · `MenuBar` · `TabBar` · `ToolBar`

### Vistas y Contenedores
`ListView` · `GridView` · `PathView` · `TreeView` · `TableView` · `SwipeView` · `SplitView` · `ScrollView` · `Flickable` · `Drawer` · `Popup y Dialog` · `Toast` · `Tarjetas`

### Layouts
`Layouts` · `Portal`

### Efectos Visuales y Renderizado
`Animaciones` · `Cristal Esmerilado` · `Lupa` · `Lens Tabs` · `Paralaje Multiplano` · `Partículas` · `Shaders GLSL` · `Transformadas` · `Efectos Visuales` · `Diorama` · `Sprite Stack` · `Gráficos 3D`

### ✈️ Aviónica e HMI Industrial
`Head-Up Display (HUD)` · `Primary Flight Display (PFD)` · `Navigation Display` · `ECAM` · `Indicadores y Diales` · `Mapa de Aeronave`

### Datos, Gráficas y Canvas
`Canvas` · `Gráficas 3D` · `Graphs` · `Shapes`

### Sistema, Red e Integración
`Base de Datos (SQLite)` · `Ethernet` · `Diálogo de Archivos` · `Imágenes` · `Multimedia` · `Red` · `Lector PDF` · `Mapas` · `Ajustes` · `WebSockets` · `Loader`

### Integración C++
`Async C++` · `Puente QML–C++` · `Teoría C++` · `Hilos`

### Patrones QML
`Estados y Transiciones` · `Elementos Personalizados` · `Chat UI`

---

## 🚀 Inicio Rápido

```bash
git clone https://github.com/JesusRamosMembrive/QML-SnippetsExamples.git
cd QML-SnippetsExamples

# Configurar (indica la ruta a tu instalación de Qt si es necesario)
cmake -B build -S . -DCMAKE_PREFIX_PATH="/ruta/a/Qt/6.x.x/gcc_64"

# Compilar
cmake --build build

# Ejecutar (Linux)
./build/QMLSnippetsExamples

# Ejecutar (Windows)
build\Debug\QMLSnippetsExamples.exe
```

### Rebuild completo (obligatorio tras cambios estructurales en CMake)

```bash
rm -rf build
cmake -B build -S . -DCMAKE_PREFIX_PATH="/ruta/a/Qt/6.x.x/gcc_64"
cmake --build build
```

> **Usuarios de Windows:** reemplaza la ruta con la tuya real,
> p.ej. `C:/Qt/6.11.0/msvc2022_64` o `C:/Qt/6.11.0/mingw_64`.

---

## 🛠️ Requisitos

| Dependencia | Versión |
|---|---|
| Qt | 6.4+ |
| CMake | 3.16+ |
| Compilador C++ | C++17 (GCC, Clang, MSVC) |

**Módulos Qt utilizados:** Quick · QuickControls2 · Graphs · WebSockets · Location · Positioning · Pdf · PdfQuick · Sql · Multimedia · Concurrent · Network · ShaderTools · Quick3D · QuickEffects · Qt5Compat.GraphicalEffects

---

## 📁 Estructura del Proyecto

```
QML-SnippetsExamples/
├── examples/                  # 66 páginas de ejemplo (un módulo cada una)
│   ├── hud/                   #   Head-Up Display
│   ├── pfd/                   #   Primary Flight Display
│   ├── navdisplay/            #   Navigation Display
│   ├── ecam/                  #   ECAM
│   ├── buttons/               #   Ejemplos de botones
│   ├── sliders/               #   Ejemplos de sliders
│   └── ...                    #   (60 más)
├── imports/
│   ├── assets/                # Iconos, imágenes, fuentes
│   ├── controls/              # Controles reutilizables (BaseCard, Separator)
│   └── utils/                 # Singleton Style (colores, fuentes, resize)
├── mainui/
│   ├── home/                  # Dashboard principal y switcher de páginas
│   └── mainmenu/              # Menú lateral
├── styles/
│   └── qmlsnippetsstyle/      # Overrides del estilo Qt Quick Controls 2
│       └── buttons/           # GlowButton, GradientButton, PulseButton, NeumorphicButton
├── src/
│   └── main.cpp               # Punto de entrada de la aplicación
├── docs/                      # Documentación
├── gifs/                      # GIFs de demostración
├── Main.qml                   # Punto de entrada QML raíz
├── CMakeLists.txt             # Configuración de compilación raíz
└── qtquickcontrols2.conf      # Configuración del estilo Qt Quick Controls 2
```

---

## 📚 Documentación

| Documento | Descripción |
|---|---|
| [Galería Completa](docs/GALLERY.md) | Todos los GIFs de 66 componentes organizados por categoría |
| [Creating a New Page (EN)](docs/CREATING_NEW_PAGE.md) | Guía paso a paso para añadir una nueva página de ejemplo |
| [Crear una Nueva Página (ES)](docs/CREAR_NUEVA_PAGINA.md) | Versión en español de la guía anterior |

### Error frecuente: "module plugin not found"

Si ves `module "buttons" plugin "buttonspluginplugin" not found`, necesitas un rebuild completo:

```bash
rm -rf build && cmake -B build -S . && cmake --build build
```

Consulta la [guía de nueva página](docs/CREAR_NUEVA_PAGINA.md#️-error-recurrente-module-plugin-not-found) para la explicación completa.

---

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! Para añadir una nueva página de ejemplo:

1. Haz un fork del repo y crea una rama de feature
2. Sigue la guía en [docs/CREATING_NEW_PAGE.md](docs/CREATING_NEW_PAGE.md)
3. Verifica que el proyecto compila limpiamente: `cmake -B build -S . && cmake --build build`
4. Añade un GIF de demo en `gifs/` y actualiza [docs/GALLERY.md](docs/GALLERY.md)
5. Abre un pull request

Lee [CONTRIBUTING.md](CONTRIBUTING.md) antes de enviar.

---

## 📄 Licencia

Este proyecto está bajo la **GNU General Public License v3.0** — consulta [LICENSE](LICENSE) para más detalles.

> **Nota:** El autor está considerando relicenciar a MIT para facilitar una adopción más amplia.

---

## 👤 Sobre el Autor

Desarrollado y mantenido por **Jesús Ramos Membrive** — desarrollador C++/Qt especializado en
HMIs industriales, sistemas embebidos y visualizaciones de aviónica. Basado en Madrid, España.

🔗 LinkedIn: [linkedin.com/in/jesus-ramos-membrive-91a896101](https://www.linkedin.com/in/jesus-ramos-membrive-91a896101)

💼 Disponible para consultoría Qt/QML y proyectos de desarrollo HMI.
