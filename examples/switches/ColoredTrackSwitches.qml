// =============================================================================
// ColoredTrackSwitches.qml — Switches custom con track + knob animado
// =============================================================================
// Recrea el clasico control Switch desde cero usando Rectangle + MouseArea,
// pero con un color de track unico por cada switch. Esto es util cuando
// el estilo global del Switch no permite colores individuales.
//
// Anatomia del switch custom:
//   - Track: Rectangle con radius = height/2 (forma de pastilla)
//   - Knob: Rectangle circular (radius = width/2) que se desplaza en X
//   - La posicion X del knob cambia con un ternario: on ? (derecha) : (izquierda)
//   - NumberAnimation en X con Easing.InOutQuad da movimiento natural
//
// GridLayout con 2 columnas organiza los 4 switches en una grilla 2x2.
// Cada delegate del Repeater es un RowLayout (track + etiqueta) que ocupa
// una celda completa gracias a Layout.fillWidth.
// =============================================================================
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Colored Track Switches"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    GridLayout {
        Layout.fillWidth: true
        columns: 2
        columnSpacing: Style.resize(20)
        rowSpacing: Style.resize(12)

        Repeater {
            model: [
                { label: "Notifications", color: "#4FC3F7", checked: true },
                { label: "Do Not Disturb", color: "#EF5350", checked: false },
                { label: "Auto-Sync", color: "#66BB6A", checked: true },
                { label: "Power Saver", color: "#FFA726", checked: false }
            ]

            RowLayout {
                id: colorSwitchRow
                required property var modelData
                required property int index

                property bool on: modelData.checked

                Layout.fillWidth: true
                spacing: Style.resize(12)

                // Track del switch: radius = height/2 crea la forma pill.
                // El color cambia entre el color de acento (on) y gris (off).
                Rectangle {
                    id: colorTrack
                    Layout.preferredWidth: Style.resize(52)
                    Layout.preferredHeight: Style.resize(28)
                    radius: height / 2
                    color: colorSwitchRow.on
                           ? colorSwitchRow.modelData.color
                           : "#3A3D45"

                    Behavior on color { ColorAnimation { duration: 250 } }

                    // Knob: circulo blanco que se desplaza entre los extremos.
                    // x se calcula con ternario + Behavior on x para animar.
                    Rectangle {
                        id: colorKnob
                        width: Style.resize(22)
                        height: width
                        radius: width / 2
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        x: colorSwitchRow.on
                           ? parent.width - width - Style.resize(3)
                           : Style.resize(3)

                        Behavior on x {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.InOutQuad
                            }
                        }

                        // Shadow
                        layer.enabled: true
                        layer.effect: Item {}
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: colorSwitchRow.on = !colorSwitchRow.on
                    }
                }

                Label {
                    text: colorSwitchRow.modelData.label
                    font.pixelSize: Style.resize(14)
                    color: colorSwitchRow.on ? "white" : Style.fontSecondaryColor
                    Layout.fillWidth: true

                    Behavior on color { ColorAnimation { duration: 200 } }
                }
            }
        }
    }
}
