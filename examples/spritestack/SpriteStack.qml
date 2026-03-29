// =============================================================================
// SpriteStack.qml — Renderizado 3D ilusorio por apilamiento de rodajas 2D
// =============================================================================
// Implementa la técnica "Sprite Stacking" usada en juegos indie (Minit, etc.):
//
//   1. Se dibuja el mismo objeto 2D N veces (sliceCount rodajas).
//   2. Cada rodaja está desplazada 'sliceSpacing' píxeles hacia arriba en Y.
//   3. TODAS las rodajas se rotan con el MISMO ángulo (stackRotation).
//   4. El cerebro interpreta la secuencia de formas rotadas como un objeto 3D.
//
// MATEMÁTICAS:
//
//   Por cada rodaja i (i=0 → base, i=sliceCount-1 → cima):
//     t       = i / (sliceCount - 1)           altura normalizada [0, 1]
//     sliceY  = baseCenterY − i × sliceSpacing  posición vertical en pantalla
//
//   Transformaciones aplicadas (en orden):
//     ctx.translate(cx, sliceY)
//     ctx.rotate(stackRotation × π/180)          ← mismo para TODAS → crea la magia
//     ctx.scale(1.0, perspectiveY)               ← squish Y ~0.55 simula vista elevada
//
//   Radio de cada rodaja según la forma:
//     sphere:   r = √(1 − (2t−1)²) × baseRadius   (círculo que varía por seno)
//     cube:     r = baseRadius                      (cuadrado constante; rotación crea cubo)
//     cylinder: r = baseRadius                      (círculo constante)
//     cone:     r = (1−t) × baseRadius              (base ancha, punta arriba)
//     diamond:  r = (1−|2t−1|) × baseRadius         (ecuador más ancho)
//     gem:      hexágono, r = (1−|2t−1|^0.7×0.75)×R
//
//   Sombreado por altura (simula iluminación sin cálculos de luz):
//     t=0.0 → Qt.darker(primaryColor,  2.2)   parte inferior en sombra
//     t=0.5 → primaryColor                    color pleno al ecuador
//     t=1.0 → Qt.lighter(primaryColor, 1.8)   cima iluminada
//
// Por qué funciona la ilusión:
//   El ojo humano usa la perspectiva y la oclusión para inferir profundidad.
//   Al ver formas que crecen/encogen progresivamente y que rotan en sincronía,
//   el cerebro aplica la misma heurística que usa para objetos 3D reales.
//   El squish en Y (perspectiveY) hace que la vista parezca provenir de un
//   ángulo elevado (~35°) en lugar de cenital.
// =============================================================================

import QtQuick

Canvas {
    id: root

    // ── API pública ──────────────────────────────────────────────────────────
    property real   stackRotation: 0.0       // ángulo de rotación global [0°–360°]
    property int    sliceCount:    20         // número de rodajas [8–32]
    property real   sliceSpacing:  4.0        // separación vertical entre rodajas [px]
    property string shapeType:    "sphere"   // sphere | cube | cylinder | cone | diamond | gem
    property color  primaryColor:  "#00D1A9" // color base de la forma
    property real   baseRadius:    45.0       // radio máximo de la forma [px]
    property real   perspectiveY:  0.55       // factor de squish Y [0.4–0.7]

    // ── Tamaño automático: suficiente para contener toda la pila ─────────────
    // El Canvas debe crecer con sliceCount × sliceSpacing para no recortar
    // las rodajas superiores cuando el slider "Explode" está al máximo.
    readonly property real _margin: 14.0
    width:  (baseRadius + _margin) * 2
    height: baseRadius * 2 + sliceCount * sliceSpacing + _margin * 2

    // ── Disparadores de repintado ────────────────────────────────────────────
    // Canvas NO responde a bindings automáticamente: cada propiedad visual
    // que cambie debe llamar a requestPaint() explícitamente.
    onStackRotationChanged: requestPaint()
    onSliceCountChanged:    { requestPaint() }
    onSliceSpacingChanged:  { requestPaint() }
    onPrimaryColorChanged:  requestPaint()
    onShapeTypeChanged:     requestPaint()
    onBaseRadiusChanged:    requestPaint()
    onPerspectiveYChanged:  requestPaint()
    onAvailableChanged:     if (available) requestPaint()

    // ── Pintura principal ────────────────────────────────────────────────────
    onPaint: {
        var ctx = getContext("2d")
        ctx.clearRect(0, 0, width, height)

        if (sliceCount < 2) return

        var cx       = width  / 2.0
        // El centro de la rodaja BASE está en la parte inferior del canvas
        // (descontando el margen). Las rodajas se apilan hacia arriba.
        var baseCenterY = height - _margin - baseRadius * perspectiveY

        var rotRad  = stackRotation * Math.PI / 180.0

        // Precomputar los colores oscuro / medio / claro una sola vez
        // (fuera del loop para no recalcular N veces por frame)
        var darkColor  = Qt.darker(primaryColor,  2.2)
        var midColor   = primaryColor
        var lightColor = Qt.lighter(primaryColor, 1.8)

        // ── Bucle de rodajas (de abajo a arriba para z-order correcto) ───────
        for (var i = 0; i < sliceCount; i++) {
            var t      = i / (sliceCount - 1)   // 0=base … 1=cima
            var sliceY = baseCenterY - i * sliceSpacing

            // Radio de esta rodaja según la forma
            var r = _shapeRadius(t)
            if (r < 0.5) continue   // saltar rodajas degeneradas (polos esfera)

            // Color interpolado en dos tramos: dark→mid (t<0.5) y mid→light (t≥0.5)
            var sliceColor = _lerpColor(t, darkColor, midColor, lightColor)

            ctx.save()
            ctx.translate(cx, sliceY)
            ctx.rotate(rotRad)
            ctx.scale(1.0, perspectiveY)

            _drawSliceShape(ctx, r, sliceColor)

            ctx.restore()
        }
    }

    // ── Función: radio de la rodaja según forma y altura normalizada ─────────
    function _shapeRadius(t) {
        switch (shapeType) {
        case "sphere":
            // Sección transversal de una esfera: radio sigue la función seno
            return Math.sqrt(Math.max(0.0, 1.0 - Math.pow(2.0 * t - 1.0, 2))) * baseRadius
        case "cube":
            // Cuadrado constante — la ROTACIÓN revela el cubo
            return baseRadius
        case "cylinder":
            return baseRadius
        case "cone":
            // Base ancha, se estrecha hasta la punta en la cima
            return (1.0 - t) * baseRadius
        case "diamond":
            // Más ancho en el ecuador, se estrecha en ambos extremos
            return (1.0 - Math.abs(2.0 * t - 1.0)) * baseRadius
        case "gem":
            // Hexágono: variante del diamante con atenuación no lineal
            return (1.0 - Math.pow(Math.abs(2.0 * t - 1.0), 0.70) * 0.75) * baseRadius
        default:
            return baseRadius
        }
    }

    // ── Función: interpolación de color en tres paradas ─────────────────────
    // Tramo 1 (t ∈ [0.0, 0.5]): dark → mid
    // Tramo 2 (t ∈ [0.5, 1.0]): mid  → light
    function _lerpColor(t, dark, mid, light) {
        var r, g, b
        if (t <= 0.5) {
            var f = t * 2.0
            r = dark.r  + (mid.r  - dark.r)  * f
            g = dark.g  + (mid.g  - dark.g)  * f
            b = dark.b  + (mid.b  - dark.b)  * f
        } else {
            var f2 = (t - 0.5) * 2.0
            r = mid.r  + (light.r  - mid.r)  * f2
            g = mid.g  + (light.g  - mid.g)  * f2
            b = mid.b  + (light.b  - mid.b)  * f2
        }
        return Qt.rgba(r, g, b, 1.0)
    }

    // ── Función: dibujar la forma de la rodaja centrada en el origen ─────────
    // Se llama DESPUÉS de translate + rotate + scale, así que (0,0) es el centro.
    function _drawSliceShape(ctx, r, sliceColor) {
        ctx.beginPath()

        if (shapeType === "cube") {
            // Rectángulo centrado en el origen
            // NOTA: ctx.rect(x,y,w,h) → esquina superior izquierda en (x,y)
            //       por eso se usa -r, -r para centrar
            ctx.rect(-r, -r, r * 2.0, r * 2.0)
        } else if (shapeType === "gem") {
            _hexPath(ctx, r)
        } else {
            // Círculo: arc desde 0 hasta 2π
            // Con ctx.scale(1, perspectiveY) ya aplicado, el círculo
            // se dibuja como elipse en el espacio final → efecto de perspectiva
            ctx.arc(0, 0, r, 0, 2.0 * Math.PI)
        }

        // Relleno con el color interpolado
        ctx.fillStyle = sliceColor.toString()
        ctx.fill()

        // Trazo fino oscuro en el borde → refuerza la separación entre rodajas
        // y da la apariencia de "espesor" del material
        ctx.strokeStyle = "rgba(0, 0, 0, 0.45)"
        ctx.lineWidth   = 0.9
        ctx.stroke()
    }

    // ── Función: trayectoria hexagonal regular ───────────────────────────────
    // Hexágono "flat-top" (vértice apuntando derecha): ángulo inicial 0°
    function _hexPath(ctx, r) {
        for (var j = 0; j < 6; j++) {
            var angle = j * (Math.PI / 3.0)   // 0°, 60°, 120°…
            var px = r * Math.cos(angle)
            var py = r * Math.sin(angle)
            if (j === 0) ctx.moveTo(px, py)
            else         ctx.lineTo(px, py)
        }
        ctx.closePath()
    }
}
