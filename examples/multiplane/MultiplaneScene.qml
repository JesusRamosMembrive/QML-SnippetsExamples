// =============================================================================
// MultiplaneScene.qml — Escena completa de cámara multiplano
// =============================================================================
// Compone 6 capas Canvas apiladas (z-order 0→5) con profundidades distintas.
// Cada capa recibe binding a las propiedades de la cámara virtual.
//
// Capas (de más lejana a más cercana):
//   0. Cielo        depth=0.00  → fondo estático, degradado de noche
//   1. Montañas     depth=0.15  → siluetas de picos lejanos
//   2. Colinas      depth=0.35  → colinas onduladas
//   3. Bosque       depth=0.60  → árboles triangulares
//   4. Árboles      depth=0.85  → árboles grandes con troncos
//   5. Primer plano depth=1.00  → ramas que enmarcan la escena
//
// Decisión de diseño: las capas usan Canvas (dibujo 2D) para que la demo
// sea completamente autocontenida sin assets externos. Los datos de forma
// se expresan como fracciones de ancho/alto para ser independientes del
// tamaño de la escena.
// =============================================================================

import QtQuick

Item {
    id: root

    // ── API pública: estado de la cámara virtual ───────────────────────────
    property real cameraX:    0.0
    property real cameraY:    0.0
    property real cameraZoom: 1.0

    // clip: true es fundamental. Las capas sobresalen 30% por cada lado
    // (son 1.6× el tamaño) y sin clip se dibujarían fuera de la escena.
    clip: true

    // =========================================================================
    // CAPA 0 — Cielo (depth=0.00, completamente estática)
    // =========================================================================
    // depth=0 → parallaxFactor=0, scaleResponse=0 → no se mueve ni escala.
    // Esta capa simula un fondo "infinitamente lejano".
    // Contiene: degradado de noche, resplandor de luna y estrellas fijas.
    SceneLayer {
        id: skyLayer
        depth:       0.00
        cameraX:     root.cameraX
        cameraY:     root.cameraY
        cameraZoom:  root.cameraZoom
        z: 0

        Canvas {
            id: skyCanvas
            anchors.fill: parent
            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height

                // Degradado de cielo nocturno (arriba oscuro → horizonte más claro)
                var skyGrad = ctx.createLinearGradient(0, 0, 0, h)
                skyGrad.addColorStop(0.00, "#080820")
                skyGrad.addColorStop(0.55, "#111840")
                skyGrad.addColorStop(1.00, "#1e2860")
                ctx.fillStyle = skyGrad
                ctx.fillRect(0, 0, w, h)

                // Resplandor difuso de la luna (gradiente radial)
                var moonX = w * 0.72
                var moonY = h * 0.22
                var moonGlow = ctx.createRadialGradient(moonX, moonY, 18, moonX, moonY, 90)
                moonGlow.addColorStop(0.0, "rgba(255, 255, 210, 0.35)")
                moonGlow.addColorStop(1.0, "rgba(255, 255, 210, 0.00)")
                ctx.fillStyle = moonGlow
                ctx.beginPath()
                ctx.arc(moonX, moonY, 90, 0, Math.PI * 2)
                ctx.fill()

                // Disco de la luna
                ctx.fillStyle = "#f8f8e0"
                ctx.beginPath()
                ctx.arc(moonX, moonY, 24, 0, Math.PI * 2)
                ctx.fill()
                // Sombra sutil en la luna (crescent hint)
                ctx.fillStyle = "#d0d0b0"
                ctx.beginPath()
                ctx.arc(moonX - 6, moonY - 4, 18, 0, Math.PI * 2)
                ctx.fill()
                // Volver a dibujar el blanco sobre la sombra
                ctx.fillStyle = "#f8f8e0"
                ctx.beginPath()
                ctx.arc(moonX + 2, moonY, 22, 0, Math.PI * 2)
                ctx.fill()

                // Estrellas (posiciones fijas, variedad de tamaños)
                var stars = [
                    [0.04, 0.06, 2.0], [0.10, 0.13, 1.5], [0.17, 0.04, 1.0],
                    [0.23, 0.17, 1.5], [0.30, 0.08, 2.0], [0.38, 0.20, 1.0],
                    [0.44, 0.10, 1.5], [0.51, 0.05, 2.0], [0.58, 0.15, 1.0],
                    [0.64, 0.07, 1.5], [0.80, 0.12, 2.0], [0.88, 0.06, 1.5],
                    [0.94, 0.18, 1.0], [0.97, 0.08, 1.5], [0.06, 0.28, 1.0],
                    [0.14, 0.32, 2.0], [0.20, 0.25, 1.5], [0.27, 0.35, 1.0],
                    [0.34, 0.29, 1.5], [0.42, 0.38, 1.0], [0.49, 0.28, 2.0],
                    [0.56, 0.34, 1.5], [0.62, 0.25, 1.0], [0.78, 0.30, 1.5],
                    [0.85, 0.22, 2.0], [0.91, 0.36, 1.0], [0.02, 0.42, 1.5],
                    [0.33, 0.44, 1.0], [0.67, 0.40, 2.0], [0.96, 0.45, 1.5]
                ]
                for (var i = 0; i < stars.length; i++) {
                    var sx = stars[i][0] * w
                    var sy = stars[i][1] * h
                    var sr = stars[i][2]
                    // Brillo: gradiente radial de cada estrella
                    var starGlow = ctx.createRadialGradient(sx, sy, 0, sx, sy, sr * 2.5)
                    starGlow.addColorStop(0.0, "rgba(255, 255, 255, 0.9)")
                    starGlow.addColorStop(1.0, "rgba(255, 255, 255, 0.0)")
                    ctx.fillStyle = starGlow
                    ctx.beginPath()
                    ctx.arc(sx, sy, sr * 2.5, 0, Math.PI * 2)
                    ctx.fill()
                }
            }
        }
    }

    // =========================================================================
    // CAPA 1 — Montañas lejanas (depth=0.15, movimiento muy sutil)
    // =========================================================================
    // parallaxFactor ≈ 0.058  →  por cada 100px de paneo, se mueve ~5.8px
    // scaleResponse  ≈ 0.058  →  zoom apenas perceptible en esta capa
    SceneLayer {
        id: mountainLayer
        depth:      0.15
        cameraX:    root.cameraX
        cameraY:    root.cameraY
        cameraZoom: root.cameraZoom
        z: 1

        Canvas {
            id: mountainCanvas
            anchors.fill: parent
            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                // Silueta de montañas lejanas (tono azul-violeta oscuro)
                ctx.fillStyle = "#1a1040"
                ctx.beginPath()
                ctx.moveTo(0, h)
                ctx.lineTo(0,           h * 0.68)
                ctx.lineTo(w * 0.05,    h * 0.54)
                ctx.lineTo(w * 0.10,    h * 0.62)
                ctx.lineTo(w * 0.16,    h * 0.48)
                ctx.lineTo(w * 0.21,    h * 0.56)
                ctx.lineTo(w * 0.27,    h * 0.44)
                ctx.lineTo(w * 0.33,    h * 0.52)
                ctx.lineTo(w * 0.38,    h * 0.42)
                ctx.lineTo(w * 0.44,    h * 0.50)
                ctx.lineTo(w * 0.50,    h * 0.46)
                ctx.lineTo(w * 0.56,    h * 0.55)
                ctx.lineTo(w * 0.62,    h * 0.43)
                ctx.lineTo(w * 0.68,    h * 0.50)
                ctx.lineTo(w * 0.74,    h * 0.47)
                ctx.lineTo(w * 0.80,    h * 0.56)
                ctx.lineTo(w * 0.85,    h * 0.48)
                ctx.lineTo(w * 0.90,    h * 0.57)
                ctx.lineTo(w * 0.95,    h * 0.52)
                ctx.lineTo(w,           h * 0.60)
                ctx.lineTo(w, h)
                ctx.closePath()
                ctx.fill()

                // Nieve en los picos (franja blanca muy sutil)
                ctx.fillStyle = "rgba(200, 210, 240, 0.25)"
                ctx.beginPath()
                ctx.moveTo(w * 0.16,  h * 0.48)
                ctx.lineTo(w * 0.13,  h * 0.53)
                ctx.lineTo(w * 0.19,  h * 0.53)
                ctx.closePath()
                ctx.fill()
                ctx.beginPath()
                ctx.moveTo(w * 0.27,  h * 0.44)
                ctx.lineTo(w * 0.24,  h * 0.49)
                ctx.lineTo(w * 0.30,  h * 0.49)
                ctx.closePath()
                ctx.fill()
                ctx.beginPath()
                ctx.moveTo(w * 0.62,  h * 0.43)
                ctx.lineTo(w * 0.59,  h * 0.48)
                ctx.lineTo(w * 0.65,  h * 0.48)
                ctx.closePath()
                ctx.fill()
            }
        }
    }

    // =========================================================================
    // CAPA 2 — Colinas (depth=0.35, movimiento moderado)
    // =========================================================================
    // parallaxFactor ≈ 0.207  →  por cada 100px de paneo, se mueve ~20.7px
    // scaleResponse  ≈ 0.207
    SceneLayer {
        id: hillLayer
        depth:      0.35
        cameraX:    root.cameraX
        cameraY:    root.cameraY
        cameraZoom: root.cameraZoom
        z: 2

        Canvas {
            id: hillCanvas
            anchors.fill: parent
            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                // Colinas onduladas (Bézier cúbico para curvas naturales)
                ctx.fillStyle = "#0c1828"
                ctx.beginPath()
                ctx.moveTo(0, h)
                ctx.lineTo(0, h * 0.74)
                ctx.bezierCurveTo(w * 0.08, h * 0.60, w * 0.16, h * 0.72, w * 0.22, h * 0.68)
                ctx.bezierCurveTo(w * 0.28, h * 0.64, w * 0.34, h * 0.56, w * 0.40, h * 0.62)
                ctx.bezierCurveTo(w * 0.46, h * 0.68, w * 0.52, h * 0.60, w * 0.58, h * 0.58)
                ctx.bezierCurveTo(w * 0.64, h * 0.56, w * 0.70, h * 0.64, w * 0.76, h * 0.66)
                ctx.bezierCurveTo(w * 0.82, h * 0.68, w * 0.90, h * 0.62, w * 0.96, h * 0.66)
                ctx.bezierCurveTo(w * 0.98, h * 0.67, w, h * 0.68, w, h * 0.70)
                ctx.lineTo(w, h)
                ctx.closePath()
                ctx.fill()

                // Segunda colina superpuesta para dar volumen
                ctx.fillStyle = "#0a1520"
                ctx.beginPath()
                ctx.moveTo(0, h)
                ctx.lineTo(0, h * 0.82)
                ctx.bezierCurveTo(w * 0.10, h * 0.72, w * 0.22, h * 0.78, w * 0.30, h * 0.74)
                ctx.bezierCurveTo(w * 0.38, h * 0.70, w * 0.46, h * 0.76, w * 0.54, h * 0.74)
                ctx.bezierCurveTo(w * 0.62, h * 0.72, w * 0.72, h * 0.76, w * 0.82, h * 0.78)
                ctx.bezierCurveTo(w * 0.90, h * 0.80, w * 0.96, h * 0.76, w, h * 0.78)
                ctx.lineTo(w, h)
                ctx.closePath()
                ctx.fill()
            }
        }
    }

    // =========================================================================
    // CAPA 3 — Bosque lejano (depth=0.60, movimiento notable)
    // =========================================================================
    // parallaxFactor ≈ 0.465  →  por cada 100px, se mueve ~46.5px
    // scaleResponse  ≈ 0.465
    SceneLayer {
        id: forestLayer
        depth:      0.60
        cameraX:    root.cameraX
        cameraY:    root.cameraY
        cameraZoom: root.cameraZoom
        z: 3

        Canvas {
            id: forestCanvas
            anchors.fill: parent
            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                var groundY = h * 0.78

                // Franja de tierra
                ctx.fillStyle = "#081208"
                ctx.fillRect(0, groundY, w, h - groundY)

                // Función auxiliar: árbol triangular simple
                function drawTree(cx, baseY, treeH, treeW) {
                    ctx.beginPath()
                    ctx.moveTo(cx, baseY - treeH)
                    ctx.lineTo(cx - treeW * 0.5, baseY)
                    ctx.lineTo(cx + treeW * 0.5, baseY)
                    ctx.closePath()
                    ctx.fill()
                    // Tronco
                    ctx.fillRect(cx - treeW * 0.07, baseY, treeW * 0.14, treeH * 0.22)
                }

                ctx.fillStyle = "#0a1f0a"
                var forestTrees = [
                    [0.03, 0.26, 0.060], [0.08, 0.22, 0.052], [0.13, 0.28, 0.065],
                    [0.19, 0.24, 0.058], [0.24, 0.30, 0.068], [0.30, 0.25, 0.060],
                    [0.36, 0.32, 0.072], [0.42, 0.27, 0.062], [0.48, 0.29, 0.066],
                    [0.54, 0.26, 0.060], [0.60, 0.31, 0.070], [0.66, 0.24, 0.056],
                    [0.72, 0.28, 0.064], [0.78, 0.30, 0.068], [0.84, 0.25, 0.058],
                    [0.89, 0.27, 0.062], [0.94, 0.29, 0.066], [0.98, 0.23, 0.054]
                ]
                for (var i = 0; i < forestTrees.length; i++) {
                    var t = forestTrees[i]
                    drawTree(t[0] * w, groundY, t[1] * h, t[2] * w)
                }
            }
        }
    }

    // =========================================================================
    // CAPA 4 — Árboles cercanos (depth=0.85, movimiento fuerte)
    // =========================================================================
    // parallaxFactor ≈ 0.784  →  por cada 100px, se mueve ~78.4px
    // scaleResponse  ≈ 0.784
    SceneLayer {
        id: treeLayer
        depth:      0.85
        cameraX:    root.cameraX
        cameraY:    root.cameraY
        cameraZoom: root.cameraZoom
        z: 4

        Canvas {
            id: treeCanvas
            anchors.fill: parent
            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                var groundY = h * 0.82

                // Tierra oscura
                ctx.fillStyle = "#050e05"
                ctx.fillRect(0, groundY, w, h - groundY)

                // Árboles con copa en tres capas superpuestas (más detalle)
                ctx.fillStyle = "#061406"
                function drawLargeTree(cx, baseY, treeH, treeW) {
                    // Nivel superior (punta)
                    ctx.beginPath()
                    ctx.moveTo(cx, baseY - treeH)
                    ctx.lineTo(cx - treeW * 0.42, baseY - treeH * 0.55)
                    ctx.lineTo(cx + treeW * 0.42, baseY - treeH * 0.55)
                    ctx.closePath()
                    ctx.fill()
                    // Nivel medio
                    ctx.beginPath()
                    ctx.moveTo(cx, baseY - treeH * 0.62)
                    ctx.lineTo(cx - treeW * 0.62, baseY - treeH * 0.28)
                    ctx.lineTo(cx + treeW * 0.62, baseY - treeH * 0.28)
                    ctx.closePath()
                    ctx.fill()
                    // Nivel inferior (la más ancha)
                    ctx.beginPath()
                    ctx.moveTo(cx, baseY - treeH * 0.35)
                    ctx.lineTo(cx - treeW * 0.80, baseY)
                    ctx.lineTo(cx + treeW * 0.80, baseY)
                    ctx.closePath()
                    ctx.fill()
                    // Tronco
                    ctx.fillRect(cx - treeW * 0.10, baseY, treeW * 0.20, treeH * 0.30)
                }

                var bigTrees = [
                    [0.06,  0.82, 0.50, 0.08],
                    [0.18,  0.82, 0.58, 0.10],
                    [0.32,  0.82, 0.54, 0.09],
                    [0.47,  0.82, 0.62, 0.11],
                    [0.60,  0.82, 0.56, 0.10],
                    [0.73,  0.82, 0.52, 0.09],
                    [0.85,  0.82, 0.60, 0.10],
                    [0.95,  0.82, 0.50, 0.08]
                ]
                for (var i = 0; i < bigTrees.length; i++) {
                    var t = bigTrees[i]
                    drawLargeTree(t[0] * w, t[1] * h, t[2] * h, t[3] * w)
                }
            }
        }
    }

    // =========================================================================
    // CAPA 5 — Primer plano (depth=1.00, movimiento máximo)
    // =========================================================================
    // parallaxFactor = 1.00 → se mueve exactamente igual que la cámara.
    // scaleResponse  = 1.00 → el zoom afecta esta capa al máximo.
    //
    // Contenido: ramas y vegetación que enmarcan los bordes de la escena.
    // El centro permanece transparente para ver las capas de fondo.
    SceneLayer {
        id: foregroundLayer
        depth:      1.00
        cameraX:    root.cameraX
        cameraY:    root.cameraY
        cameraZoom: root.cameraZoom
        z: 5

        Canvas {
            id: fgCanvas
            anchors.fill: parent
            Component.onCompleted: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                var w = width, h = height
                ctx.clearRect(0, 0, w, h)

                ctx.fillStyle = "#030803"

                // ── Masa de vegetación izquierda ─────────────────────────
                ctx.beginPath()
                ctx.moveTo(0, 0)
                ctx.lineTo(w * 0.14, 0)
                ctx.bezierCurveTo(w * 0.10, h * 0.12, w * 0.20, h * 0.20, w * 0.12, h * 0.32)
                ctx.bezierCurveTo(w * 0.06, h * 0.44, w * 0.18, h * 0.55, w * 0.08, h * 0.68)
                ctx.bezierCurveTo(w * 0.02, h * 0.78, w * 0.14, h * 0.88, w * 0.06, h)
                ctx.lineTo(0, h)
                ctx.closePath()
                ctx.fill()

                // ── Masa de vegetación derecha ────────────────────────────
                ctx.beginPath()
                ctx.moveTo(w, 0)
                ctx.lineTo(w * 0.86, 0)
                ctx.bezierCurveTo(w * 0.90, h * 0.12, w * 0.80, h * 0.22, w * 0.88, h * 0.34)
                ctx.bezierCurveTo(w * 0.94, h * 0.46, w * 0.82, h * 0.56, w * 0.92, h * 0.70)
                ctx.bezierCurveTo(w * 0.98, h * 0.80, w * 0.86, h * 0.90, w * 0.94, h)
                ctx.lineTo(w, h)
                ctx.closePath()
                ctx.fill()

                // ── Franja de tierra en la base ────────────────────────────
                ctx.fillRect(0, h * 0.91, w, h * 0.09)

                // ── Ramas horizontales desde la izquierda ─────────────────
                ctx.strokeStyle = "#030803"
                ctx.lineCap = "round"

                ctx.lineWidth = w * 0.020
                ctx.beginPath()
                ctx.moveTo(w * 0.13, h * 0.08)
                ctx.bezierCurveTo(w * 0.28, h * 0.04, w * 0.42, h * 0.10, w * 0.50, h * 0.14)
                ctx.stroke()

                ctx.lineWidth = w * 0.014
                ctx.beginPath()
                ctx.moveTo(w * 0.10, h * 0.22)
                ctx.bezierCurveTo(w * 0.24, h * 0.17, w * 0.36, h * 0.22, w * 0.44, h * 0.26)
                ctx.stroke()

                ctx.lineWidth = w * 0.010
                ctx.beginPath()
                ctx.moveTo(w * 0.12, h * 0.38)
                ctx.bezierCurveTo(w * 0.22, h * 0.34, w * 0.32, h * 0.38, w * 0.38, h * 0.41)
                ctx.stroke()

                // ── Ramas horizontales desde la derecha ───────────────────
                ctx.lineWidth = w * 0.018
                ctx.beginPath()
                ctx.moveTo(w * 0.87, h * 0.10)
                ctx.bezierCurveTo(w * 0.72, h * 0.06, w * 0.60, h * 0.12, w * 0.52, h * 0.16)
                ctx.stroke()

                ctx.lineWidth = w * 0.013
                ctx.beginPath()
                ctx.moveTo(w * 0.90, h * 0.25)
                ctx.bezierCurveTo(w * 0.76, h * 0.20, w * 0.64, h * 0.24, w * 0.56, h * 0.28)
                ctx.stroke()

                ctx.lineWidth = w * 0.009
                ctx.beginPath()
                ctx.moveTo(w * 0.88, h * 0.42)
                ctx.bezierCurveTo(w * 0.78, h * 0.38, w * 0.68, h * 0.40, w * 0.62, h * 0.44)
                ctx.stroke()
            }
        }
    }
}
