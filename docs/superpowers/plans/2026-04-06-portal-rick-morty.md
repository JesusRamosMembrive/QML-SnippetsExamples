# Portal Rick & Morty — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Crear una nueva página de ejemplo `examples/portal/` que recrea el portal de Rick & Morty usando Canvas 2D con JavaScript, con reflejo en el suelo e interacción (click, hover, sliders).

**Architecture:** Un módulo QML independiente (`portal`) con tres componentes Canvas: `PortalCanvas` (espiral + destellos + glow interno via shadowBlur), `ReflectionCanvas` (copia invertida y degradada), y un `MultiEffect` de `QtQuick.Effects` encima del portal para el halo exterior. Los controles (sliders de velocidad y glow) están en `PortalControls`. La lógica de dibujo compartida vive en `portal_draw.js`.

**Tech Stack:** Qt 6.11, QML, Canvas 2D (JavaScript), `QtQuick.Effects.MultiEffect`, `QtQuick.Layouts`, `utils` (Style singleton).

---

## Mapa de archivos

| Archivo | Acción | Responsabilidad |
|---|---|---|
| `examples/portal/CMakeLists.txt` | Crear | Build del módulo QML |
| `examples/portal/qmldir` | Crear | Declaración del módulo |
| `examples/portal/portal_draw.js` | Crear | Funciones JS compartidas de dibujo |
| `examples/portal/PortalCanvas.qml` | Crear | Canvas principal: espiral + destellos + Timer |
| `examples/portal/ReflectionCanvas.qml` | Crear | Canvas reflejo: portal invertido con degradado |
| `examples/portal/PortalControls.qml` | Crear | Panel de sliders (velocidad, glow) |
| `examples/portal/Main.qml` | Crear | Raíz de la página, ensambla todo |
| `examples/CMakeLists.txt` | Modificar | Añadir `add_subdirectory(portal)` |
| `qmlmodules` | Modificar | Añadir `portalpluginplugin` en `target_link_libraries` |
| `mainui/home/Dashboard.qml` | Modificar | Añadir entrada en `pageMap` |
| `mainui/mainmenu/MainMenuList.qml` | Modificar | Añadir `ListElement { name: "Portal" }` |
| `imports/assets/CMakeLists.txt` | Modificar | Añadir `icons/portal.png` |
| `imports/assets/icons/portal.png` | Crear | Icono 25×26 px, teal #00D1A9 |

---

## Task 1: Scaffold del módulo — CMakeLists.txt y qmldir

**Files:**
- Create: `examples/portal/CMakeLists.txt`
- Create: `examples/portal/qmldir`

- [ ] **Step 1: Crear `examples/portal/CMakeLists.txt`**

```cmake
qt_add_library(portalplugin STATIC)
qt_add_qml_module(portalplugin
    URI "portal"
    VERSION 1.0
    QML_FILES
        Main.qml
        PortalCanvas.qml
        ReflectionCanvas.qml
        PortalControls.qml
    RESOURCES
        portal_draw.js
)
```

> **Nota:** `portal_draw.js` va en `RESOURCES`, no en `QML_FILES`, porque es un archivo JS auxiliar, no un tipo QML.

- [ ] **Step 2: Crear `examples/portal/qmldir`**

```
module portal
Main 1.0 Main.qml
PortalCanvas 1.0 PortalCanvas.qml
ReflectionCanvas 1.0 ReflectionCanvas.qml
PortalControls 1.0 PortalControls.qml
```

---

## Task 2: Registrar el módulo en el sistema de build y navegación

**Files:**
- Modify: `examples/CMakeLists.txt`
- Modify: `qmlmodules`
- Modify: `mainui/home/Dashboard.qml`
- Modify: `mainui/mainmenu/MainMenuList.qml`
- Modify: `imports/assets/CMakeLists.txt`
- Create: `imports/assets/icons/portal.png`

- [ ] **Step 1: Añadir `add_subdirectory(portal)` al final de `examples/CMakeLists.txt`**

Al final del archivo, añadir:
```cmake
add_subdirectory(portal)
```

- [ ] **Step 2: Añadir `portalpluginplugin` en `qmlmodules`**

En el bloque `target_link_libraries(QMLSnippetsExamples PRIVATE ...)`, dentro del grupo de páginas visuales, añadir después de `shaderspluginplugin`:
```cmake
    portalpluginplugin
```

- [ ] **Step 3: Añadir entrada en el `pageMap` de `Dashboard.qml`**

En `mainui/home/Dashboard.qml`, dentro de `readonly property var pageMap: ({`, añadir después de la línea `"Charts3D": ...`:
```qml
        "Portal":       "qrc:/qt/qml/portal/Main.qml"
```

> **Importante:** la clave `"Portal"` debe coincidir exactamente con el `ListElement` del menú y con el estado del Dashboard.

- [ ] **Step 4: Añadir `ListElement` en `MainMenuList.qml`**

En `mainui/mainmenu/MainMenuList.qml`, dentro del `ListModel`, añadir al final (antes del cierre `}`):
```qml
        ListElement { name: "Portal" }
```

- [ ] **Step 5: Crear el icono placeholder**

Crea un PNG de 25×26 píxeles de color teal `#00D1A9` en `imports/assets/icons/portal.png`. Puedes copiar temporalmente cualquier icono existente y renombrarlo, o crear uno nuevo con cualquier editor de imágenes o con Python:

```python
# Ejecutar desde la raíz del proyecto:
python -c "
from PIL import Image, ImageDraw
img = Image.new('RGBA', (25, 26), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)
draw.ellipse([3, 3, 22, 23], outline=(0, 209, 169, 255), width=2)
draw.arc([8, 8, 17, 18], 0, 360, fill=(0, 209, 169, 200), width=1)
img.save('imports/assets/icons/portal.png')
"
```

Si `PIL` no está disponible, copia temporalmente cualquier icono existente:
```bash
cp imports/assets/icons/canvas.png imports/assets/icons/portal.png
```

- [ ] **Step 6: Registrar `portal.png` en `imports/assets/CMakeLists.txt`**

En `imports/assets/CMakeLists.txt`, dentro del bloque `qt_add_resources`, añadir después de `icons/canvas.png`:
```cmake
        icons/portal.png
```

- [ ] **Step 7: Hacer clean rebuild para verificar que el módulo compila**

```bash
rm -rf build && cmake -B build -S . -DCMAKE_PREFIX_PATH="C:/Qt/6.11.0/msvc2022_64" && cmake --build build
```

Esperado: compilación exitosa sin errores. El portal aparece en el menú lateral al ejecutar `build/QMLSnippetsExamples.exe`. Al hacer clic, se carga una página vacía (aún no hay contenido QML).

- [ ] **Step 8: Commit del scaffold**

```bash
git add examples/portal/CMakeLists.txt examples/portal/qmldir
git add examples/CMakeLists.txt qmlmodules
git add mainui/home/Dashboard.qml mainui/mainmenu/MainMenuList.qml
git add imports/assets/CMakeLists.txt imports/assets/icons/portal.png
git commit -m "feat: scaffold módulo portal (build + navegación)"
```

---

## Task 3: Crear `portal_draw.js` — lógica de dibujo compartida

**Files:**
- Create: `examples/portal/portal_draw.js`

Este archivo exporta dos funciones: `drawPortal` (espiral + destellos) y `applyReflectionGradient` (degradado de desvanecimiento). Ambas son puras (sin estado), marcadas con `.pragma library`.

- [ ] **Step 1: Crear `examples/portal/portal_draw.js`**

```javascript
// =============================================================================
// portal_draw.js — Funciones de dibujo compartidas para el portal
// =============================================================================
// .pragma library: este archivo no tiene estado propio. Todas las funciones
// son puras (entrada → salida sin efectos secundarios en variables globales).
// Esto permite que múltiples Canvas lo importen de forma segura.
// =============================================================================
.pragma library

// -----------------------------------------------------------------------------
// drawPortal(ctx, w, h, angle, shadowBlur, opacity)
//
// Dibuja el portal completo: fondo oscuro dentro del óvalo, espiral verde
// giratoria con glow, y destellos blancos pulsantes.
//
// Parámetros:
//   ctx        — contexto 2D del Canvas
//   w, h       — dimensiones del Canvas en píxeles
//   angle      — ángulo actual de rotación de la espiral (en radianes)
//   shadowBlur — intensidad del glow interno (0–60)
//   opacity    — opacidad global del dibujo (1.0 para portal, 0.35 para reflejo)
// -----------------------------------------------------------------------------
function drawPortal(ctx, w, h, angle, shadowBlur, opacity) {
    ctx.save()
    ctx.globalAlpha = opacity

    var cx = w / 2
    var cy = h / 2
    var rx = w * 0.42          // radio horizontal del óvalo
    var ry = h * 0.48          // radio vertical del óvalo
    var tilt = -0.26           // ~-15 grados en radianes

    // ── 1. Clip al óvalo inclinado ──────────────────────────────────────────
    ctx.save()
    ctx.beginPath()
    ctx.ellipse(cx, cy, rx, ry, tilt, 0, Math.PI * 2)
    ctx.clip()

    // Fondo oscuro interior
    ctx.fillStyle = "#050F05"
    ctx.fillRect(0, 0, w, h)

    // ── 2. Espiral: escalar contexto para transformar círculos en óvalo ──────
    // Trasladamos al centro, rotamos el tilt, escalamos X para que los arcos
    // circulares queden aplanados como el óvalo.
    ctx.save()
    ctx.translate(cx, cy)
    ctx.rotate(tilt)
    ctx.scale(rx / ry, 1.0)    // ry es el eje sin escalar (vertical)

    ctx.shadowColor = "#7FFF00"
    ctx.shadowBlur  = shadowBlur

    // 8 arcos concéntricos con opacidad y grosor crecientes hacia el exterior.
    // La variación de startAngle + i*offset produce el efecto de espiral.
    for (var i = 0; i < 8; i++) {
        var r          = ry * (0.12 + i * 0.105)
        var startAngle = angle + i * (Math.PI / 3.5)
        var arcSpan    = Math.PI * 1.4
        var brightness = 80 + Math.round((i / 7) * 175)
        var alpha      = 0.35 + (i / 7) * 0.65
        var lw         = (2.5 + i * 0.7) * (ry / rx)   // compensar escala X

        ctx.beginPath()
        ctx.arc(0, 0, r, startAngle, startAngle + arcSpan)
        ctx.strokeStyle = "rgba(" + Math.round(brightness * 0.45) + ","
                                  + brightness + ",0," + alpha + ")"
        ctx.lineWidth   = lw
        ctx.stroke()
    }

    // Centro luminoso
    ctx.beginPath()
    ctx.arc(0, 0, ry * 0.08, 0, Math.PI * 2)
    ctx.fillStyle = "rgba(200,255,100,0.6)"
    ctx.fill()

    ctx.restore()   // quitar translate/rotate/scale, mantener clip

    // ── 3. Destellos blancos ─────────────────────────────────────────────────
    // Posiciones fijas en coordenadas polares (radio normalizado 0-1, ángulo).
    // La opacidad pulsa con sin(angle * velocidad + offset_individual).
    var sparkles = [
        { r: 0.32, a: 0.20 }, { r: 0.61, a: 1.10 }, { r: 0.78, a: 2.30 },
        { r: 0.44, a: 3.50 }, { r: 0.69, a: 4.20 }, { r: 0.53, a: 5.10 },
        { r: 0.87, a: 0.80 }, { r: 0.25, a: 2.70 }, { r: 0.65, a: 3.90 },
        { r: 0.48, a: 5.80 }, { r: 0.73, a: 1.50 }, { r: 0.38, a: 4.80 }
    ]

    ctx.shadowColor = "white"
    ctx.shadowBlur  = 8

    for (var s = 0; s < sparkles.length; s++) {
        var sp      = sparkles[s]
        var sa      = sp.a + angle * 0.4          // orbitan lentamente
        var sx      = cx + Math.cos(sa) * sp.r * rx * 0.88
        var sy      = cy + Math.sin(sa) * sp.r * ry * 0.88
        var pulse   = (Math.sin(angle * 3.0 + s * 1.3) + 1.0) / 2.0
        var sAlpha  = 0.35 + pulse * 0.65
        var sRadius = 1.5 + pulse * 2.0

        ctx.beginPath()
        ctx.arc(sx, sy, sRadius, 0, Math.PI * 2)
        ctx.fillStyle = "rgba(255,255,255," + sAlpha + ")"
        ctx.fill()
    }

    ctx.restore()   // quitar clip

    // ── 4. Borde exterior del óvalo ──────────────────────────────────────────
    ctx.shadowColor = "#7FFF00"
    ctx.shadowBlur  = shadowBlur * 0.6
    ctx.beginPath()
    ctx.ellipse(cx, cy, rx, ry, tilt, 0, Math.PI * 2)
    ctx.strokeStyle = "#ADFF2F"
    ctx.lineWidth   = 3
    ctx.stroke()

    ctx.restore()   // globalAlpha
}

// -----------------------------------------------------------------------------
// applyReflectionGradient(ctx, w, h)
//
// Superpone un degradado negro de arriba (transparente) a abajo (opaco)
// para que el reflejo se desvanezca hacia el suelo.
// Llamar DESPUÉS de haber dibujado el portal invertido.
// -----------------------------------------------------------------------------
function applyReflectionGradient(ctx, w, h) {
    var grad = ctx.createLinearGradient(0, 0, 0, h)
    grad.addColorStop(0.0, "rgba(0,0,0,0)")    // arriba: visible
    grad.addColorStop(1.0, "rgba(0,0,0,1)")    // abajo: oculto
    ctx.fillStyle = grad
    ctx.fillRect(0, 0, w, h)
}
```

---

## Task 4: Crear `PortalCanvas.qml`

**Files:**
- Create: `examples/portal/PortalCanvas.qml`

El componente principal del portal. Contiene el `Canvas`, el `Timer` de animación y el `MouseArea` para click (abrir/cerrar).

- [ ] **Step 1: Crear `examples/portal/PortalCanvas.qml`**

```qml
// =============================================================================
// PortalCanvas.qml — Canvas principal del portal de Rick & Morty
// =============================================================================
// Dibuja el portal (espiral verde, glow, destellos) usando Canvas 2D.
// Delega el dibujo a portal_draw.js para compartir la lógica con
// ReflectionCanvas.
//
// API pública:
//   active      (bool)  — activa/desactiva el Timer (CPU off cuando no visible)
//   open        (bool)  — anima apertura/cierre del portal via scale
//   rotSpeed    (real)  — velocidad de rotación (incremento de angle por tick)
//   glowValue   (int)   — shadowBlur pasado a drawPortal (0–60)
//   hovered     (bool)  — true mientras el ratón está dentro (leído por Main)
// =============================================================================
import QtQuick
import utils
import "portal_draw.js" as Draw

Item {
    id: root

    // ── API pública ──────────────────────────────────────────────────────────
    property bool active:    false
    property bool open:      true
    property real rotSpeed:  0.025   // radianes por tick
    property int  glowValue: 30
    property bool hovered:   false

    // Expone el ángulo interno para que ReflectionCanvas lo sincronice
    // (los ids internos de un componente no son accesibles desde fuera)
    property alias angle: canvas.angle

    // ── Animación de apertura/cierre ─────────────────────────────────────────
    // scale va de 0 (cerrado) a 1 (abierto). OutBack da el "rebote" característico.
    scale: open ? 1.0 : 0.0
    Behavior on scale {
        NumberAnimation { duration: 600; easing.type: Easing.OutBack }
    }

    // ── Canvas ───────────────────────────────────────────────────────────────
    Canvas {
        id: canvas
        anchors.fill: parent
        onAvailableChanged: if (available) requestPaint()

        // Estado interno de animación
        property real angle: 0.0

        Timer {
            interval: 30
            repeat:   true
            running:  root.active
            onTriggered: {
                canvas.angle = canvas.angle + root.rotSpeed
                canvas.requestPaint()
            }
        }

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            Draw.drawPortal(ctx, width, height, canvas.angle, root.glowValue, 1.0)
        }
    }

    // ── MouseArea: click para abrir/cerrar ───────────────────────────────────
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked:             root.open   = !root.open
        onContainsMouseChanged: root.hovered = containsMouse
    }
}
```

---

## Task 5: Crear `ReflectionCanvas.qml`

**Files:**
- Create: `examples/portal/ReflectionCanvas.qml`

Dibuja el reflejo del portal: el mismo dibujo invertido verticalmente, con opacidad reducida y un degradado negro que lo desvanece hacia abajo.

- [ ] **Step 1: Crear `examples/portal/ReflectionCanvas.qml`**

```qml
// =============================================================================
// ReflectionCanvas.qml — Reflejo del portal en el suelo
// =============================================================================
// Replica el dibujo de portal_draw.js con ctx.scale(1,-1) para invertirlo,
// luego superpone un degradado negro para simular el desvanecimiento en el suelo.
//
// API pública:
//   angle       (real)  — ángulo de rotación actual (sincronizado con PortalCanvas)
//   glowValue   (int)   — shadowBlur (mismo valor que PortalCanvas)
//
// No tiene Timer propio: repinta reactivamente cuando cambia `angle`,
// que está enlazado al alias de PortalCanvas. Esto garantiza que el
// reflejo solo se actualiza cuando el portal lo hace.
// =============================================================================
import QtQuick
import "portal_draw.js" as Draw

Canvas {
    id: root

    property real angle:     0.0
    property int  glowValue: 30

    onAvailableChanged: if (available) requestPaint()
    onAngleChanged:     requestPaint()
    onGlowValueChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d")
        ctx.clearRect(0, 0, width, height)

        // Invertir verticalmente: transladar al borde inferior, escalar Y=-1
        // Así el "suelo" del portal queda arriba del canvas de reflejo,
        // que visualmente está debajo del canvas del portal.
        ctx.save()
        ctx.translate(0, height)
        ctx.scale(1, -1)
        Draw.drawPortal(ctx, width, height, root.angle, root.glowValue * 0.5, 0.35)
        ctx.restore()

        // Degradado de desvanecimiento: transparente arriba, negro abajo
        Draw.applyReflectionGradient(ctx, width, height)
    }
}
```

---

## Task 6: Crear `PortalControls.qml`

**Files:**
- Create: `examples/portal/PortalControls.qml`

Panel con dos sliders: velocidad de rotación e intensidad del glow.

- [ ] **Step 1: Crear `examples/portal/PortalControls.qml`**

```qml
// =============================================================================
// PortalControls.qml — Panel de controles del portal
// =============================================================================
// Expone dos propiedades de salida que Main.qml enlaza a PortalCanvas:
//   rotSpeed   — velocidad de rotación (incremento de angle por tick)
//   glowValue  — shadowBlur para el glow del Canvas
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root

    // ── Salidas ──────────────────────────────────────────────────────────────
    property real rotSpeed:  speedSlider.value
    property int  glowValue: glowSlider.value

    color:  Style.cardColor
    radius: Style.resize(8)
    implicitHeight: controlsLayout.implicitHeight + Style.resize(32)

    ColumnLayout {
        id: controlsLayout
        anchors {
            left:   parent.left
            right:  parent.right
            top:    parent.top
            margins: Style.resize(16)
        }
        spacing: Style.resize(12)

        // ── Velocidad ────────────────────────────────────────────────────────
        Label {
            text: "Velocidad de rotación"
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(12)

            Slider {
                id: speedSlider
                Layout.fillWidth: true
                from:  0.005    // muy lento
                to:    0.08     // rápido
                value: 0.025    // valor inicial
                stepSize: 0.001
            }

            Label {
                text: (speedSlider.value * 1000).toFixed(0) + " u/tick"
                font.pixelSize: Style.resize(12)
                color: Style.mainColor
                Layout.minimumWidth: Style.resize(70)
            }
        }

        // ── Glow ─────────────────────────────────────────────────────────────
        Label {
            text: "Intensidad del glow"
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(12)

            Slider {
                id: glowSlider
                Layout.fillWidth: true
                from:     0
                to:       60
                value:    30
                stepSize: 1
            }

            Label {
                text: glowSlider.value.toFixed(0)
                font.pixelSize: Style.resize(12)
                color: Style.mainColor
                Layout.minimumWidth: Style.resize(70)
            }
        }
    }
}
```

---

## Task 7: Crear `Main.qml` — ensamblaje final

**Files:**
- Create: `examples/portal/Main.qml`

Ensambla `PortalCanvas`, `ReflectionCanvas`, `MultiEffect` y `PortalControls`. El `MultiEffect` da el halo verde exterior. El `angle` del `PortalCanvas` se sincroniza con `ReflectionCanvas` a través de un binding.

- [ ] **Step 1: Crear `examples/portal/Main.qml`**

```qml
// =============================================================================
// Main.qml — Página "Portal Rick & Morty"
// =============================================================================
// Ensambla:
//   - PortalCanvas: espiral animada + destellos + glow interno (Canvas 2D)
//   - MultiEffect:  halo verde exterior (QtQuick.Effects, Qt 6.5+, nativo)
//   - ReflectionCanvas: reflejo invertido del portal
//   - PortalControls: sliders de velocidad y glow
//
// Patrón de visibilidad estándar del proyecto:
//   fullSize controla si el Timer del portal consume CPU.
//   opacity + visible con Behavior es el patrón animado del dashboard.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import utils

Item {
    id: root

    property bool fullSize: false

    // ── Patrón de visibilidad animada ────────────────────────────────────────
    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(24)

                // ── Título ───────────────────────────────────────────────────
                Label {
                    text: "Portal Rick & Morty"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                Label {
                    text: "Click en el portal para abrirlo o cerrarlo. Pasa el ratón por encima para intensificar el halo."
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                // ── Zona visual: portal + reflejo ────────────────────────────
                // Item contenedor de altura fija. El portal está en la mitad
                // superior y el reflejo en la mitad inferior.
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(500)

                    // Fondo negro para que el portal destaque
                    Rectangle {
                        anchors.fill: parent
                        color: "#050505"
                        radius: Style.resize(8)
                    }

                    // ── Halo exterior (MultiEffect detrás del portal) ─────────
                    // Se posiciona ligeramente más grande que el portal para
                    // que el blur "se derrame" fuera del borde del óvalo.
                    MultiEffect {
                        id: glowHalo
                        source: portalCanvas
                        anchors.centerIn: portalCanvas
                        width:  portalCanvas.width  + (controls.glowValue * 1.2)
                        height: portalCanvas.height + (controls.glowValue * 1.2)
                        blurEnabled: true
                        blurMax: controls.glowValue + (portalCanvas.hovered ? 16 : 0)
                        Behavior on blurMax {
                            NumberAnimation { duration: 200 }
                        }
                        opacity: 0.75
                        z: 0
                    }

                    // ── Portal (encima del halo) ─────────────────────────────
                    PortalCanvas {
                        id: portalCanvas
                        width:  Style.resize(260)
                        height: Style.resize(320)
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter:   parent.verticalCenter
                            verticalCenterOffset: Style.resize(-40)
                        }
                        active:    root.fullSize
                        rotSpeed:  controls.rotSpeed
                        glowValue: controls.glowValue
                        z: 1
                    }

                    // ── Reflejo (debajo del portal) ──────────────────────────
                    ReflectionCanvas {
                        id: reflectionCanvas
                        width:  portalCanvas.width
                        height: Style.resize(120)
                        anchors {
                            horizontalCenter: portalCanvas.horizontalCenter
                            top: portalCanvas.bottom
                        }
                        angle:     portalCanvas.angle    // alias expuesto en PortalCanvas
                        glowValue: controls.glowValue
                        z: 1
                    }
                }

                // ── Panel de controles ───────────────────────────────────────
                PortalControls {
                    id: controls
                    Layout.fillWidth: true
                }

                // Espaciado final
                Item { Layout.preferredHeight: Style.resize(20) }
            }
        }
    }
}
```

> **Nota:** `portalCanvas.angle` usa el `property alias angle: canvas.angle` añadido en Task 4. Esto es necesario porque en QML los `id` internos de un componente no son accesibles desde fuera de su fichero.

---

## Task 8: Verificación visual final

- [ ] **Step 1: Clean rebuild**

```bash
rm -rf build && cmake -B build -S . -DCMAKE_PREFIX_PATH="C:/Qt/6.11.0/msvc2022_64" && cmake --build build
```

Esperado: compilación sin errores ni warnings de módulo QML no encontrado.

- [ ] **Step 2: Ejecutar y verificar checklist visual**

```bash
./build/QMLSnippetsExamples.exe
```

Checklist:
- [ ] "Portal" aparece en el menú lateral con su icono
- [ ] Al hacer clic en "Portal", la página se carga con animación de opacidad (200ms)
- [ ] El portal verde gira continuamente sobre fondo negro
- [ ] Hay destellos blancos pulsantes dentro del óvalo
- [ ] Hay un halo verde difuso alrededor del óvalo
- [ ] Al pasar el ratón por el portal, el halo se intensifica
- [ ] Al hacer clic en el portal, se cierra con animación OutBack (rebote)
- [ ] Al hacer clic de nuevo, se abre con animación OutBack
- [ ] El reflejo aparece debajo del portal, invertido y desvaneciéndose
- [ ] Slider "Velocidad" cambia la velocidad de rotación en tiempo real
- [ ] Slider "Glow" cambia la intensidad del glow en tiempo real
- [ ] Al cambiar a otra página del menú y volver, el portal sigue animándose correctamente

- [ ] **Step 3: Commit final**

```bash
git add examples/portal/
git commit -m "feat: añadir página Portal Rick & Morty con Canvas 2D y MultiEffect"
```
