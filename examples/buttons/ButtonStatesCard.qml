// =============================================================================
// ButtonStatesCard.qml — Estados interactivos del componente Button
// =============================================================================
// Demuestra las tres propiedades de estado mas importantes de Button en Qt
// Quick Controls: down (presionado), hovered (cursor encima) y checkable
// (toggle on/off). Estos estados son la base para crear interacciones
// de usuario ricas y responsivas.
//
// CONCEPTOS CLAVE:
//
// 1. Propiedades de estado reactivas:
//    - Button.down: true mientras el boton esta fisicamente presionado.
//      Se usa para feedback visual inmediato ("Press Me" -> "Pressed!").
//    - Button.hovered: true cuando el cursor esta sobre el boton.
//      No requiere MouseArea — Button lo maneja internamente.
//    - Button.checkable: convierte el boton en un toggle (on/off).
//      Button.checked refleja el estado actual.
//
// 2. Bindings reactivos en text:
//    - text: button.down ? "Pressed!" : "Press Me" cambia el texto
//      automaticamente segun el estado, sin necesidad de handlers.
//    - Este patron declarativo es preferible a cambiar text en onClicked.
//
// 3. Timer para feedback temporal:
//    - Tras un click, statusLabel muestra "Button clicked!" durante 2
//      segundos y luego se restaura. El Timer evita tener que manejar
//      el reset manualmente.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Button States & Interactions"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Tres botones que demuestran diferentes estados interactivos.
        // Cada uno usa bindings declarativos para reflejar su estado actual.
        RowLayout {
            spacing: Style.resize(15)
            Layout.fillWidth: true

            // Boton con feedback de presion: text cambia mientras esta down.
            Button {
                id: clickableButton
                text: clickableButton.down ? "Pressed!" : "Press Me"
                Layout.preferredWidth: Style.resize(150)
                Layout.preferredHeight: Style.resize(40)
                onClicked: {
                    statusLabel.text = "Button clicked!";
                    clickTimer.restart();
                }
            }

            Button {
                id: hoverButton
                text: hoverButton.hovered ? "Hovering" : "Hover Me"
                Layout.preferredWidth: Style.resize(150)
                Layout.preferredHeight: Style.resize(40)
            }

            Button {
                id: toggleButton
                text: toggleButton.checked ? "Checked" : "Checkable"
                checkable: true
                Layout.preferredWidth: Style.resize(150)
                Layout.preferredHeight: Style.resize(40)
            }
        }

        Label {
            id: statusLabel
            text: "Interact with the buttons above"
            font.pixelSize: Style.resize(14)
            color: Style.mainColor
            Layout.topMargin: Style.resize(10)

            Timer {
                id: clickTimer
                interval: 2000
                onTriggered: statusLabel.text = "Interact with the buttons above"
            }
        }

        Label {
            text: "• down: Button is being pressed\n• hovered: Mouse is over the button\n• checkable: Button can be toggled on/off"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
    }
}
