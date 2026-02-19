// =============================================================================
// ToolTipCard.qml — Ejemplos de ToolTip con distintos delays y contextos
// =============================================================================
//
// CONCEPTOS CLAVE:
//
// 1. ToolTip en Qt Quick Controls:
//    - ToolTip muestra texto contextual cuando el usuario pasa el cursor sobre
//      un elemento. Es fundamental para accesibilidad y descubrimiento de UI.
//    - Tiene dos propiedades temporales clave:
//      * delay: milisegundos antes de aparecer (evita tooltips accidentales)
//      * timeout: milisegundos que permanece visible antes de ocultarse solo
//
// 2. ToolTip attached property (propiedad adjunta):
//    - En controles como Button, ToolTip se puede usar como attached property:
//      ToolTip.text, ToolTip.visible, ToolTip.delay, etc.
//    - Es la forma mas comoda: no hay que crear un componente hijo explicitamente.
//    - ToolTip.visible: hovered conecta la visibilidad al estado hover del boton.
//
// 3. ToolTip como componente hijo:
//    - Para items que NO son controles (Rectangle, Item), se necesita crear
//      un ToolTip explicito como hijo de un MouseArea con hoverEnabled: true.
//    - Esto da mas control sobre posicionamiento y comportamiento.
//
// 4. Patron de delay progresivo:
//    - Los tres botones demuestran delays de 0ms, 500ms y 1500ms.
//    - En apps reales, un delay de 500-700ms es lo habitual: evita que el
//      tooltip aparezca al pasar el cursor rapidamente, pero responde
//      lo suficientemente rapido cuando el usuario se detiene con intencion.
//
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
            text: "ToolTip"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // --- Tres botones con delays progresivos ---
        // Demuestran como el delay afecta la experiencia del usuario.
        // delay: 0 es inmediato, util para iconos sin texto.
        // delay: 500 es el equilibrio tipico para la mayoria de apps.
        // delay: 1500 es para tooltips que solo se necesitan ocasionalmente.
        Button {
            text: "Instant ToolTip"
            Layout.fillWidth: true
            ToolTip.delay: 0
            ToolTip.timeout: 3000
            ToolTip.visible: hovered
            ToolTip.text: "This appears immediately!"
        }

        Button {
            text: "500ms Delay"
            Layout.fillWidth: true
            ToolTip.delay: 500
            ToolTip.timeout: 3000
            ToolTip.visible: hovered
            ToolTip.text: "This appears after 500ms"
        }

        Button {
            text: "1500ms Delay"
            Layout.fillWidth: true
            ToolTip.delay: 1500
            ToolTip.timeout: 5000
            ToolTip.visible: hovered
            ToolTip.text: "This appears after 1.5 seconds"
        }

        Item { Layout.fillHeight: true }

        // --- ToolTip en un area generica (no un Control) ---
        // Cuando el elemento no es un Control de Qt Quick Controls,
        // se necesita un MouseArea con hoverEnabled y un ToolTip hijo explicito.
        // containsMouse detecta si el cursor esta sobre el area.
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(60)
            color: Style.bgColor
            radius: Style.resize(8)
            border.color: Style.inactiveColor
            border.width: 1

            Label {
                anchors.centerIn: parent
                text: "Hover over this area"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            MouseArea {
                id: hoverArea
                anchors.fill: parent
                hoverEnabled: true
            }

            ToolTip {
                parent: hoverArea
                visible: hoverArea.containsMouse
                delay: 300
                timeout: 4000
                text: "ToolTips work on any item with a MouseArea"
            }
        }

        Label {
            text: "ToolTip shows contextual help on hover with configurable delay and timeout"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
