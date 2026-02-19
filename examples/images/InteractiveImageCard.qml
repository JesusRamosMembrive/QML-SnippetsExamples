// =============================================================================
// InteractiveImageCard.qml — Propiedades interactivas de imagen
// =============================================================================
// Permite experimentar en tiempo real con las propiedades de transformacion
// de un Item visual: rotation, scale, y mirror (espejo horizontal/vertical).
// La imagen incluye una flecha con texto "UP" para que el efecto de cada
// transformacion sea inmediatamente visible.
//
// Conceptos clave:
// - 'transform: Scale' permite espejo independiente en X e Y sin afectar
//   la propiedad 'scale' global del item. origin.x/y centran la transformacion.
// - 'Behavior on' anima automaticamente cualquier cambio en la propiedad,
//   creando transiciones suaves sin necesidad de definir estados.
// - 'smooth' controla el filtrado bilineal; desactivarlo muestra pixeles
//   crudos, util para pixel art o para entender el concepto de antialiasing.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property bool mirrorH: false
    property bool mirrorV: false
    property real imgRotation: 0
    property real imgScale: 1.0
    property bool smoothEnabled: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(12)

        Label {
            text: "Image Properties"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Area de previsualizacion con clip para que las transformaciones
        // (especialmente scale > 1) no se desborden fuera de la tarjeta.
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Rectangle {
                anchors.fill: parent
                color: Style.surfaceColor
                radius: Style.resize(8)
            }

            // Imagen generada con Canvas. La flecha "UP" hace evidente
            // el efecto del espejo y la rotacion.
            Canvas {
                id: propCanvas
                anchors.centerIn: parent
                width: Style.resize(150)
                height: Style.resize(150)
                rotation: root.imgRotation
                scale: root.imgScale
                smooth: root.smoothEnabled

                // transform: Scale independiente de la propiedad 'scale'.
                // xScale: -1 voltea horizontalmente, yScale: -1 verticalmente.
                // El origin centra la transformacion en el punto medio del Canvas.
                transform: Scale {
                    origin.x: propCanvas.width / 2
                    origin.y: propCanvas.height / 2
                    xScale: root.mirrorH ? -1 : 1
                    yScale: root.mirrorV ? -1 : 1
                }

                // Behavior anima cambios graduales desde los Sliders
                Behavior on rotation { NumberAnimation { duration: 300 } }
                Behavior on scale { NumberAnimation { duration: 300 } }

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)

                    // Background
                    var grad = ctx.createLinearGradient(0, 0, width, height)
                    grad.addColorStop(0.0, "#00D1A9")
                    grad.addColorStop(0.5, "#4FC3F7")
                    grad.addColorStop(1.0, "#AB47BC")
                    ctx.fillStyle = grad
                    ctx.fillRect(0, 0, width, height)

                    // Arrow (to show orientation)
                    ctx.fillStyle = "#FFFFFF"
                    ctx.beginPath()
                    ctx.moveTo(width * 0.5, height * 0.15)
                    ctx.lineTo(width * 0.7, height * 0.45)
                    ctx.lineTo(width * 0.57, height * 0.45)
                    ctx.lineTo(width * 0.57, height * 0.85)
                    ctx.lineTo(width * 0.43, height * 0.85)
                    ctx.lineTo(width * 0.43, height * 0.45)
                    ctx.lineTo(width * 0.3, height * 0.45)
                    ctx.closePath()
                    ctx.fill()

                    // "UP" label
                    ctx.fillStyle = "#00D1A9"
                    ctx.font = "bold 14px sans-serif"
                    ctx.textAlign = "center"
                    ctx.fillText("UP", width * 0.5, height * 0.38)
                }
                Component.onCompleted: requestPaint()
            }
        }

        // -----------------------------------------------------------------
        // Controles interactivos: Sliders para rotacion y escala,
        // Switches para espejos y suavizado. Cada control esta vinculado
        // a una propiedad del root, manteniendo la logica desacoplada.
        // -----------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Rotation: " + root.imgRotation.toFixed(0) + "\u00B0"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.preferredWidth: Style.resize(90)
                }
                Slider {
                    Layout.fillWidth: true
                    from: 0; to: 360; value: root.imgRotation
                    onValueChanged: root.imgRotation = value
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Scale: " + root.imgScale.toFixed(2)
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.preferredWidth: Style.resize(90)
                }
                Slider {
                    Layout.fillWidth: true
                    from: 0.3; to: 2.0; value: root.imgScale
                    onValueChanged: root.imgScale = value
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Style.resize(12)

                Switch {
                    text: "Mirror H"
                    font.pixelSize: Style.resize(11)
                    checked: root.mirrorH
                    onToggled: root.mirrorH = checked
                }
                Switch {
                    text: "Mirror V"
                    font.pixelSize: Style.resize(11)
                    checked: root.mirrorV
                    onToggled: root.mirrorV = checked
                }
                Switch {
                    text: "Smooth"
                    font.pixelSize: Style.resize(11)
                    checked: root.smoothEnabled
                    onToggled: root.smoothEnabled = checked
                }
            }
        }
    }
}
