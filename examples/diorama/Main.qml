// =============================================================================
// Diorama.qml — Diorama de papel recortado (Shadow Box / Paper Cut Art)
// =============================================================================
// Simula el arte de dioramas de papel: capas de siluetas 2D a distintas
// profundidades, con sombras pronunciadas entre ellas. La sombra crea la
// ilusión de espacio sin ninguna geometría 3D real.
//
// Técnica: DropShadow de Qt5Compat.GraphicalEffects sobre cada capa Canvas.
// La sombra proyectada en las capas inferiores (más lejanas) revela la
// distancia entre capas — cuanto más grande y suave la sombra, más "espacio"
// percibe el cerebro entre las capas.
//
// Escena: atardecer japonés — cielo degradado (morado→rosa→naranja→dorado),
// montañas lejanas, colinas, bosque de pinos, árboles+pagoda, primer plano
// de cañas y bambú.
// =============================================================================

pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

import utils

Item {
    id: root

    property bool fullSize: false
    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    // --- Controles ---
    property real shadowDepth:    6.0     // desplazamiento de sombra por capa
    property real lightAngle:     225.0   // ángulo de la luz en grados (0=derecha, 90=abajo)
    property real shadowSoftness: 10.0    // radio de desenfoque de la sombra

    // --- Pre-cálculo del vector de luz ---
    readonly property real angleRad:    lightAngle * Math.PI / 180.0
    readonly property real shadowDx:    Math.cos(angleRad)  // componente X de la dirección
    readonly property real shadowDy:    Math.sin(angleRad)  // componente Y de la dirección

    // ==========================================================================
    // COMPONENTE INTERNO: DioramaLayer
    // Envuelve un Canvas con DropShadow configurable. El Canvas tiene su propio
    // "depthIndex" (0=fondo, 5=primer plano) para calcular el offset de sombra.
    // ==========================================================================
    component DioramaLayer: Item {
        id: layerItem
        property int    depthIndex:    0
        property alias  canvasWidth:   layerCanvas.width
        property alias  canvasHeight:  layerCanvas.height
        property var    paintFunction: null   // función(ctx, w, h) llamada en onPaint

        width:  layerCanvas.width
        height: layerCanvas.height

        Canvas {
            id: layerCanvas

            // Renderiza cuando cambian los parámetros de escena
            onAvailableChanged:       if (available) requestPaint()
            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                if (layerItem.paintFunction !== null)
                    layerItem.paintFunction(ctx, width, height)
            }

            // Layer offscreen para que DropShadow funcione
            layer.enabled: layerItem.depthIndex > 0
            layer.effect: DropShadow {
                // La sombra se proyecta en dirección opuesta a la luz
                // Capa más cercana (depthIndex alto) → sombra más grande
                horizontalOffset: -layerItem.depthIndex * root.shadowDepth * root.shadowDx
                verticalOffset:   -layerItem.depthIndex * root.shadowDepth * root.shadowDy
                radius:           root.shadowSoftness
                samples:          17
                color:            Qt.rgba(0.08, 0.02, 0.0, 0.70)
                transparentBorder: true
            }
        }

        // Repintar cuando cambian los parámetros globales de sombra
        Connections {
            target: root
            function onShadowDepthChanged()    { layerCanvas.requestPaint() }
            function onLightAngleChanged()     { layerCanvas.requestPaint() }
            function onShadowSoftnessChanged() { layerCanvas.requestPaint() }
        }
    }

    // ==========================================================================
    // LAYOUT PRINCIPAL
    // ==========================================================================
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(16)
        spacing: Style.resize(12)

        // --- Título ---
        Label {
            text: "Diorama de Papel Recortado"
            font.pixelSize: Style.fontSizeL
            font.family:    Style.fontFamilyBold
            color:          "#ffffff"
        }

        // --- Panel de controles ---
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(24)

            // Profundidad de sombra
            ColumnLayout {
                spacing: Style.resize(4)
                Label {
                    text: "Profundidad  " + root.shadowDepth.toFixed(1)
                    color: "#cccccc"
                    font.pixelSize: Style.fontSizeS
                }
                Slider {
                    from: 1.0; to: 20.0
                    value: root.shadowDepth
                    stepSize: 0.5
                    implicitWidth: Style.resize(160)
                    onValueChanged: root.shadowDepth = value
                }
            }

            // Ángulo de la luz
            ColumnLayout {
                spacing: Style.resize(4)
                Label {
                    text: "Ángulo luz  " + root.lightAngle.toFixed(0) + "°"
                    color: "#cccccc"
                    font.pixelSize: Style.fontSizeS
                }
                Slider {
                    from: 0; to: 359
                    value: root.lightAngle
                    stepSize: 1
                    implicitWidth: Style.resize(160)
                    onValueChanged: root.lightAngle = value
                }
            }

            // Suavidad de sombra
            ColumnLayout {
                spacing: Style.resize(4)
                Label {
                    text: "Suavidad  " + root.shadowSoftness.toFixed(0)
                    color: "#cccccc"
                    font.pixelSize: Style.fontSizeS
                }
                Slider {
                    from: 2; to: 28
                    value: root.shadowSoftness
                    stepSize: 1
                    implicitWidth: Style.resize(160)
                    onValueChanged: root.shadowSoftness = value
                }
            }

            // Botón reset
            Button {
                text: "Reset"
                onClicked: {
                    root.shadowDepth    = 6.0
                    root.lightAngle     = 225.0
                    root.shadowSoftness = 10.0
                }
            }

            Item { Layout.fillWidth: true }
        }

        // =======================================================================
        // ESCENA DIORAMA
        // =======================================================================
        Item {
            id: sceneRoot
            Layout.fillWidth:  true
            Layout.fillHeight: true
            clip: true

            // ---------------------------------------------------------------
            // CAPA 0 — Cielo (fondo, sin sombra)
            // Degradado: morado profundo → rosa → naranja → dorado
            // + disco solar con halo
            // ---------------------------------------------------------------
            DioramaLayer {
                depthIndex: 0
                canvasWidth:  sceneRoot.width
                canvasHeight: sceneRoot.height
                paintFunction: function(ctx, w, h) {
                    // Degradado de cielo
                    var grad = ctx.createLinearGradient(0, 0, 0, h)
                    grad.addColorStop(0.00, "#2D1B5E")  // morado oscuro
                    grad.addColorStop(0.30, "#7B2D6E")  // rosa-morado
                    grad.addColorStop(0.55, "#D4563A")  // naranja cálido
                    grad.addColorStop(0.75, "#F2A23C")  // naranja dorado
                    grad.addColorStop(1.00, "#FAD47A")  // amarillo pálido
                    ctx.fillStyle = grad
                    ctx.fillRect(0, 0, w, h)

                    // Sol
                    var sunX = w * 0.62
                    var sunY = h * 0.38
                    var sunR = w * 0.055

                    // Halo exterior (corona solar)
                    var halo = ctx.createRadialGradient(sunX, sunY, sunR * 0.8,
                                                        sunX, sunY, sunR * 3.5)
                    halo.addColorStop(0.0, "rgba(255,200,80,0.40)")
                    halo.addColorStop(1.0, "rgba(255,150,20,0.00)")
                    ctx.fillStyle = halo
                    ctx.beginPath()
                    ctx.arc(sunX, sunY, sunR * 3.5, 0, Math.PI * 2)
                    ctx.fill()

                    // Disco solar
                    ctx.fillStyle = "#FFE066"
                    ctx.beginPath()
                    ctx.arc(sunX, sunY, sunR, 0, Math.PI * 2)
                    ctx.fill()

                    // Reflejos en el "agua" al fondo (franja horizontal)
                    var waterY = h * 0.72
                    var waterGrad = ctx.createLinearGradient(0, waterY, 0, h)
                    waterGrad.addColorStop(0.0, "rgba(242,162,60,0.55)")
                    waterGrad.addColorStop(1.0, "rgba(100,60,20,0.30)")
                    ctx.fillStyle = waterGrad
                    ctx.fillRect(0, waterY, w, h - waterY)

                    // Líneas de reflejo solar en el agua
                    ctx.strokeStyle = "rgba(255,220,100,0.50)"
                    ctx.lineWidth = 1.5
                    for (var i = 0; i < 6; i++) {
                        var ly = waterY + i * (h - waterY) / 6.5 + (h - waterY) * 0.05
                        var lw = (sunR * 2.5) * (1 - i * 0.10) * (0.5 + i * 0.08)
                        ctx.beginPath()
                        ctx.moveTo(sunX - lw, ly)
                        ctx.lineTo(sunX + lw, ly)
                        ctx.stroke()
                    }
                }
            }

            // ---------------------------------------------------------------
            // CAPA 1 — Montañas lejanas
            // depthIndex=1 → sombra pequeña
            // ---------------------------------------------------------------
            DioramaLayer {
                depthIndex: 1
                canvasWidth:  sceneRoot.width
                canvasHeight: sceneRoot.height
                paintFunction: function(ctx, w, h) {
                    ctx.fillStyle = "#7B6E9A"  // violeta-gris lejano
                    ctx.beginPath()
                    ctx.moveTo(0, h)
                    // Picos suaves con bezier
                    ctx.lineTo(0,       h * 0.62)
                    ctx.bezierCurveTo(w * 0.05, h * 0.44,  w * 0.12, h * 0.40, w * 0.18, h * 0.45)
                    ctx.bezierCurveTo(w * 0.24, h * 0.50,  w * 0.28, h * 0.38, w * 0.36, h * 0.36)
                    ctx.bezierCurveTo(w * 0.44, h * 0.34,  w * 0.50, h * 0.42, w * 0.55, h * 0.40)
                    ctx.bezierCurveTo(w * 0.60, h * 0.38,  w * 0.66, h * 0.32, w * 0.72, h * 0.35)
                    ctx.bezierCurveTo(w * 0.78, h * 0.38,  w * 0.84, h * 0.46, w * 0.90, h * 0.42)
                    ctx.bezierCurveTo(w * 0.95, h * 0.38,  w * 0.98, h * 0.44, w,        h * 0.48)
                    ctx.lineTo(w, h)
                    ctx.closePath()
                    ctx.fill()
                }
            }

            // ---------------------------------------------------------------
            // CAPA 2 — Colinas medias
            // depthIndex=2
            // ---------------------------------------------------------------
            DioramaLayer {
                depthIndex: 2
                canvasWidth:  sceneRoot.width
                canvasHeight: sceneRoot.height
                paintFunction: function(ctx, w, h) {
                    ctx.fillStyle = "#4A6238"  // verde-azulado oscuro
                    ctx.beginPath()
                    ctx.moveTo(0, h)
                    ctx.lineTo(0,       h * 0.70)
                    ctx.bezierCurveTo(w * 0.06, h * 0.56,  w * 0.14, h * 0.52, w * 0.22, h * 0.58)
                    ctx.bezierCurveTo(w * 0.30, h * 0.64,  w * 0.35, h * 0.50, w * 0.44, h * 0.48)
                    ctx.bezierCurveTo(w * 0.53, h * 0.46,  w * 0.58, h * 0.55, w * 0.64, h * 0.52)
                    ctx.bezierCurveTo(w * 0.70, h * 0.49,  w * 0.76, h * 0.44, w * 0.82, h * 0.47)
                    ctx.bezierCurveTo(w * 0.88, h * 0.50,  w * 0.94, h * 0.58, w,        h * 0.60)
                    ctx.lineTo(w, h)
                    ctx.closePath()
                    ctx.fill()
                }
            }

            // ---------------------------------------------------------------
            // CAPA 3 — Bosque de pinos lejanos
            // depthIndex=3
            // ---------------------------------------------------------------
            DioramaLayer {
                depthIndex: 3
                canvasWidth:  sceneRoot.width
                canvasHeight: sceneRoot.height
                paintFunction: function(ctx, w, h) {
                    ctx.fillStyle = "#2C3D1C"  // verde muy oscuro

                    // Base de la franja de tierra
                    ctx.fillRect(0, h * 0.72, w, h - h * 0.72)

                    // Pinos pequeños (triángulos apilados)
                    function drawPine(x, baseY, treeH, treeW) {
                        for (var layer = 0; layer < 3; layer++) {
                            var layerFraction = layer / 3.0
                            var tipY   = baseY - treeH * (1.0 - layerFraction * 0.55)
                            var midY   = baseY - treeH * (0.55 - layerFraction * 0.18)
                            var halfW  = treeW * (1.0 - layerFraction * 0.30) * 0.5
                            ctx.beginPath()
                            ctx.moveTo(x, tipY)
                            ctx.lineTo(x - halfW, midY)
                            ctx.lineTo(x + halfW, midY)
                            ctx.closePath()
                            ctx.fill()
                        }
                        // Tronco
                        ctx.fillRect(x - treeW * 0.06, baseY - treeH * 0.12, treeW * 0.12, treeH * 0.12)
                    }

                    var baseY = h * 0.72
                    var spacing = w / 18.0
                    for (var i = 0; i <= 18; i++) {
                        var px = i * spacing + (i % 3 - 1) * spacing * 0.15
                        var ph = h * (0.08 + (i % 5) * 0.012)
                        var pw = ph * 0.65
                        drawPine(px, baseY, ph, pw)
                    }
                }
            }

            // ---------------------------------------------------------------
            // CAPA 4 — Árboles cercanos + Pagoda
            // depthIndex=4
            // ---------------------------------------------------------------
            DioramaLayer {
                depthIndex: 4
                canvasWidth:  sceneRoot.width
                canvasHeight: sceneRoot.height
                paintFunction: function(ctx, w, h) {
                    ctx.fillStyle = "#182210"

                    // Franja de suelo
                    ctx.fillRect(0, h * 0.78, w, h - h * 0.78)

                    // Árboles grandes con copa redondeada (cerezos/robles)
                    function drawRoundTree(x, baseY, treeH, treeW) {
                        // Tronco
                        ctx.fillRect(x - treeW * 0.07, baseY - treeH * 0.38,
                                     treeW * 0.14, treeH * 0.38)
                        // Copa
                        ctx.beginPath()
                        ctx.arc(x, baseY - treeH * 0.55, treeW * 0.42, 0, Math.PI * 2)
                        ctx.fill()
                        // Copa secundaria (forma natural)
                        ctx.beginPath()
                        ctx.arc(x - treeW * 0.25, baseY - treeH * 0.48, treeW * 0.28, 0, Math.PI * 2)
                        ctx.fill()
                        ctx.beginPath()
                        ctx.arc(x + treeW * 0.22, baseY - treeH * 0.50, treeW * 0.30, 0, Math.PI * 2)
                        ctx.fill()
                    }

                    var baseY = h * 0.78
                    var positions = [
                        [0.08, 0.22, 0.18], [0.18, 0.19, 0.16],
                        [0.30, 0.24, 0.20], [0.42, 0.20, 0.17],
                        [0.75, 0.21, 0.17], [0.86, 0.23, 0.19],
                        [0.96, 0.20, 0.16]
                    ]
                    for (var i = 0; i < positions.length; i++) {
                        var px = w * positions[i][0]
                        var ph = h * positions[i][1]
                        var pw = ph * positions[i][2] / positions[i][1] * h
                        drawRoundTree(px, baseY, ph, ph * 0.90)
                    }

                    // Pagoda japonesa (5 pisos)
                    var pagX = w * 0.58
                    var pagBaseY = h * 0.78
                    var pagH = h * 0.22

                    function drawPagodaFloor(floorIdx, totalFloors) {
                        var t = floorIdx / totalFloors
                        var floorH = pagH / totalFloors
                        var floorW = pagH * 0.55 * (1.0 - t * 0.40)
                        var floorY = pagBaseY - floorIdx * floorH - floorH

                        // Cuerpo del piso
                        ctx.fillRect(pagX - floorW * 0.4, floorY, floorW * 0.8, floorH * 0.7)

                        // Tejado curvo (bezier)
                        ctx.beginPath()
                        ctx.moveTo(pagX - floorW * 0.60, floorY + floorH * 0.08)
                        ctx.bezierCurveTo(
                            pagX - floorW * 0.45, floorY - floorH * 0.22,
                            pagX - floorW * 0.20, floorY - floorH * 0.30,
                            pagX,                  floorY - floorH * 0.35
                        )
                        ctx.bezierCurveTo(
                            pagX + floorW * 0.20, floorY - floorH * 0.30,
                            pagX + floorW * 0.45, floorY - floorH * 0.22,
                            pagX + floorW * 0.60, floorY + floorH * 0.08
                        )
                        ctx.closePath()
                        ctx.fill()
                    }

                    for (var f = 0; f < 5; f++) drawPagodaFloor(f, 5)

                    // Mástil superior
                    ctx.fillRect(pagX - 2, pagBaseY - pagH, 4, pagH * 0.15)
                }
            }

            // ---------------------------------------------------------------
            // CAPA 5 — Primer plano: cañas y bambú
            // depthIndex=5 → sombra más grande y suave
            // ---------------------------------------------------------------
            DioramaLayer {
                depthIndex: 5
                canvasWidth:  sceneRoot.width
                canvasHeight: sceneRoot.height
                paintFunction: function(ctx, w, h) {
                    ctx.fillStyle = "#0A0F06"  // negro casi puro

                    // Franja de suelo
                    ctx.fillRect(0, h * 0.88, w, h - h * 0.88)

                    // Tallos de bambú (izquierda y derecha)
                    function drawBamboo(x, baseY, stemH, stemW) {
                        var segCount = Math.floor(stemH / (stemH * 0.18))
                        var segH = stemH / segCount
                        for (var s = 0; s < segCount; s++) {
                            var sy = baseY - s * segH
                            // Segmento de caña
                            ctx.fillRect(x - stemW / 2, sy - segH, stemW, segH * 0.92)
                            // Nudo (barra horizontal)
                            ctx.fillRect(x - stemW * 0.9, sy - 2, stemW * 1.8, 3)
                        }
                        // Hojas en la punta
                        for (var l = 0; l < 3; l++) {
                            var lAngle = (-0.5 + l * 0.5) * Math.PI * 0.6
                            ctx.save()
                            ctx.translate(x, baseY - stemH)
                            ctx.rotate(lAngle)
                            ctx.beginPath()
                            ctx.ellipse(0, -stemH * 0.18, stemW * 1.2, stemH * 0.08, 0, 0, Math.PI * 2)
                            ctx.fill()
                            ctx.restore()
                        }
                    }

                    // Grupo izquierdo
                    var leftPositions = [
                        [0.02, 0.78, 0.55, 0.022], [0.05, 0.82, 0.48, 0.019],
                        [0.08, 0.80, 0.60, 0.024], [0.11, 0.84, 0.44, 0.018],
                        [0.15, 0.79, 0.52, 0.021], [0.19, 0.83, 0.40, 0.017]
                    ]
                    for (var i = 0; i < leftPositions.length; i++) {
                        var p = leftPositions[i]
                        drawBamboo(w * p[0], h * p[1], h * p[2], w * p[3])
                    }

                    // Grupo derecho
                    var rightPositions = [
                        [0.81, 0.80, 0.50, 0.021], [0.85, 0.83, 0.44, 0.018],
                        [0.88, 0.78, 0.58, 0.023], [0.91, 0.82, 0.46, 0.019],
                        [0.94, 0.80, 0.52, 0.022], [0.97, 0.84, 0.40, 0.017]
                    ]
                    for (var j = 0; j < rightPositions.length; j++) {
                        var q = rightPositions[j]
                        drawBamboo(w * q[0], h * q[1], h * q[2], w * q[3])
                    }

                    // Hierbas densas en la base
                    ctx.strokeStyle = "#0A0F06"
                    ctx.lineWidth = 1.5
                    for (var g = 0; g < 60; g++) {
                        var gx = (g / 60.0) * w
                        var gy = h * 0.88
                        var gcurve = (g % 3 === 0 ? -1 : 1) * (0.02 + (g % 5) * 0.006) * w
                        var gH = h * (0.04 + (g % 7) * 0.008)
                        ctx.beginPath()
                        ctx.moveTo(gx, gy)
                        ctx.quadraticCurveTo(gx + gcurve, gy - gH * 0.5, gx + gcurve * 0.5, gy - gH)
                        ctx.stroke()
                    }
                }
            }

        } // sceneRoot

        // =======================================================================
        // SECCIÓN MATEMÁTICA COLAPSABLE
        // =======================================================================
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                id: mathToggle
                text: mathSection.visible ? "▲ Ocultar matemáticas" : "▼ ¿Cómo funciona?"
                onClicked: mathSection.visible = !mathSection.visible
            }
            Item { Layout.fillWidth: true }
        }

        Rectangle {
            id: mathSection
            visible: false
            Layout.fillWidth: true
            height: mathColumn.implicitHeight + Style.resize(20)
            color: Style.cardColor
            radius: Style.resize(8)

            ColumnLayout {
                id: mathColumn
                anchors { left: parent.left; right: parent.right; top: parent.top }
                anchors.margins: Style.resize(10)
                spacing: Style.resize(6)

                Label {
                    text: "Técnica: DropShadow como cue de profundidad"
                    font.family: Style.fontFamilyBold
                    font.pixelSize: Style.fontSizeM
                    color: Style.mainColor
                }
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: "Cada capa tiene un depthIndex (0=fondo, 5=primer plano). " +
                          "La sombra de cada capa se proyecta sobre las capas inferiores:\n\n" +
                          "  horizontalOffset = −depthIndex × shadowDepth × cos(ángulo)\n" +
                          "  verticalOffset   = −depthIndex × shadowDepth × sin(ángulo)\n\n" +
                          "El cono cerebral interpreta sombra grande = objeto más alto = más cerca. " +
                          "Con 6 capas y sombra progresiva, se perciben hasta 6 'alturas' distintas " +
                          "sin ninguna geometría 3D real.\n\n" +
                          "Ajusta 'Profundidad' para exagerar o minimizar el efecto. " +
                          "'Ángulo luz' rota la dirección de todas las sombras simultáneamente. " +
                          "'Suavidad' controla el radio de desenfoque (sombra dura vs difusa)."
                    color: "#cccccc"
                    font.pixelSize: Style.fontSizeS
                }
            }
        }

    } // ColumnLayout
}
