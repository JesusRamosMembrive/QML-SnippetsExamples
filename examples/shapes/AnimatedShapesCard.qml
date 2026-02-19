// =============================================================================
// AnimatedShapesCard.qml — Morphing de formas y animaciones continuas
// =============================================================================
// Demuestra como animar formas vectoriales (Shape) en QML con dos tecnicas:
//
//   1. MORPHING (izquierda): transforma una forma en otra interpolando
//      los puntos de control de curvas cubicas. Un triangulo se convierte
//      en cuadrado y luego en circulo, todo con la misma cantidad de
//      PathCubic (3 segmentos). La funcion lerp3(a,b,c,t) interpola
//      entre 3 estados usando un parametro 't' de 0 a 2.
//
//   2. ROTACION + ESCALA (derecha): combina rotation y scale animados
//      sobre un Shape con dos triangulos superpuestos (Estrella de David).
//      'NumberAnimation on spin' y 'SequentialAnimation on pulse' son
//      animaciones directas sobre propiedades — no necesitan Behavior.
//
// CONCEPTO CLAVE - MORPHING CON CURVAS BEZIER:
// Para hacer morphing, todas las formas deben tener el MISMO numero de
// segmentos de curva. Un triangulo, cuadrado y circulo normalmente tienen
// diferente cantidad de puntos, pero aqui se representan TODOS con 3
// PathCubic. Los puntos de control determinan la curvatura:
//   - Triangulo: controles cerca de los vertices (curvas casi rectas).
//   - Cuadrado: controles alineados con los lados (esquinas marcadas).
//   - Circulo: controles a 0.55*radio (aproximacion cubica estandar).
//
// SequentialAnimation: encadena animaciones en secuencia. Aqui va:
// triangulo->cuadrado (1.5s), pausa, cuadrado->circulo (1.5s), pausa,
// circulo->triangulo (1.5s), pausa, y repite infinitamente.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)
    clip: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(15)
        spacing: Style.resize(8)

        Label {
            text: "Animated Shapes"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(15)

            // --- Morphing: triangulo -> cuadrado -> circulo ---
            // La propiedad 'morph' (0 a 2) controla la transicion:
            //   0 = triangulo, 1 = cuadrado, 2 = circulo.
            // SequentialAnimation mueve 'morph' por tramos con pausas entre cada uno.
            Item {
                id: morphItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                property real morph: 0.0

                SequentialAnimation on morph {
                    id: morphAnim
                    loops: Animation.Infinite
                    running: true
                    NumberAnimation { from: 0; to: 1; duration: 1500; easing.type: Easing.InOutQuad }
                    PauseAnimation { duration: 500 }
                    NumberAnimation { from: 1; to: 2; duration: 1500; easing.type: Easing.InOutQuad }
                    PauseAnimation { duration: 500 }
                    NumberAnimation { from: 2; to: 0; duration: 1500; easing.type: Easing.InOutQuad }
                    PauseAnimation { duration: 500 }
                }

                Shape {
                    anchors.centerIn: parent
                    width: Style.resize(160)
                    height: Style.resize(160)

                    ShapePath {
                        id: morphPath
                        strokeWidth: Style.resize(3)
                        strokeColor: Style.mainColor
                        fillColor: Qt.rgba(Style.mainColor.r,
                                           Style.mainColor.g,
                                           Style.mainColor.b, 0.2)

                        property real m: morphItem.morph
                        property real cx: 80
                        property real cy: 80
                        property real r: 65

                        // Triangle (m=0), Square (m=1), Circle (m=2)
                        // Interpolate via 4 cubic curves
                        property real triTop:    cy - r
                        property real triBot:    cy + r * 0.6
                        property real triLeft:   cx - r * 0.85
                        property real triRight:  cx + r * 0.85

                        property real sqLeft:    cx - r * 0.75
                        property real sqRight:   cx + r * 0.75
                        property real sqTop:     cy - r * 0.75
                        property real sqBot:     cy + r * 0.75

                        // lerp helpers
                        function lerp3(a, b, c, t) {
                            if (t < 1) return a + (b - a) * t
                            return b + (c - b) * (t - 1)
                        }

                        // Top point
                        startX: lerp3(cx, sqRight, cx + r, m)
                        startY: lerp3(triTop, sqTop, cy, m)

                        PathCubic {
                            // Top-right to bottom-right
                            x: morphPath.lerp3(morphPath.triRight, morphPath.sqRight, morphPath.cx + morphPath.r, morphPath.m)
                            y: morphPath.lerp3(morphPath.triBot, morphPath.sqBot, morphPath.cy, morphPath.m)
                            control1X: morphPath.lerp3(morphPath.cx + 10, morphPath.sqRight, morphPath.cx + morphPath.r, morphPath.m)
                            control1Y: morphPath.lerp3(morphPath.triTop + 20, morphPath.sqTop, morphPath.cy - morphPath.r * 0.55, morphPath.m)
                            control2X: morphPath.lerp3(morphPath.triRight, morphPath.sqRight, morphPath.cx + morphPath.r, morphPath.m)
                            control2Y: morphPath.lerp3(morphPath.triBot - 30, morphPath.sqBot - 20, morphPath.cy + morphPath.r * 0.55, morphPath.m)
                        }

                        PathCubic {
                            // Bottom-right to bottom-left
                            x: morphPath.lerp3(morphPath.triLeft, morphPath.sqLeft, morphPath.cx - morphPath.r, morphPath.m)
                            y: morphPath.lerp3(morphPath.triBot, morphPath.sqBot, morphPath.cy, morphPath.m)
                            control1X: morphPath.lerp3(morphPath.triRight - 10, morphPath.sqRight, morphPath.cx + morphPath.r * 0.55, morphPath.m)
                            control1Y: morphPath.lerp3(morphPath.triBot, morphPath.sqBot, morphPath.cy + morphPath.r, morphPath.m)
                            control2X: morphPath.lerp3(morphPath.triLeft + 10, morphPath.sqLeft, morphPath.cx - morphPath.r * 0.55, morphPath.m)
                            control2Y: morphPath.lerp3(morphPath.triBot, morphPath.sqBot, morphPath.cy + morphPath.r, morphPath.m)
                        }

                        PathCubic {
                            // Bottom-left to top
                            x: morphPath.startX
                            y: morphPath.startY
                            control1X: morphPath.lerp3(morphPath.triLeft, morphPath.sqLeft, morphPath.cx - morphPath.r, morphPath.m)
                            control1Y: morphPath.lerp3(morphPath.triBot - 30, morphPath.sqTop + 20, morphPath.cy - morphPath.r * 0.55, morphPath.m)
                            control2X: morphPath.lerp3(morphPath.cx - 10, morphPath.sqLeft, morphPath.cx - morphPath.r, morphPath.m)
                            control2Y: morphPath.lerp3(morphPath.triTop + 20, morphPath.sqTop, morphPath.cy - morphPath.r * 0.55, morphPath.m)
                        }
                    }
                }

                // Shape label
                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: {
                        var m = parent.morph
                        if (m < 0.5) return "Triangle"
                        if (m < 1.5) return "Square"
                        return "Circle"
                    }
                    font.pixelSize: Style.resize(14)
                    font.bold: true
                    color: Style.mainColor
                }
            }

            // --- Rotacion continua + pulso de escala ---
            // Dos animaciones independientes corren en paralelo:
            //   - spin: 0->360 grados en 6 segundos (rotacion constante).
            //   - pulse: 0.8->1.2->0.8 con easing sinusoidal ("respiracion").
            // La forma resultante es una Estrella de David (dos triangulos
            // invertidos) que gira y "respira" simultaneamente.
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                property real spin: 0
                NumberAnimation on spin {
                    from: 0; to: 360; duration: 6000
                    loops: Animation.Infinite
                }

                property real pulse: 0.8
                SequentialAnimation on pulse {
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.8; to: 1.2; duration: 1000; easing.type: Easing.InOutSine }
                    NumberAnimation { from: 1.2; to: 0.8; duration: 1000; easing.type: Easing.InOutSine }
                }

                Shape {
                    anchors.centerIn: parent
                    width: Style.resize(140)
                    height: Style.resize(140)
                    rotation: parent.spin
                    scale: parent.pulse

                    // 3 interleaved triangles
                    ShapePath {
                        strokeWidth: Style.resize(3)
                        strokeColor: Style.mainColor
                        fillColor: Qt.rgba(Style.mainColor.r, Style.mainColor.g, Style.mainColor.b, 0.2)
                        startX: 70; startY: 10
                        PathLine { x: 120; y: 110 }
                        PathLine { x: 20;  y: 110 }
                        PathLine { x: 70;  y: 10 }
                    }
                    ShapePath {
                        strokeWidth: Style.resize(3)
                        strokeColor: "#FF5900"
                        fillColor: Qt.rgba(1, 0.35, 0, 0.15)
                        startX: 70; startY: 130
                        PathLine { x: 20;  y: 30 }
                        PathLine { x: 120; y: 30 }
                        PathLine { x: 70;  y: 130 }
                    }
                }

                Label {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Rotation + Scale"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }
            }
        }
    }
}
