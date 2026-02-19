// =============================================================================
// SmartHomeCard.qml — Demo interactiva combinando Switch, CheckBox y RadioButton
// =============================================================================
// Esta tarjeta muestra como los tres tipos de controles de seleccion pueden
// trabajar juntos en un escenario real: un panel de control de hogar inteligente.
//
// Patron clave — interdependencia de controles:
//   - CheckBox "Enable Zone": habilita/deshabilita todos los demas controles
//     mediante la propiedad 'enabled' (los controles deshabilitados se atenuan)
//   - Switch "Dark Mode": cambia el tema visual de la tarjeta en tiempo real
//     usando ColorAnimation para transiciones suaves
//   - RadioButtons de temperatura: seleccion exclusiva dentro de un ButtonGroup
//
// Esto demuestra que los controles de Qt Quick Controls 2 son componibles:
// la propiedad 'enabled' se propaga visualmente (el estilo muestra los controles
// atenuados) y funcionalmente (no responden a input del usuario).
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

// El color de fondo reacciona al Switch de Dark Mode con ColorAnimation.
// Esto demuestra que propiedades como 'color' pueden depender de estados
// de otros componentes, y las animaciones suavizan la transicion.
Rectangle {
    id: root
    color: darkModeSwitch.checked ? "#1E2028" : Style.cardColor
    radius: Style.resize(8)

    Behavior on color {
        ColorAnimation { duration: 300 }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Interactive Demo - Smart Home Panel"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // -----------------------------------------------------------------
        // CheckBox maestro: controla el 'enabled' de todos los controles
        // inferiores. Cuando enabled=false, Qt Quick Controls atenua el
        // componente automaticamente (manejado por el estilo).
        // -----------------------------------------------------------------
        CheckBox {
            id: enableZoneCheckBox
            text: "Enable Zone"
            checked: true
        }

        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(1)
            color: darkModeSwitch.checked ? "#3A3D45" : Style.bgColor
        }

        Switch {
            id: darkModeSwitch
            text: "Dark Mode"
            enabled: enableZoneCheckBox.checked
        }

        Label {
            text: "Temperature:"
            font.pixelSize: Style.resize(14)
            color: darkModeSwitch.checked ? "#CCC" : Style.fontSecondaryColor
            font.bold: true
        }

        ButtonGroup {
            id: tempGroup
        }

        RowLayout {
            spacing: Style.resize(10)

            RadioButton {
                id: tempLow
                text: "Low"
                ButtonGroup.group: tempGroup
                enabled: enableZoneCheckBox.checked
            }

            RadioButton {
                id: tempMedium
                text: "Medium"
                checked: true
                ButtonGroup.group: tempGroup
                enabled: enableZoneCheckBox.checked
            }

            RadioButton {
                id: tempHigh
                text: "High"
                ButtonGroup.group: tempGroup
                enabled: enableZoneCheckBox.checked
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(1)
            color: darkModeSwitch.checked ? "#3A3D45" : Style.bgColor
        }

        // -----------------------------------------------------------------
        // Resumen reactivo: resume el estado de TODOS los controles en una
        // sola etiqueta. Cada binding se recalcula automaticamente cuando
        // cualquier control cambia, sin necesidad de handlers manuales.
        // Los colores del texto tambien reaccionan al modo oscuro.
        // -----------------------------------------------------------------
        Label {
            text: "Zone: " + (enableZoneCheckBox.checked ? "Enabled" : "Disabled")
                  + "  |  Mode: " + (darkModeSwitch.checked ? "Dark" : "Light")
                  + "  |  Temp: " + (tempLow.checked ? "Low" : tempMedium.checked ? "Medium" : "High")
            font.pixelSize: Style.resize(13)
            color: darkModeSwitch.checked ? "#CCC" : Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Label {
            text: "Controls interact: CheckBox enables the zone, Switch toggles theme, RadioButtons select temperature"
            font.pixelSize: Style.resize(12)
            color: darkModeSwitch.checked ? "#999" : Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item { Layout.fillHeight: true }
    }
}
