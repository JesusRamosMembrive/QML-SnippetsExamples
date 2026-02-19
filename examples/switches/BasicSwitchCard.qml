// =============================================================================
// BasicSwitchCard.qml — Tarjeta con ejemplos basicos del componente Switch
// =============================================================================
// Demuestra el uso del control Switch nativo de Qt Quick Controls 2 en sus
// tres estados mas comunes:
//   - Desactivado (checked: false por defecto)
//   - Activado (checked: true)
//   - Deshabilitado (enabled: false) — el usuario no puede interactuar
//
// El aspecto visual del Switch viene del estilo custom definido en
// styles/qmlsnippetsstyle/. Aqui solo se usa la API declarativa del componente.
//
// Patron educativo: la etiqueta inferior muestra el estado actual de cada
// Switch usando bindings reactivos — no hay senales ni handlers manuales,
// el texto se actualiza automaticamente cuando cambia checked.
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
        spacing: Style.resize(20)

        Label {
            text: "Basic Switch"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // -----------------------------------------------------------------
        // Tres variantes de Switch: normal, pre-activado y deshabilitado.
        // Switch hereda de AbstractButton, asi que tiene text, checked, enabled.
        // El estilo (track, knob, colores) se define externamente en el
        // modulo qmlsnippetsstyle — aqui no necesitamos configurar nada visual.
        // -----------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(15)

            Switch {
                id: wifiSwitch
                text: "Wi-Fi"
            }

            Switch {
                id: bluetoothSwitch
                text: "Bluetooth"
                checked: true
            }

            Switch {
                id: airplaneSwitch
                text: "Airplane Mode"
                enabled: false
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(1)
            color: Style.bgColor
        }

        // -----------------------------------------------------------------
        // Resumen reactivo: binding declarativo que se recalcula cada vez
        // que cualquier Switch cambia su propiedad checked. Esto demuestra
        // la reactividad de QML — no se necesita ningun onCheckedChanged.
        // -----------------------------------------------------------------
        Label {
            text: "Wi-Fi: " + (wifiSwitch.checked ? "ON" : "OFF")
                  + "  |  Bluetooth: " + (bluetoothSwitch.checked ? "ON" : "OFF")
                  + "  |  Airplane: " + (airplaneSwitch.checked ? "ON" : "OFF")
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Label {
            text: "Switch provides a toggleable on/off control with animated indicator"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item { Layout.fillHeight: true }
    }
}
