// =============================================================================
// MultiplaneScene.qml — Escena de cámara multiplano con animación atmosférica
// =============================================================================
// 9 capas apiladas:  3 de canvas dibujado  +  3 de neblina atmosférica  +  3 más.
//
// TÉCNICA CLAVE — Perspectiva aérea (aerial perspective):
//   Las capas de neblina son Rectangles con gradiente semitransparente colocados
//   a diferentes profundidades intermedias. Simulan la dispersión de la luz en la
//   atmósfera: los objetos lejanos aparecen más azulados y difusos.
//   Esto es el mismo principio que usan pintores desde el Renacimiento y es
//   el truco visual más efectivo para crear ilusión de profundidad en 2D.
//
// CAPAS:
//   z=0  depth=0.00   Cielo (Canvas animado: estrellas, luna, nubes)
//   z=1  depth=0.08   Neblina del horizonte (Rectangle gradiente)
//   z=2  depth=0.15   Montañas lejanas (Canvas)
//   z=3  depth=0.28   Neblina del valle (Rectangle gradiente)
//   z=4  depth=0.35   Colinas (Canvas)
//   z=5  depth=0.52   Niebla de la arboleda (Rectangle gradiente)
//   z=6  depth=0.60   Bosque (Canvas)
//   z=7  depth=0.85   Árboles cercanos + luciérnagas (Canvas animado)
//   z=8  depth=1.00   Primer plano con ramas (Canvas)
//
// ANIMACIÓN:
//   Un único Timer a ~30fps avanza 'sceneTime'. Los Canvas animados (cielo y
//   bosque cercano) escuchan onSceneTimeChanged para hacer requestPaint().
//   Cuando la página no está activa (active:false) el Timer se detiene.
// =============================================================================

import QtQuick

Item {
    id: sceneRoot

    // ── API pública ─────────────────────────────────────────────────────────
    property real cameraX:    0.0
    property real cameraY:    0.0
    property real cameraZoom: 1.0

    // active: se vincula a fullSize desde Main.qml para detener animaciones
    // cuando la página no es visible y liberar CPU.
    property bool active: true

    // ── Motor de animación ──────────────────────────────────────────────────
    property real sceneTime: 0.0

    Timer {
        id: sceneTimer
        interval:  33       // ~30 fps — suficiente para nubes y luciérnagas
        repeat:    true
        running:   sceneRoot.active
        onTriggered: sceneRoot.sceneTime += 0.033
    }

    clip: true  // imprescindible: las capas sobresalen del viewport

    // =========================================================================
    // CAPA 0 — Cielo nocturno  (depth=0.00)
    // =========================================================================
    // Fondo completamente estático en cuanto a paralaje y zoom.
    // Animado internamente: las nubes derivan suavemente.
    SceneLayer {
        depth:      0.00
        cameraX:    sceneRoot.cameraX
        cameraY:    sceneRoot.cameraY
        cameraZoom: sceneRoot.cameraZoom
        z: 0

        Canvas {
            id: skyCanvas
            anchors.fill: parent

            // Redibujar cada vez que avance el tiempo (para nubes animadas)
            property real t: sceneRoot.sceneTime
            onTChanged:          requestPaint()
            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height

                // ── Degradado de cielo nocturno ─────────────────────────
                var sky = ctx.createLinearGradient(0, 0, 0, h)
                sky.addColorStop(0.00, "#030610")
                sky.addColorStop(0.40, "#070d20")
                sky.addColorStop(0.75, "#0d1838")
                sky.addColorStop(1.00, "#121f4a")
                ctx.fillStyle = sky
                ctx.fillRect(0, 0, w, h)

                // ── Banda de la Vía Láctea (diagonal sutil) ─────────────
                var mw = ctx.createLinearGradient(w * 0.1, h * 0.0, w * 0.65, h * 0.8)
                mw.addColorStop(0.00, "rgba(80,  90, 160, 0.00)")
                mw.addColorStop(0.35, "rgba(90, 100, 180, 0.10)")
                mw.addColorStop(0.60, "rgba(80,  90, 160, 0.07)")
                mw.addColorStop(1.00, "rgba(80,  90, 160, 0.00)")
                ctx.fillStyle = mw
                ctx.fillRect(0, 0, w, h)

                // ── Estrellas fijas con brillo variable ──────────────────
                // Cada estrella: [xFrac, yFrac, radio, frecuencia de parpadeo, fase]
                var stars = [
                    [0.04, 0.06, 2.2, 1.3, 0.0], [0.09, 0.14, 1.5, 0.8, 1.2],
                    [0.15, 0.04, 1.8, 1.7, 2.5], [0.22, 0.18, 1.2, 1.1, 0.7],
                    [0.29, 0.08, 2.0, 0.9, 3.1], [0.36, 0.21, 1.5, 1.5, 1.8],
                    [0.42, 0.10, 1.0, 2.0, 0.4], [0.49, 0.06, 2.2, 0.7, 2.2],
                    [0.57, 0.16, 1.3, 1.4, 1.0], [0.63, 0.07, 1.8, 1.8, 3.4],
                    [0.70, 0.20, 1.2, 1.2, 0.6], [0.78, 0.05, 2.0, 0.6, 2.8],
                    [0.84, 0.13, 1.5, 1.6, 1.5], [0.90, 0.09, 1.0, 2.2, 0.2],
                    [0.95, 0.19, 1.8, 0.9, 3.7], [0.06, 0.30, 1.3, 1.1, 1.9],
                    [0.14, 0.36, 1.8, 1.5, 0.8], [0.20, 0.27, 1.0, 1.9, 2.6],
                    [0.28, 0.40, 2.0, 0.8, 1.3], [0.35, 0.33, 1.5, 1.3, 0.1],
                    [0.44, 0.38, 1.2, 1.7, 3.0], [0.52, 0.29, 1.8, 1.0, 2.4],
                    [0.60, 0.42, 1.0, 1.6, 0.9], [0.67, 0.34, 2.2, 0.7, 1.6],
                    [0.76, 0.38, 1.5, 1.4, 3.3], [0.83, 0.28, 1.0, 1.8, 0.5],
                    [0.91, 0.35, 1.8, 1.2, 2.1], [0.97, 0.42, 1.3, 0.9, 1.4],
                    [0.02, 0.45, 2.0, 1.5, 2.9], [0.33, 0.48, 1.2, 2.0, 0.3]
                ]
                for (var i = 0; i < stars.length; i++) {
                    var s  = stars[i]
                    var sx = s[0] * w, sy = s[1] * h, sr = s[2]
                    var sparkle = 0.65 + 0.35 * Math.sin(t * s[3] + s[4])
                    var sg = ctx.createRadialGradient(sx, sy, 0, sx, sy, sr * 3)
                    sg.addColorStop(0.0, "rgba(255,255,255," + (sparkle * 0.95).toFixed(2) + ")")
                    sg.addColorStop(0.4, "rgba(200,210,255," + (sparkle * 0.30).toFixed(2) + ")")
                    sg.addColorStop(1.0, "rgba(200,210,255,0.00)")
                    ctx.fillStyle = sg
                    ctx.beginPath()
                    ctx.arc(sx, sy, sr * 3, 0, Math.PI * 2)
                    ctx.fill()
                }

                // ── Luna con corona y fase ───────────────────────────────
                var mx = w * 0.72, my = h * 0.24

                // Corona exterior (resplandor difuso)
                var corona = ctx.createRadialGradient(mx, my, 22, mx, my, 100)
                corona.addColorStop(0.0, "rgba(240,245,200, 0.25)")
                corona.addColorStop(0.5, "rgba(180,200,240, 0.08)")
                corona.addColorStop(1.0, "rgba(100,130,220, 0.00)")
                ctx.fillStyle = corona
                ctx.beginPath()
                ctx.arc(mx, my, 100, 0, Math.PI * 2)
                ctx.fill()

                // Cuerpo de la luna
                ctx.fillStyle = "#e8ecce"
                ctx.beginPath()
                ctx.arc(mx, my, 26, 0, Math.PI * 2)
                ctx.fill()

                // Fase lunar: sombra que crea efecto creciente
                ctx.fillStyle = "#06091a"
                ctx.beginPath()
                ctx.arc(mx + 10, my - 4, 22, 0, Math.PI * 2)
                ctx.fill()

                // Cara visible restaurada
                ctx.fillStyle = "#e0e4c0"
                ctx.beginPath()
                ctx.arc(mx, my, 24, 0, Math.PI * 2)
                ctx.fill()

                // Cráteres (detalle)
                ctx.fillStyle = "rgba(0,0,0,0.12)"
                ctx.beginPath(); ctx.arc(mx - 6, my - 8, 4, 0, Math.PI * 2); ctx.fill()
                ctx.beginPath(); ctx.arc(mx + 9, my + 6, 3, 0, Math.PI * 2); ctx.fill()
                ctx.beginPath(); ctx.arc(mx - 2, my + 10, 2.5, 0, Math.PI * 2); ctx.fill()

                // ── Nubes nocturas animadas ──────────────────────────────
                // 3 nubes en posiciones que avanzan lentamente con el tiempo
                var cloudDefs = [
                    { baseX: 0.10, baseY: 0.38, speed: 0.006, size: 0.10, alpha: 0.10 },
                    { baseX: 0.45, baseY: 0.31, speed: 0.004, size: 0.14, alpha: 0.08 },
                    { baseX: 0.75, baseY: 0.42, speed: 0.007, size: 0.09, alpha: 0.09 }
                ]

                function drawCloud(cx, cy, sizeW, alpha) {
                    var sw = sizeW * w
                    var sh = sw * 0.38
                    var cg = ctx.createRadialGradient(cx, cy, 0, cx, cy, sw * 0.6)
                    cg.addColorStop(0.0, "rgba(160,175,230," + (alpha * 1.6).toFixed(3) + ")")
                    cg.addColorStop(0.5, "rgba(140,160,220," + (alpha).toFixed(3) + ")")
                    cg.addColorStop(1.0, "rgba(120,140,210,0.000)")
                    ctx.fillStyle = cg
                    ctx.beginPath()
                    ctx.ellipse(cx, cy, sw * 0.6, sh * 0.55, 0, 0, Math.PI * 2)
                    ctx.fill()
                    ctx.beginPath()
                    ctx.ellipse(cx - sw * 0.28, cy + sh * 0.10, sw * 0.38, sh * 0.40, 0, 0, Math.PI * 2)
                    ctx.fill()
                    ctx.beginPath()
                    ctx.ellipse(cx + sw * 0.32, cy + sh * 0.05, sw * 0.42, sh * 0.38, 0, 0, Math.PI * 2)
                    ctx.fill()
                }

                for (var ci = 0; ci < cloudDefs.length; ci++) {
                    var cd   = cloudDefs[ci]
                    // La nube avanza horizontalmente; cuando sale por la derecha vuelve por la izquierda
                    var cx0  = ((cd.baseX + t * cd.speed) % 1.2 - 0.1) * w
                    var cy0  = cd.baseY * h
                    drawCloud(cx0, cy0, cd.size, cd.alpha)
                }
            }
        }
    }

    // =========================================================================
    // CAPA 1 — Neblina del horizonte  (depth=0.08)
    // =========================================================================
    // Perspectiva aérea: el horizonte parece ligeramente azulado y difuso.
    // Rectangle con gradiente vertical en lugar de Canvas → muy barato de renderizar.
    SceneLayer {
        depth:      0.08
        cameraX:    sceneRoot.cameraX
        cameraY:    sceneRoot.cameraY
        cameraZoom: sceneRoot.cameraZoom
        z: 1

        Rectangle {
            anchors.fill: parent
            color:        "transparent"
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.00; color: "transparent" }
                GradientStop { position: 0.45; color: "#1a2a5c26" }  // rgba(26,42,92,0.15)
                GradientStop { position: 0.65; color: "#1e2e6840" }  // rgba(30,46,104,0.25)
                GradientStop { position: 0.80; color: "#1a2a5c1a" }  // rgba(26,42,92,0.10)
                GradientStop { position: 1.00; color: "transparent" }
            }
        }
    }

    // =========================================================================
    // CAPA 2 — Montañas lejanas  (depth=0.15)
    // =========================================================================
    SceneLayer {
        depth:      0.15
        cameraX:    sceneRoot.cameraX
        cameraY:    sceneRoot.cameraY
        cameraZoom: sceneRoot.cameraZoom
        z: 2

        Canvas {
            id: mountainCanvas
            anchors.fill: parent
            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                // ── Silueta de montañas lejanas ──────────────────────────
                // Tono índigo-violeta para reflejar la luz de la luna lejana
                var mGrad = ctx.createLinearGradient(0, h * 0.42, 0, h)
                mGrad.addColorStop(0.0, "#241250")
                mGrad.addColorStop(1.0, "#180e3c")
                ctx.fillStyle = mGrad
                ctx.beginPath()
                ctx.moveTo(0, h)
                ctx.lineTo(0, h * 0.66)
                ctx.bezierCurveTo(w*0.02, h*0.60, w*0.04, h*0.52, w*0.06, h*0.50)
                ctx.bezierCurveTo(w*0.08, h*0.48, w*0.10, h*0.54, w*0.12, h*0.56)
                ctx.bezierCurveTo(w*0.14, h*0.58, w*0.16, h*0.48, w*0.20, h*0.44)
                ctx.bezierCurveTo(w*0.23, h*0.40, w*0.25, h*0.46, w*0.28, h*0.50)
                ctx.bezierCurveTo(w*0.31, h*0.54, w*0.33, h*0.46, w*0.37, h*0.42)
                ctx.bezierCurveTo(w*0.40, h*0.38, w*0.43, h*0.44, w*0.46, h*0.48)
                ctx.bezierCurveTo(w*0.49, h*0.52, w*0.51, h*0.46, w*0.55, h*0.43)
                ctx.bezierCurveTo(w*0.58, h*0.40, w*0.61, h*0.46, w*0.65, h*0.50)
                ctx.bezierCurveTo(w*0.68, h*0.54, w*0.71, h*0.46, w*0.75, h*0.44)
                ctx.bezierCurveTo(w*0.78, h*0.42, w*0.81, h*0.50, w*0.84, h*0.54)
                ctx.bezierCurveTo(w*0.87, h*0.58, w*0.90, h*0.48, w*0.94, h*0.46)
                ctx.bezierCurveTo(w*0.97, h*0.44, w*0.98, h*0.52, w, h*0.55)
                ctx.lineTo(w, h)
                ctx.closePath()
                ctx.fill()

                // ── Nieve en los picos con efecto de luz lunar ───────────
                // Iluminación sutil: el lado derecho de los picos recibe la luna
                function snowPeak(px, py) {
                    var sg = ctx.createRadialGradient(px, py, 0, px, py, h * 0.06)
                    sg.addColorStop(0.0, "rgba(220,230,255, 0.45)")
                    sg.addColorStop(0.5, "rgba(180,195,240, 0.20)")
                    sg.addColorStop(1.0, "rgba(160,180,230, 0.00)")
                    ctx.fillStyle = sg
                    ctx.beginPath()
                    ctx.arc(px, py, h * 0.06, 0, Math.PI * 2)
                    ctx.fill()
                }
                snowPeak(w * 0.20, h * 0.44)
                snowPeak(w * 0.37, h * 0.42)
                snowPeak(w * 0.55, h * 0.43)
                snowPeak(w * 0.75, h * 0.44)
            }
        }
    }

    // =========================================================================
    // CAPA 3 — Neblina del valle  (depth=0.28)
    // =========================================================================
    // Banda de niebla horizontal en la zona de los valles.
    // Da sensación de que la escena tiene profundidad geográfica real.
    SceneLayer {
        depth:      0.28
        cameraX:    sceneRoot.cameraX
        cameraY:    sceneRoot.cameraY
        cameraZoom: sceneRoot.cameraZoom
        z: 3

        Rectangle {
            anchors.fill: parent
            color:        "transparent"
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.00; color: "transparent" }
                GradientStop { position: 0.58; color: "transparent" }
                GradientStop { position: 0.68; color: "#18253840" }  // banda de niebla
                GradientStop { position: 0.76; color: "#1825381a" }
                GradientStop { position: 1.00; color: "transparent" }
            }
        }
    }

    // =========================================================================
    // CAPA 4 — Colinas  (depth=0.35)
    // =========================================================================
    SceneLayer {
        depth:      0.35
        cameraX:    sceneRoot.cameraX
        cameraY:    sceneRoot.cameraY
        cameraZoom: sceneRoot.cameraZoom
        z: 4

        Canvas {
            id: hillCanvas
            anchors.fill: parent
            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                // ── Colinas traseras ─────────────────────────────────────
                var hGrad1 = ctx.createLinearGradient(0, h * 0.55, 0, h)
                hGrad1.addColorStop(0.0, "#0d1a2c")
                hGrad1.addColorStop(1.0, "#08101e")
                ctx.fillStyle = hGrad1
                ctx.beginPath()
                ctx.moveTo(0, h)
                ctx.lineTo(0, h * 0.70)
                ctx.bezierCurveTo(w*0.06, h*0.62, w*0.14, h*0.68, w*0.22, h*0.64)
                ctx.bezierCurveTo(w*0.30, h*0.60, w*0.38, h*0.54, w*0.45, h*0.58)
                ctx.bezierCurveTo(w*0.52, h*0.62, w*0.59, h*0.56, w*0.67, h*0.52)
                ctx.bezierCurveTo(w*0.74, h*0.48, w*0.82, h*0.56, w*0.90, h*0.60)
                ctx.bezierCurveTo(w*0.95, h*0.63, w*0.98, h*0.66, w, h*0.68)
                ctx.lineTo(w, h)
                ctx.closePath()
                ctx.fill()

                // ── Colinas delanteras (más oscuras, más cercanas) ────────
                var hGrad2 = ctx.createLinearGradient(0, h * 0.70, 0, h)
                hGrad2.addColorStop(0.0, "#0a1520")
                hGrad2.addColorStop(1.0, "#060e14")
                ctx.fillStyle = hGrad2
                ctx.beginPath()
                ctx.moveTo(0, h)
                ctx.lineTo(0, h * 0.82)
                ctx.bezierCurveTo(w*0.10, h*0.72, w*0.22, h*0.76, w*0.32, h*0.72)
                ctx.bezierCurveTo(w*0.42, h*0.68, w*0.50, h*0.74, w*0.60, h*0.72)
                ctx.bezierCurveTo(w*0.70, h*0.70, w*0.80, h*0.74, w*0.90, h*0.78)
                ctx.bezierCurveTo(w*0.95, h*0.80, w*0.98, h*0.79, w, h*0.80)
                ctx.lineTo(w, h)
                ctx.closePath()
                ctx.fill()
            }
        }
    }

    // =========================================================================
    // CAPA 5 — Niebla de la arboleda  (depth=0.52)
    // =========================================================================
    // Banco de niebla baja que se cuela entre los árboles.
    // Es la capa de neblina más visible y dramática.
    SceneLayer {
        depth:      0.52
        cameraX:    sceneRoot.cameraX
        cameraY:    sceneRoot.cameraY
        cameraZoom: sceneRoot.cameraZoom
        z: 5

        Rectangle {
            anchors.fill: parent
            color:        "transparent"
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.00; color: "transparent" }
                GradientStop { position: 0.68; color: "transparent" }
                GradientStop { position: 0.74; color: "#10203033" }  // niebla baja
                GradientStop { position: 0.80; color: "#0e1c2a4d" }  // más densa
                GradientStop { position: 0.88; color: "#0c182426" }
                GradientStop { position: 1.00; color: "transparent" }
            }
        }
    }

    // =========================================================================
    // CAPA 6 — Bosque lejano  (depth=0.60)
    // =========================================================================
    SceneLayer {
        depth:      0.60
        cameraX:    sceneRoot.cameraX
        cameraY:    sceneRoot.cameraY
        cameraZoom: sceneRoot.cameraZoom
        z: 6

        Canvas {
            id: forestCanvas
            anchors.fill: parent
            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                var groundY = h * 0.79

                // Tierra con gradiente
                var gGrad = ctx.createLinearGradient(0, groundY, 0, h)
                gGrad.addColorStop(0.0, "#080e08")
                gGrad.addColorStop(1.0, "#050a05")
                ctx.fillStyle = gGrad
                ctx.fillRect(0, groundY, w, h - groundY)

                // Árboles del bosque: mezcla de formas (cónicas y redondeadas)
                function drawFirTree(cx, baseY, th, tw) {
                    // Árbol de coníferas: 3 triángulos superpuestos
                    ctx.beginPath()
                    ctx.moveTo(cx, baseY - th)
                    ctx.lineTo(cx - tw * 0.30, baseY - th * 0.60)
                    ctx.lineTo(cx + tw * 0.30, baseY - th * 0.60)
                    ctx.closePath()
                    ctx.fill()
                    ctx.beginPath()
                    ctx.moveTo(cx, baseY - th * 0.68)
                    ctx.lineTo(cx - tw * 0.46, baseY - th * 0.30)
                    ctx.lineTo(cx + tw * 0.46, baseY - th * 0.30)
                    ctx.closePath()
                    ctx.fill()
                    ctx.beginPath()
                    ctx.moveTo(cx, baseY - th * 0.36)
                    ctx.lineTo(cx - tw * 0.60, baseY)
                    ctx.lineTo(cx + tw * 0.60, baseY)
                    ctx.closePath()
                    ctx.fill()
                    ctx.fillRect(cx - tw * 0.08, baseY, tw * 0.16, th * 0.20)
                }

                function drawRoundTree(cx, baseY, th, tw) {
                    // Árbol de hoja caduca: copa redondeada
                    ctx.beginPath()
                    ctx.ellipse(cx, baseY - th * 0.55, tw * 0.42, th * 0.50, 0, 0, Math.PI * 2)
                    ctx.fill()
                    ctx.fillRect(cx - tw * 0.08, baseY - th * 0.08, tw * 0.16, th * 0.28)
                }

                var fTrees = [
                    [0.03, 0.27, 0.060, true ], [0.08, 0.23, 0.052, false],
                    [0.13, 0.29, 0.066, true ], [0.18, 0.25, 0.058, false],
                    [0.24, 0.31, 0.070, true ], [0.30, 0.26, 0.060, true ],
                    [0.36, 0.33, 0.073, false], [0.42, 0.28, 0.062, true ],
                    [0.48, 0.30, 0.067, true ], [0.54, 0.25, 0.057, false],
                    [0.60, 0.32, 0.071, true ], [0.66, 0.27, 0.061, false],
                    [0.72, 0.29, 0.065, true ], [0.78, 0.31, 0.069, true ],
                    [0.84, 0.26, 0.058, false], [0.89, 0.28, 0.063, true ],
                    [0.94, 0.30, 0.067, true ], [0.98, 0.24, 0.054, false]
                ]

                ctx.fillStyle = "#0c1f0e"
                for (var i = 0; i < fTrees.length; i++) {
                    var ft = fTrees[i]
                    if (ft[3]) drawFirTree(ft[0]*w, groundY, ft[1]*h, ft[2]*w)
                    else       drawRoundTree(ft[0]*w, groundY, ft[1]*h, ft[2]*w)
                }
            }
        }
    }

    // =========================================================================
    // CAPA 7 — Árboles cercanos + luciérnagas animadas  (depth=0.85)
    // =========================================================================
    SceneLayer {
        depth:      0.85
        cameraX:    sceneRoot.cameraX
        cameraY:    sceneRoot.cameraY
        cameraZoom: sceneRoot.cameraZoom
        z: 7

        Canvas {
            id: nearTreeCanvas
            anchors.fill: parent

            // Redibujar con cada tick para animar luciérnagas
            property real t: sceneRoot.sceneTime
            onTChanged:           requestPaint()
            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                var groundY = h * 0.83

                // Tierra oscura
                var gGrad = ctx.createLinearGradient(0, groundY, 0, h)
                gGrad.addColorStop(0.0, "#050c06")
                gGrad.addColorStop(1.0, "#020503")
                ctx.fillStyle = gGrad
                ctx.fillRect(0, groundY, w, h - groundY)

                // ── Árboles grandes con copa estratificada ───────────────
                ctx.fillStyle = "#060e07"
                function drawLargeTree(cx, baseY, th, tw) {
                    // Capa 1: punta
                    ctx.beginPath()
                    ctx.moveTo(cx, baseY - th)
                    ctx.lineTo(cx - tw * 0.28, baseY - th * 0.65)
                    ctx.lineTo(cx + tw * 0.28, baseY - th * 0.65)
                    ctx.closePath()
                    ctx.fill()
                    // Capa 2
                    ctx.beginPath()
                    ctx.moveTo(cx, baseY - th * 0.72)
                    ctx.lineTo(cx - tw * 0.48, baseY - th * 0.40)
                    ctx.lineTo(cx + tw * 0.48, baseY - th * 0.40)
                    ctx.closePath()
                    ctx.fill()
                    // Capa 3 (base de la copa)
                    ctx.beginPath()
                    ctx.moveTo(cx, baseY - th * 0.46)
                    ctx.lineTo(cx - tw * 0.68, baseY - th * 0.10)
                    ctx.lineTo(cx + tw * 0.68, baseY - th * 0.10)
                    ctx.closePath()
                    ctx.fill()
                    // Capa 4 (falda inferior)
                    ctx.beginPath()
                    ctx.moveTo(cx, baseY - th * 0.22)
                    ctx.lineTo(cx - tw * 0.82, baseY + th * 0.05)
                    ctx.lineTo(cx + tw * 0.82, baseY + th * 0.05)
                    ctx.closePath()
                    ctx.fill()
                    // Tronco
                    var trunkH = th * 0.32
                    var trunkGrad = ctx.createLinearGradient(cx - tw*0.12, baseY, cx + tw*0.12, baseY)
                    trunkGrad.addColorStop(0.0, "#040804")
                    trunkGrad.addColorStop(0.4, "#060c06")
                    trunkGrad.addColorStop(1.0, "#040804")
                    ctx.fillStyle = trunkGrad
                    ctx.fillRect(cx - tw * 0.11, baseY, tw * 0.22, trunkH)
                    ctx.fillStyle = "#060e07"
                }

                var bigTrees = [
                    [0.05,  0.83, 0.52, 0.09],
                    [0.16,  0.83, 0.60, 0.11],
                    [0.28,  0.83, 0.55, 0.10],
                    [0.41,  0.83, 0.64, 0.12],
                    [0.54,  0.83, 0.58, 0.10],
                    [0.65,  0.83, 0.56, 0.10],
                    [0.76,  0.83, 0.62, 0.11],
                    [0.87,  0.83, 0.53, 0.09],
                    [0.96,  0.83, 0.50, 0.08]
                ]
                for (var ti = 0; ti < bigTrees.length; ti++) {
                    var bt = bigTrees[ti]
                    drawLargeTree(bt[0]*w, bt[1]*h, bt[2]*h, bt[3]*w)
                }

                // ── Luciérnagas animadas ──────────────────────────────────
                // Cada luciérnaga: [xBase, yBase, velocidadX, frecPulso, fase, radio]
                // Posición oscila suavemente con seno; brillo pulsa independientemente
                var fireflies = [
                    [0.12, 0.72, 0.020, 2.1, 0.0, 2.5],
                    [0.22, 0.68, 0.015, 1.6, 1.3, 2.0],
                    [0.35, 0.75, 0.025, 2.8, 2.6, 1.8],
                    [0.44, 0.70, 0.018, 1.9, 0.8, 2.2],
                    [0.52, 0.66, 0.022, 2.4, 3.2, 1.7],
                    [0.61, 0.73, 0.016, 1.7, 1.7, 2.3],
                    [0.70, 0.69, 0.024, 2.2, 2.1, 2.0],
                    [0.79, 0.74, 0.019, 1.8, 0.4, 1.9],
                    [0.88, 0.67, 0.021, 2.5, 3.0, 2.1],
                    [0.38, 0.64, 0.017, 2.0, 1.1, 1.8]
                ]

                for (var fi = 0; fi < fireflies.length; fi++) {
                    var ff   = fireflies[fi]
                    // Posición: oscilación lenta en x e y
                    var ffx  = (ff[0] + Math.sin(t * ff[2] * 2.0 + ff[4]) * 0.015) * w
                    var ffy  = (ff[1] + Math.sin(t * ff[2] * 1.3 + ff[4] + 1.0) * 0.010) * h
                    // Brillo: sólo valores positivos del seno (parpadeo orgánico)
                    var raw  = Math.sin(t * ff[3] + ff[4])
                    var glow = Math.max(0.0, raw * raw * raw)  // sólo 0-1, achatado
                    if (glow < 0.05) continue                  // apagada: no dibujar

                    var ffR  = ff[5]
                    // Halo exterior tenue
                    var halo = ctx.createRadialGradient(ffx, ffy, 0, ffx, ffy, ffR * 5)
                    halo.addColorStop(0.0, "rgba(160,255,130," + (glow * 0.70).toFixed(3) + ")")
                    halo.addColorStop(0.5, "rgba(100,230, 80," + (glow * 0.20).toFixed(3) + ")")
                    halo.addColorStop(1.0, "rgba( 60,200, 50, 0.000)")
                    ctx.fillStyle = halo
                    ctx.beginPath()
                    ctx.arc(ffx, ffy, ffR * 5, 0, Math.PI * 2)
                    ctx.fill()

                    // Núcleo brillante
                    var core = ctx.createRadialGradient(ffx, ffy, 0, ffx, ffy, ffR)
                    core.addColorStop(0.0, "rgba(230,255,200," + (glow * 0.98).toFixed(3) + ")")
                    core.addColorStop(1.0, "rgba(150,255,100," + (glow * 0.40).toFixed(3) + ")")
                    ctx.fillStyle = core
                    ctx.beginPath()
                    ctx.arc(ffx, ffy, ffR, 0, Math.PI * 2)
                    ctx.fill()
                }
            }
        }
    }

    // =========================================================================
    // CAPA 8 — Primer plano: ramas y viñeta  (depth=1.00)
    // =========================================================================
    SceneLayer {
        depth:      1.00
        cameraX:    sceneRoot.cameraX
        cameraY:    sceneRoot.cameraY
        cameraZoom: sceneRoot.cameraZoom
        z: 8

        Canvas {
            id: fgCanvas
            anchors.fill: parent
            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                // ── Masas de vegetación oscura en los bordes ──────────────
                ctx.fillStyle = "#020503"

                // Masa izquierda
                ctx.beginPath()
                ctx.moveTo(0, 0)
                ctx.lineTo(w * 0.16, 0)
                ctx.bezierCurveTo(w * 0.12, h * 0.14, w * 0.22, h * 0.24, w * 0.14, h * 0.36)
                ctx.bezierCurveTo(w * 0.08, h * 0.48, w * 0.20, h * 0.58, w * 0.10, h * 0.70)
                ctx.bezierCurveTo(w * 0.04, h * 0.80, w * 0.16, h * 0.90, w * 0.08, h)
                ctx.lineTo(0, h)
                ctx.closePath()
                ctx.fill()

                // Masa derecha
                ctx.beginPath()
                ctx.moveTo(w, 0)
                ctx.lineTo(w * 0.84, 0)
                ctx.bezierCurveTo(w * 0.88, h * 0.14, w * 0.78, h * 0.26, w * 0.86, h * 0.38)
                ctx.bezierCurveTo(w * 0.92, h * 0.50, w * 0.80, h * 0.60, w * 0.90, h * 0.72)
                ctx.bezierCurveTo(w * 0.96, h * 0.82, w * 0.84, h * 0.92, w * 0.92, h)
                ctx.lineTo(w, h)
                ctx.closePath()
                ctx.fill()

                // Franja de tierra inferior
                ctx.fillRect(0, h * 0.92, w, h * 0.08)

                // ── Ramas principales desde la izquierda ─────────────────
                ctx.strokeStyle = "#020503"
                ctx.lineCap    = "round"
                ctx.lineJoin   = "round"

                ctx.lineWidth = w * 0.024
                ctx.beginPath()
                ctx.moveTo(w * 0.14, h * 0.06)
                ctx.bezierCurveTo(w * 0.26, h * 0.01, w * 0.40, h * 0.08, w * 0.50, h * 0.12)
                ctx.stroke()

                ctx.lineWidth = w * 0.016
                ctx.beginPath()
                ctx.moveTo(w * 0.11, h * 0.20)
                ctx.bezierCurveTo(w * 0.22, h * 0.14, w * 0.34, h * 0.18, w * 0.42, h * 0.22)
                ctx.stroke()

                ctx.lineWidth = w * 0.011
                ctx.beginPath()
                ctx.moveTo(w * 0.13, h * 0.36)
                ctx.bezierCurveTo(w * 0.22, h * 0.30, w * 0.30, h * 0.34, w * 0.37, h * 0.38)
                ctx.stroke()

                // Ramita secundaria
                ctx.lineWidth = w * 0.007
                ctx.beginPath()
                ctx.moveTo(w * 0.30, h * 0.17)
                ctx.bezierCurveTo(w * 0.34, h * 0.10, w * 0.38, h * 0.13, w * 0.40, h * 0.07)
                ctx.stroke()

                // ── Ramas principales desde la derecha ────────────────────
                ctx.lineWidth = w * 0.022
                ctx.beginPath()
                ctx.moveTo(w * 0.86, h * 0.08)
                ctx.bezierCurveTo(w * 0.74, h * 0.03, w * 0.62, h * 0.10, w * 0.52, h * 0.14)
                ctx.stroke()

                ctx.lineWidth = w * 0.015
                ctx.beginPath()
                ctx.moveTo(w * 0.89, h * 0.23)
                ctx.bezierCurveTo(w * 0.78, h * 0.17, w * 0.66, h * 0.20, w * 0.58, h * 0.24)
                ctx.stroke()

                ctx.lineWidth = w * 0.010
                ctx.beginPath()
                ctx.moveTo(w * 0.87, h * 0.40)
                ctx.bezierCurveTo(w * 0.78, h * 0.35, w * 0.70, h * 0.38, w * 0.63, h * 0.42)
                ctx.stroke()

                // Ramita secundaria derecha
                ctx.lineWidth = w * 0.007
                ctx.beginPath()
                ctx.moveTo(w * 0.70, h * 0.19)
                ctx.bezierCurveTo(w * 0.66, h * 0.12, w * 0.62, h * 0.15, w * 0.60, h * 0.09)
                ctx.stroke()

                // ── Viñeta perimetral (oscurece los bordes del encuadre) ──
                // Simula la degradación óptica de un objetivo fotográfico real.
                var vig = ctx.createRadialGradient(w/2, h/2, h * 0.30, w/2, h/2, h * 0.82)
                vig.addColorStop(0.0, "rgba(0,0,0,0.00)")
                vig.addColorStop(0.7, "rgba(0,0,0,0.08)")
                vig.addColorStop(1.0, "rgba(0,0,0,0.50)")
                ctx.fillStyle = vig
                ctx.fillRect(0, 0, w, h)
            }
        }
    }
}
