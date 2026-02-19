// =============================================================================
// PillToggles.qml — Botones toggle con forma de pastilla (pill) y texto ON/OFF
// =============================================================================
// Demuestra un patron de toggle compacto con forma redondeada ("pill shape"),
// donde el texto del estado (ON/OFF) se muestra dentro del propio boton.
//
// Tecnica clave — radius: height / 2:
// Cuando el radio de un Rectangle es exactamente la mitad de su altura,
// los extremos se convierten en semicirculos perfectos, creando la clasica
// forma de pastilla/capsula. Es un patron muy comun en diseno de UI.
//
// El color de fondo cambia completamente entre el color de acento (on)
// y Style.surfaceColor (off), con ColorAnimation para transiciones suaves.
// El borde sigue la misma logica: color de acento cuando activo, gris cuando no.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Pill Toggles with Text"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(15)

        Repeater {
            model: [
                { label: "GPS",     color: "#66BB6A" },
                { label: "NFC",     color: "#42A5F5" },
                { label: "VPN",     color: "#AB47BC" },
                { label: "Hotspot", color: "#FF7043" }
            ]

            // radius: height / 2 crea la forma de pastilla. El estado 'on'
            // controla color de fondo, borde y texto simultaneamente.
            Rectangle {
                id: pillToggle
                required property var modelData
                required property int index

                property bool on: index % 2 === 0

                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(44)
                radius: height / 2
                color: on ? modelData.color : Style.surfaceColor
                border.color: on ? modelData.color : "#3A3D45"
                border.width: 1

                Behavior on color { ColorAnimation { duration: 300 } }
                Behavior on border.color { ColorAnimation { duration: 300 } }

                RowLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(6)

                    Label {
                        text: pillToggle.modelData.label
                        font.pixelSize: Style.resize(12)
                        font.bold: true
                        color: pillToggle.on ? "white" : Style.fontSecondaryColor

                        Behavior on color { ColorAnimation { duration: 200 } }
                    }

                    Label {
                        text: pillToggle.on ? "ON" : "OFF"
                        font.pixelSize: Style.resize(11)
                        font.bold: true
                        color: pillToggle.on ? Qt.rgba(1,1,1,0.7) : Style.inactiveColor
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: pillToggle.on = !pillToggle.on
                }
            }
        }
    }
}
