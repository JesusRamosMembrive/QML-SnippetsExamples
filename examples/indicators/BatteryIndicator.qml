// =============================================================================
// BatteryIndicator.qml — Indicador de batería con niveles y animaciones
// =============================================================================
// Demuestra cómo construir un indicador de batería visual usando solo
// Rectangles apilados. Conceptos clave:
//
//   - Repeater con array de objetos JS como modelo: cada elemento define
//     level (0.0–1.0), charging (bool) y label. Esto permite renderizar
//     múltiples baterías con un solo delegate.
//   - Color semántico con ternario encadenado: verde > 50%, naranja > 20%,
//     rojo <= 20%. Centralizado en una propiedad readonly para DRY.
//   - Rectángulo de relleno anclado a bottom: su height es proporcional al
//     nivel (parent.height * level). Así el relleno "crece" desde abajo.
//   - SequentialAnimation on opacity: parpadeo infinito para batería crítica
//     (<= 12%). La condición `running` activa/desactiva automáticamente.
//   - Icono de rayo (⚡) con animación de pulso para estado "cargando".
//   - required property var modelData + required property int index: patrón
//     moderno Qt 6 para acceso seguro a datos del modelo en delegates.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Battery Indicator"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(30)
        Layout.alignment: Qt.AlignHCenter

        Repeater {
            model: [
                { level: 0.95, charging: true,  label: "Charging" },
                { level: 0.72, charging: false, label: "Good" },
                { level: 0.35, charging: false, label: "Medium" },
                { level: 0.12, charging: false, label: "Low" },
                { level: 0.05, charging: false, label: "Critical" }
            ]

            delegate: ColumnLayout {
                id: batteryDelegate
                spacing: Style.resize(8)

                required property var modelData
                required property int index

                readonly property color batteryColor:
                    modelData.level > 0.5  ? "#34C759"
                  : modelData.level > 0.2  ? "#FF9500"
                  : "#FF3B30"

                Item {
                    Layout.preferredWidth: Style.resize(52)
                    Layout.preferredHeight: Style.resize(90)
                    Layout.alignment: Qt.AlignHCenter

                    // Battery tip
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        width: Style.resize(18)
                        height: Style.resize(6)
                        radius: Style.resize(2)
                        color: Qt.rgba(1, 1, 1, 0.2)
                    }

                    // Battery body
                    Rectangle {
                        id: batteryBody
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.topMargin: Style.resize(5)
                        width: Style.resize(44)
                        height: Style.resize(76)
                        radius: Style.resize(6)
                        color: "transparent"
                        border.color: Qt.rgba(1, 1, 1, 0.2)
                        border.width: Style.resize(2)

                        // Fill level
                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.margins: Style.resize(4)
                            width: parent.width - Style.resize(8)
                            height: (parent.height - Style.resize(8)) * batteryDelegate.modelData.level
                            radius: Style.resize(3)
                            color: batteryDelegate.batteryColor

                            Behavior on height {
                                NumberAnimation { duration: 600 }
                            }

                            // Pulse animation for low battery
                            SequentialAnimation on opacity {
                                loops: Animation.Infinite
                                running: batteryDelegate.modelData.level <= 0.12
                                NumberAnimation { from: 1.0; to: 0.3; duration: 600 }
                                NumberAnimation { from: 0.3; to: 1.0; duration: 600 }
                            }
                        }

                        // Charging bolt
                        Label {
                            anchors.centerIn: parent
                            text: "\u26A1"
                            font.pixelSize: Style.resize(20)
                            visible: batteryDelegate.modelData.charging
                            opacity: chargingBoltAnim.running ? 1.0 : 0.0

                            SequentialAnimation on opacity {
                                id: chargingBoltAnim
                                loops: Animation.Infinite
                                running: batteryDelegate.modelData.charging
                                NumberAnimation { from: 0.4; to: 1.0; duration: 800 }
                                NumberAnimation { from: 1.0; to: 0.4; duration: 800 }
                            }
                        }
                    }
                }

                Label {
                    text: Math.round(batteryDelegate.modelData.level * 100) + "%"
                    font.pixelSize: Style.resize(14)
                    font.bold: true
                    color: batteryDelegate.batteryColor
                    Layout.alignment: Qt.AlignHCenter
                }

                Label {
                    text: batteryDelegate.modelData.label
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
