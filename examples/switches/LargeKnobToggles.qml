// =============================================================================
// LargeKnobToggles.qml — Botones toggle circulares grandes con feedback tactil
// =============================================================================
// Demuestra toggles circulares con retroalimentacion visual completa:
// hover (agrandamiento sutil), press (encogimiento), y transicion de color
// e icono al cambiar de estado.
//
// Tecnicas clave:
//   1. Escala interactiva con MouseArea: containsMouse y pressed controlan
//      'scale' con valores distintos (1.05 hover, 0.9 pressed, 1.0 normal).
//      hoverEnabled: true es necesario para detectar hover sin clic.
//   2. Iconos duales: el modelo tiene icon (estado on) y offIcon (estado off),
//      permitiendo cambiar el emoji segun el estado del toggle.
//   3. Qt.lighter(): genera un color mas claro a partir del color de acento
//      para el borde, creando un efecto de "glow" cuando el toggle esta activo.
//
// Los Behavior on scale/color aseguran transiciones animadas en todo cambio.
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
        text: "Large Knob Toggles"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(20)

        Repeater {
            model: [
                { icon: "\uD83D\uDD0A", offIcon: "\uD83D\uDD07", label: "Sound",  color: "#7E57C2" },
                { icon: "\uD83D\uDD06", offIcon: "\uD83D\uDD05", label: "Screen", color: "#26A69A" },
                { icon: "\uD83D\uDD12", offIcon: "\uD83D\uDD13", label: "Lock",   color: "#EF5350" },
                { icon: "\u26A1",        offIcon: "\uD83D\uDD0C", label: "Power",  color: "#FFA726" }
            ]

            Item {
                id: largeToggleItem
                required property var modelData
                required property int index

                property bool on: index < 2

                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(100)

                ColumnLayout {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: Style.resize(8)

                    // Knob circular: radius = width/2 lo hace circulo perfecto.
                    // scale reacciona a tres estados de MouseArea (reposo,
                    // hover, pressed) con Behavior para animacion suave.
                    Rectangle {
                        id: largeKnob
                        Layout.preferredWidth: Style.resize(64)
                        Layout.preferredHeight: Style.resize(64)
                        Layout.alignment: Qt.AlignHCenter
                        radius: width / 2
                        color: largeToggleItem.on
                               ? largeToggleItem.modelData.color
                               : Style.surfaceColor
                        border.color: largeToggleItem.on
                                      ? Qt.lighter(largeToggleItem.modelData.color, 1.3)
                                      : "#3A3D45"
                        border.width: 2

                        Behavior on color { ColorAnimation { duration: 250 } }
                        Behavior on border.color { ColorAnimation { duration: 250 } }

                        scale: knobMa.pressed ? 0.9 : (knobMa.containsMouse ? 1.05 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 150 } }

                        Label {
                            anchors.centerIn: parent
                            text: largeToggleItem.on
                                  ? largeToggleItem.modelData.icon
                                  : largeToggleItem.modelData.offIcon
                            font.pixelSize: Style.resize(26)
                        }

                        MouseArea {
                            id: knobMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: largeToggleItem.on = !largeToggleItem.on
                        }
                    }

                    Label {
                        text: largeToggleItem.modelData.label
                        font.pixelSize: Style.resize(12)
                        font.bold: true
                        color: largeToggleItem.on
                               ? largeToggleItem.modelData.color
                               : Style.fontSecondaryColor
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter

                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                }
            }
        }
    }
}
