// =============================================================================
// RadioButtonCard.qml — Tarjeta con RadioButtons agrupados en un ButtonGroup
// =============================================================================
// Demuestra el patron de seleccion exclusiva usando RadioButton + ButtonGroup.
//
// ButtonGroup es el componente clave: garantiza que solo UN RadioButton del
// grupo puede estar seleccionado a la vez. Cada RadioButton se asocia al
// grupo mediante la propiedad adjunta ButtonGroup.group.
//
// Patron educativo: un rectangulo de preview cambia de tamanyo en funcion
// del RadioButton seleccionado, demostrando como los bindings reactivos
// de QML responden automaticamente a cambios de estado sin senales manuales.
// La animacion usa Easing.OutBack para un efecto de "rebote" natural.
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
            text: "RadioButton Group"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // -----------------------------------------------------------------
        // ButtonGroup: componente no visual que gestiona la exclusividad.
        // Todos los RadioButton que se asocien a este grupo seran mutuamente
        // excluyentes — al seleccionar uno, los demas se deseleccionan.
        // -----------------------------------------------------------------
        ButtonGroup {
            id: sizeGroup
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(5)

            RadioButton {
                id: radioSmall
                text: "Small"
                ButtonGroup.group: sizeGroup
            }

            RadioButton {
                id: radioMedium
                text: "Medium"
                checked: true
                ButtonGroup.group: sizeGroup
            }

            RadioButton {
                id: radioLarge
                text: "Large"
                ButtonGroup.group: sizeGroup
            }
        }

        // -----------------------------------------------------------------
        // Preview interactivo: el tamanyo del rectangulo depende de cual
        // RadioButton esta checked, usando operadores ternarios encadenados.
        // Behavior on width anima el cambio con easing OutBack (rebote).
        // -----------------------------------------------------------------
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(130)

            Rectangle {
                id: previewRect
                anchors.centerIn: parent
                width: radioSmall.checked ? Style.resize(40)
                       : radioMedium.checked ? Style.resize(80)
                       : Style.resize(120)
                height: width
                color: Style.mainColor
                radius: Style.resize(8)

                Behavior on width {
                    NumberAnimation { duration: 300; easing.type: Easing.OutBack }
                }

                Label {
                    anchors.centerIn: parent
                    text: previewRect.width.toFixed(0) + "px"
                    color: "white"
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                }
            }
        }

        Label {
            text: "Selected size: " + (radioSmall.checked ? "Small" : radioMedium.checked ? "Medium" : "Large")
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
        }

        Label {
            text: "RadioButtons in a ButtonGroup ensure exclusive selection"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item { Layout.fillHeight: true }
    }
}
