# Diseño — Página "Portal Rick & Morty"

**Fecha:** 2026-04-06
**Estado:** Aprobado

---

## Objetivo

Crear una nueva página de ejemplo (`examples/portal/`) que recrea el portal de Rick & Morty usando Canvas 2D con JavaScript y componentes Qt 6 nativos. La página demuestra animación en tiempo real, composición de capas, efectos visuales y diseño interactivo en QML.

---

## Módulo QML

| Campo | Valor |
|---|---|
| URI | `portal` |
| Library name | `portalplugin` |
| Link target | `portalpluginplugin` |
| Directorio | `examples/portal/` |
| Archivos principales | `Main.qml`, `PortalCanvas.qml`, `ReflectionCanvas.qml`, `PortalControls.qml` |

Sigue el patrón estándar del proyecto:
- `CMakeLists.txt` con `qt_add_library(portalplugin STATIC)` + `qt_add_qml_module()`
- `qmldir` con `module portal`
- `Main.qml` con `property bool fullSize` + patrón de visibilidad animada
- Añadir `add_subdirectory(portal)` en `examples/CMakeLists.txt`
- Añadir `portalpluginplugin` en `target_link_libraries` en `/qmlmodules`
- Añadir entrada en `MainMenuList.qml` y wiring en `Dashboard.qml`
- Icono PNG en `imports/assets/icons/portal.png` (25×26 px, RGBA, color teal `#00D1A9`, patrón del proyecto)

---

## Layout de la página

```
┌─────────────────────────────────────────┐
│  Portal Rick & Morty          [título]  │
│                                         │
│         ╭─────────────╮                 │
│        /   [portal]    \   ← PortalCanvas (Canvas + MultiEffect)
│        \               /                │
│         ╰─────────────╯                 │
│         ╰─────────────╯  ← ReflectionCanvas (espejo degradado)
│                                         │
│  ┌──────────────────────────────────┐   │
│  │  Velocidad  ──────●──────        │   │
│  │  Glow       ────●────────        │   │
│  └──────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

Dos zonas verticales en un `ColumnLayout`:
1. **Zona visual**: portal + reflejo centrados en un `Item` de altura fija
2. **Zona controles**: `PortalControls.qml` con los sliders

---

## Arquitectura de capas (de abajo a arriba)

```
Item (zona visual)
  ├── ReflectionCanvas   z: 0  ← reflejo bajo el eje
  ├── PortalCanvas       z: 1  ← espiral + destellos
  └── MultiEffect        z: 2  ← halo exterior sobre PortalCanvas
```

### PortalCanvas (`Canvas`)

Dibuja en cada frame mediante `Timer`:

1. **Forma ovalada inclinada:** El portal tiene una leve rotación (~15°) aplicada con `transform: Rotation` sobre el Canvas.
2. **Espiral verde:** Serie de arcos `ctx.arc()` concéntricos a distintos radios, rotando con `angle` que incrementa cada tick. Color base `#7FFF00` con variaciones de opacidad.
3. **Glow interno:** `ctx.shadowColor = "#ADFF2F"` + `ctx.shadowBlur` controlado por slider.
4. **Destellos blancos:** Array de partículas con posición polar aleatoria, `globalAlpha` pulsante senoidal, dibujadas como pequeños círculos blancos.
5. **Apertura/cierre:** propiedad `open: bool` que anima `scale` de 0.0 a 1.0 con `NumberAnimation { duration: 600; easing.type: Easing.OutBack }`.

### ReflectionCanvas (`Canvas`)

- Mismo tamaño que `PortalCanvas`, posicionado justo debajo del eje.
- Tanto `PortalCanvas` como `ReflectionCanvas` llaman a una función JS compartida `drawPortal(ctx, angle, shadowBlur, opacity)` definida en un archivo `.js` del módulo. Esto evita duplicar la lógica de dibujo.
- `ReflectionCanvas` aplica `ctx.translate(0, height)` + `ctx.scale(1, -1)` antes de llamar a `drawPortal`, y pasa `opacity: 0.35` para que el reflejo sea más tenue.
- Superpone un degradado `createLinearGradient` de `rgba(0,0,0,0)` (arriba) → `rgba(0,0,0,1)` (abajo) para que el reflejo se desvanezca hacia el suelo.
- Se actualiza en el mismo `Timer` que `PortalCanvas`.

### MultiEffect (halo exterior)

```qml
import QtQuick.Effects

MultiEffect {
    source: portalCanvas
    blurEnabled: true
    blurMax: 32          // controlado por slider de glow
    colorization: 1.0
    colorizationColor: "#7FFF00"
}
```

Envuelve `PortalCanvas` para producir el halo verde difuso exterior sin Qt5Compat.

---

## Interacción

| Acción | Efecto |
|---|---|
| Click en el portal | Invierte `open` → anima `scale` 0↔1 con `Easing.OutBack` |
| Hover (MouseArea) | `blurMax` pasa de su valor base (slider) a `base + 16` al entrar; vuelve al valor base al salir |
| Slider "Velocidad" | Controla `Timer.interval` entre 16ms (rápido) y 100ms (lento) |
| Slider "Glow" | Controla `ctx.shadowBlur` entre 0 y 60 |

---

## Estado inicial

- Portal visible y abierto al cargar la página (`open: true`)
- Velocidad: valor medio (~40ms interval)
- Glow: valor medio (~30 shadowBlur)

---

## Control de CPU

`PortalCanvas` y `ReflectionCanvas` reciben `active: root.fullSize`. El `Timer` solo corre cuando `active === true`, siguiendo el patrón del proyecto (igual que `AnalogClock`, `RadarSweep`, etc.).

---

## Requisitos Qt

- Qt 6.5+ para `QtQuick.Effects` con `MultiEffect`
- Sin dependencia de `Qt5Compat.GraphicalEffects`
- Qt 6.11 del usuario cumple el requisito
