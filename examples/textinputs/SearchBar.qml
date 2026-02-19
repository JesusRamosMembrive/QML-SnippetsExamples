// =============================================================================
// SearchBar.qml — Barra de busqueda personalizada con TextInput
// =============================================================================
// Construye una barra de busqueda desde cero usando primitivas de QML
// (Rectangle + TextInput), en lugar del TextField de Qt Quick Controls.
// Esto demuestra como crear controles con apariencia y comportamiento
// totalmente personalizados.
//
// Patrones educativos:
//   - TextInput vs TextField: TextInput es el tipo primitivo de Qt Quick,
//     sin estilo ni decoracion. TextField (de Controls) envuelve TextInput
//     con fondo, bordes, placeholder, etc. Aqui usamos TextInput porque
//     queremos control total del aspecto visual.
//   - Placeholder manual: un Text superpuesto que se oculta cuando hay
//     texto escrito o el campo tiene foco. Este es exactamente el patron
//     que TextField implementa internamente.
//   - Borde reactivo al foco: border.color cambia con un binding ternario
//     y se anima con Behavior para una transicion suave.
//   - Boton de limpiar (X): solo visible cuando hay texto. Usa MouseArea
//     con hoverEnabled para feedback visual al pasar el cursor.
//   - `radius: height / 2` crea bordes completamente redondeados (pill shape).
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Search Bar"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    // -------------------------------------------------------------------------
    // Contenedor de la barra: un Rectangle con forma de pastilla (pill).
    // El borde cambia de color y grosor segun el estado de foco del input,
    // con una animacion suave de 200ms.
    // -------------------------------------------------------------------------
    Rectangle {
        Layout.fillWidth: true
        height: Style.resize(46)
        radius: height / 2
        color: Style.surfaceColor
        border.color: searchInput.activeFocus ? Style.mainColor : "#3A3D45"
        border.width: searchInput.activeFocus ? 2 : 1

        Behavior on border.color { ColorAnimation { duration: 200 } }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Style.resize(16)
            anchors.rightMargin: Style.resize(12)
            spacing: Style.resize(10)

            // Icono de busqueda: su opacidad cambia segun el foco
            Label {
                text: "\uD83D\uDD0D"
                font.pixelSize: Style.resize(18)
                opacity: searchInput.activeFocus ? 1.0 : 0.5

                Behavior on opacity { NumberAnimation { duration: 200 } }
            }

            // -----------------------------------------------------------------
            // TextInput primitivo con placeholder manual. `selectByMouse: true`
            // permite seleccionar texto con el raton (deshabilitado por defecto
            // en TextInput). `clip: true` evita que el texto desborde.
            // -----------------------------------------------------------------
            TextInput {
                id: searchInput
                Layout.fillWidth: true
                font.pixelSize: Style.resize(14)
                color: Style.fontPrimaryColor
                clip: true
                selectByMouse: true
                selectionColor: Style.mainColor

                // Placeholder manual: Text superpuesto, visible solo si no
                // hay texto y el campo no tiene foco activo
                Text {
                    anchors.fill: parent
                    text: "Search anything..."
                    font: parent.font
                    color: Style.inactiveColor
                    visible: !parent.text && !parent.activeFocus
                    verticalAlignment: Text.AlignVCenter
                }
            }

            // -----------------------------------------------------------------
            // Boton de limpiar: aparece solo cuando hay texto. MouseArea con
            // hoverEnabled cambia el fondo del circulo al pasar el cursor,
            // dando feedback visual sin usar estados explícitos.
            // -----------------------------------------------------------------
            Rectangle {
                width: Style.resize(24)
                height: width
                radius: width / 2
                color: clearMa.containsMouse ? "#4A4D55" : "transparent"
                visible: searchInput.text.length > 0

                Label {
                    anchors.centerIn: parent
                    text: "\u2715"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }

                MouseArea {
                    id: clearMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: searchInput.text = ""
                }
            }
        }
    }
}
