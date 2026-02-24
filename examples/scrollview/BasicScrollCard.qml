// =============================================================================
// BasicScrollCard.qml — ScrollView vertical básico
// =============================================================================
// Demuestra el uso más simple de ScrollView: una lista larga de elementos
// dentro de un ColumnLayout que excede el área visible, generando scroll
// vertical automáticamente.
//
// ScrollView vs Flickable: ScrollView es un contenedor de conveniencia que
// agrega barras de scroll automáticas sobre un Flickable interno. Es ideal
// cuando solo necesitas scroll estándar sin personalización.
//
// Aprendizaje clave:
// - contentWidth: availableWidth fuerza que el contenido ocupe solo el ancho
//   disponible, evitando scroll horizontal innecesario
// - clip: true es necesario para que el contenido no se dibuje fuera del área
// - Repeater genera elementos dinámicamente a partir de un modelo numérico
// =============================================================================
pragma ComponentBehavior: Bound

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

        // Encabezado de la tarjeta (título + descripción)
        Label {
            text: "Basic ScrollView"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Vertical scrollable content"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        // Área de demostración: un Rectangle de fondo con clip: true actúa
        // como contenedor visual que recorta el contenido desbordante.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(4)
            clip: true

            // ScrollView genera barras de scroll automáticas cuando el
            // contenido (ColumnLayout) excede el espacio disponible.
            ScrollView {
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                contentWidth: availableWidth

                ColumnLayout {
                    width: parent.width
                    spacing: Style.resize(6)

                    // Repeater con modelo numérico: genera 25 rectángulos.
                    // La alternancia de color (index % 2) da un efecto visual
                    // de filas zebra que mejora la legibilidad.
                    Repeater {
                        model: 25
                        Rectangle {
                            required property int index
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(32)
                            radius: Style.resize(4)
                            color: index % 2 === 0 ? Style.surfaceColor : Style.cardColor

                            Label {
                                anchors.left: parent.left
                                anchors.leftMargin: Style.resize(10)
                                anchors.verticalCenter: parent.verticalCenter
                                text: "Item " + (index + 1)
                                font.pixelSize: Style.resize(13)
                                color: Style.fontPrimaryColor
                            }
                        }
                    }
                }
            }
        }
    }
}
