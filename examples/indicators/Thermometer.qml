// =============================================================================
// Thermometer.qml — Termómetro analógico con bulbo y escala
// =============================================================================
// Simula un termómetro clásico de mercurio usando Rectangles. Conceptos clave:
//
//   - Normalización lineal para el relleno: la altura del "mercurio" se calcula
//     como fraction = (temp - minTemp) / (maxTemp - minTemp), mapeando el rango
//     [-20, 50] al rango [0, 1] del rectángulo. Es el mismo principio que usan
//     barras de progreso, VU meters y cualquier indicador lineal.
//   - Math.max() como guardián: garantiza una altura mínima de 6px incluso
//     cuando temp = minTemp, evitando que el relleno desaparezca completamente.
//   - Color semántico con ternario: rojo (>35°), naranja (>20°), verde (>5°),
//     azul (<=5°). Centralizado en thermoColor para usarlo en bulbo y relleno.
//   - Behavior on height + Behavior on color: doble animación que hace que
//     tanto el nivel como el color cambien suavemente al mover el Slider.
//   - Escala con Repeater: genera 8 marcas (-20° a 50° cada 10°). La posición Y
//     de cada marca usa la misma fórmula de normalización que el relleno,
//     garantizando que marcas y nivel estén siempre alineados.
//   - Bulbo circular: un Rectangle con radius: width/2 posicionado con
//     topMargin negativo (-10) para que se superponga con el tubo, creando
//     la ilusión de un termómetro continuo.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    // ── Section 5: Thermometer ────────────────────────
    Label {
        text: "Thermometer"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(30)
        Layout.alignment: Qt.AlignHCenter

        Item {
            id: thermoContainer
            Layout.preferredWidth: Style.resize(80)
            Layout.preferredHeight: Style.resize(220)

            property real temperature: thermoSlider.value
            property real minTemp: -20
            property real maxTemp: 50

            readonly property color thermoColor:
                temperature > 35 ? "#FF3B30"
              : temperature > 20 ? "#FF9500"
              : temperature > 5  ? "#34C759"
              : "#5B8DEF"

            // Thermometer body
            Rectangle {
                id: thermoTube
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: Style.resize(10)
                width: Style.resize(24)
                height: Style.resize(150)
                radius: width / 2
                color: Qt.rgba(1, 1, 1, 0.06)
                border.color: Qt.rgba(1, 1, 1, 0.15)
                border.width: Style.resize(1)

                // Mercury fill
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.margins: Style.resize(3)
                    width: parent.width - Style.resize(6)
                    height: Math.max(Style.resize(6),
                        (parent.height - Style.resize(6))
                        * ((thermoContainer.temperature - thermoContainer.minTemp)
                           / (thermoContainer.maxTemp - thermoContainer.minTemp)))
                    radius: width / 2
                    color: thermoContainer.thermoColor

                    Behavior on height {
                        NumberAnimation { duration: 400; easing.type: Easing.OutQuad }
                    }
                    Behavior on color {
                        ColorAnimation { duration: 400 }
                    }
                }

                // Tick marks
                Repeater {
                    model: 8 // -20, -10, 0, 10, 20, 30, 40, 50
                    delegate: Item {
                        id: thermoTick
                        required property int index

                        readonly property real tickTemp: -20 + thermoTick.index * 10
                        readonly property real fraction:
                            (tickTemp - thermoContainer.minTemp)
                            / (thermoContainer.maxTemp - thermoContainer.minTemp)

                        y: thermoTube.height - Style.resize(3)
                           - fraction * (thermoTube.height - Style.resize(6))
                           - Style.resize(1)

                        Rectangle {
                            x: thermoTube.width + Style.resize(3)
                            width: Style.resize(8)
                            height: Style.resize(1)
                            color: Qt.rgba(1, 1, 1, 0.3)
                        }

                        Label {
                            x: thermoTube.width + Style.resize(14)
                            anchors.verticalCenter: parent.verticalCenter
                            text: thermoTick.tickTemp + "°"
                            font.pixelSize: Style.resize(9)
                            color: Style.fontSecondaryColor
                        }
                    }
                }
            }

            // Bulb at bottom
            Rectangle {
                anchors.horizontalCenter: thermoTube.horizontalCenter
                anchors.top: thermoTube.bottom
                anchors.topMargin: Style.resize(-10)
                width: Style.resize(36)
                height: Style.resize(36)
                radius: width / 2
                color: thermoContainer.thermoColor

                Behavior on color {
                    ColorAnimation { duration: 400 }
                }

                Label {
                    anchors.centerIn: parent
                    text: Math.round(thermoContainer.temperature) + "°"
                    font.pixelSize: Style.resize(10)
                    font.bold: true
                    color: "#FFFFFF"
                }
            }
        }

        // Temperature control
        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: Style.resize(10)

            Label {
                text: "Temperature"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }

            Slider {
                id: thermoSlider
                Layout.preferredWidth: Style.resize(200)
                from: -20
                to: 50
                value: 22
                stepSize: 1
            }

            Label {
                text: Math.round(thermoSlider.value) + " °C"
                font.pixelSize: Style.resize(18)
                font.bold: true
                color: thermoContainer.thermoColor
            }

            Label {
                text: thermoSlider.value > 35 ? "🔥 Hot"
                    : thermoSlider.value > 20 ? "☀ Warm"
                    : thermoSlider.value > 5  ? "🌤 Cool"
                    : "❄ Cold"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }
        }
    }
}
