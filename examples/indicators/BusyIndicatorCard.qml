// =============================================================================
// BusyIndicatorCard.qml — Tarjeta de ejemplo del BusyIndicator
// =============================================================================
// Presenta tres variantes del indicador de actividad:
//   1) Default: BusyIndicator nativo con tamano por defecto.
//   2) Grande: mismo control pero con implicitWidth/Height sobreescritos.
//   3) Custom (Canvas): un spinner completamente personalizado dibujado
//      con Canvas y animado con RotationAnimation.
//
// Patrones clave:
//   - RotationAnimation on rotation: aplica rotacion continua directamente
//     sobre la propiedad "rotation" del Item, sin necesidad de Behavior.
//   - Canvas con gradiente simulado: en lugar de un gradiente nativo (que
//     Canvas 2D no soporta para arcos), se dibujan ~40 segmentos de arco
//     con opacidad (alpha) creciente, creando la ilusion de un degradado.
//   - El Canvas se pinta UNA sola vez (Component.onCompleted) porque la
//     imagen es estatica — la rotacion la maneja el Item padre, no el Canvas.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "BusyIndicator"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Switch global que controla todos los indicadores de esta tarjeta.
        // Un solo control vinculado a tres componentes — DRY en QML.
        Switch {
            id: busySwitch
            text: "Running"
            checked: true
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(40)
            Layout.alignment: Qt.AlignHCenter

            // ── BusyIndicator tamano por defecto ──
            ColumnLayout {
                spacing: Style.resize(10)
                Layout.alignment: Qt.AlignHCenter

                BusyIndicator {
                    running: busySwitch.checked
                    Layout.alignment: Qt.AlignHCenter
                }

                Label {
                    text: "Default (40px)"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // ── BusyIndicator tamano grande ──
            // Se sobreescribe implicitWidth/Height en vez de width/height
            // porque el Layout respeta las dimensiones implicitas para
            // calcular el tamano preferido del componente.
            ColumnLayout {
                spacing: Style.resize(10)
                Layout.alignment: Qt.AlignHCenter

                BusyIndicator {
                    running: busySwitch.checked
                    implicitWidth: Style.resize(80)
                    implicitHeight: Style.resize(80)
                    Layout.alignment: Qt.AlignHCenter
                }

                Label {
                    text: "Large (80px)"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // ── Spinner custom con Canvas ──
            // Tecnica: dibujar un arco con gradiente de opacidad usando
            // multiples segmentos pequenos, luego rotar el contenedor entero.
            // Esto separa el dibujo (estatico, costoso) de la animacion
            // (rotacion, barata en GPU).
            ColumnLayout {
                spacing: Style.resize(10)
                Layout.alignment: Qt.AlignHCenter

                Rectangle {
                    Layout.preferredWidth: Style.resize(90)
                    Layout.preferredHeight: Style.resize(90)
                    Layout.alignment: Qt.AlignHCenter
                    radius: Style.resize(12)
                    color: "#1B2838"

                    Item {
                        id: spinnerContainer
                        anchors.centerIn: parent
                        width: Style.resize(50)
                        height: Style.resize(50)

                        // RotationAnimation "on rotation" vincula la animacion
                        // directamente a la propiedad rotation del Item.
                        // loops: Infinite mantiene el giro mientras running=true.
                        RotationAnimation on rotation {
                            from: 0; to: 360
                            duration: 1200
                            loops: Animation.Infinite
                            running: busySwitch.checked
                        }

                        Canvas {
                            id: gradientSpinner
                            anchors.fill: parent

                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.reset()

                                var cx = width / 2
                                var cy = height / 2
                                var r = cx - Style.resize(4)
                                var lw = Style.resize(3.5)
                                var steps = 40
                                var arcSpan = 1.6 * Math.PI // ~290°

                                // Dibujar segmentos con alpha creciente para
                                // simular un gradiente a lo largo del arco.
                                // Cada segmento tiene opacidad i/steps (0→1).
                                for (var i = 0; i < steps; i++) {
                                    var a0 = -Math.PI / 2 + (i / steps) * arcSpan
                                    var a1 = -Math.PI / 2 + ((i + 1.5) / steps) * arcSpan
                                    var alpha = i / steps

                                    ctx.beginPath()
                                    ctx.arc(cx, cy, r, a0, a1, false)
                                    ctx.strokeStyle = Qt.rgba(0, 0.82, 0.66, alpha)
                                    ctx.lineWidth = lw
                                    ctx.lineCap = "round"
                                    ctx.stroke()
                                }
                            }

                            Component.onCompleted: requestPaint()
                        }
                    }
                }

                Label {
                    text: "Custom (Canvas)"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // ── Etiqueta de estado reactiva ──
        // Cambia texto y color segun el estado del switch usando
        // operador ternario — patron comun en QML para UI reactiva.
        Label {
            text: busySwitch.checked ? "Status: Loading..." : "Status: Idle"
            font.pixelSize: Style.resize(14)
            font.bold: true
            color: busySwitch.checked ? Style.mainColor : Style.inactiveColor
        }

        Label {
            text: "BusyIndicator shows that an operation is in progress"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item { Layout.fillHeight: true }
    }
}
