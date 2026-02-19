// =============================================================================
// DraggableSplitPane.qml — Panel dividido con separador arrastrable
// =============================================================================
// Implementa un "split pane" donde el usuario puede arrastrar un divisor
// para redistribuir el espacio entre dos paneles. Este patron es comun
// en IDEs, editores de texto y exploradores de archivos.
//
// Conceptos clave demostrados:
// 1. splitPos como proporcion (0.0 a 1.0): en lugar de usar pixeles
//    absolutos, la posicion del divisor se almacena como fraccion del
//    ancho total. Esto hace que el layout sea proporcional y se adapte
//    si el contenedor cambia de tamano.
//
// 2. MouseArea con drag manual: NO se usa drag.target porque necesitamos
//    controlar la logica (limites min/max). En su lugar, se captura la
//    posicion inicial en onPressed y se calcula el delta en
//    onPositionChanged para actualizar splitPos.
//
// 3. Math.max/Math.min para limites: evita que el usuario arrastre el
//    divisor mas alla del 15% o 85%, garantizando que ambos paneles
//    siempre sean visibles.
//
// 4. Retroalimentacion visual: el divisor cambia de color al hacer hover
//    o al arrastrar, con ColorAnimation para suavizar la transicion.
//    Los puntos ("grip dots") indican que el elemento es arrastrable.
//
// 5. anchors.margins negativo: agranda el area clickeable del divisor
//    mas alla de sus limites visuales, facilitando el arrastre.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Draggable Split Pane"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        id: splitSection
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(200)

        // Proporcion del espacio que ocupa el panel izquierdo (0.0 - 1.0)
        property real splitPos: 0.5

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
            clip: true

            // Panel izquierdo: su ancho es proporcional a splitPos
            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * splitSection.splitPos - Style.resize(3)
                color: Style.surfaceColor
                radius: Style.resize(6)

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(4)

                    Label {
                        text: "Left Panel"
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: "#5B8DEF"
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Label {
                        text: Math.round(splitSection.splitPos * 100) + "%"
                        font.pixelSize: Style.resize(20)
                        font.bold: true
                        color: Style.fontPrimaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // Panel derecho: ocupa el espacio restante (1 - splitPos)
            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * (1 - splitSection.splitPos) - Style.resize(3)
                color: Style.surfaceColor
                radius: Style.resize(6)

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(4)

                    Label {
                        text: "Right Panel"
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: "#00D1A9"
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Label {
                        text: Math.round((1 - splitSection.splitPos) * 100) + "%"
                        font.pixelSize: Style.resize(20)
                        font.bold: true
                        color: Style.fontPrimaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // -----------------------------------------------------------------
            // Divisor arrastrable
            // Su posicion x esta vinculada a splitPos. El divisor no usa
            // drag.target nativo porque necesitamos calcular la posicion
            // relativa al contenedor padre, no un movimiento absoluto.
            // -----------------------------------------------------------------
            Rectangle {
                id: splitDivider
                x: parent.width * splitSection.splitPos - width / 2
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: Style.resize(6)
                color: splitDragMa.containsMouse || splitDragMa.pressed
                       ? Style.mainColor : Qt.rgba(1, 1, 1, 0.2)
                radius: Style.resize(2)

                Behavior on color { ColorAnimation { duration: 150 } }

                // Puntos de agarre: indican visualmente que se puede arrastrar
                Column {
                    anchors.centerIn: parent
                    spacing: Style.resize(3)

                    Repeater {
                        model: 3
                        Rectangle {
                            width: Style.resize(3)
                            height: Style.resize(3)
                            radius: width / 2
                            color: Qt.rgba(1, 1, 1, 0.5)
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                // MouseArea con margenes negativos para ampliar el area de
                // arrastre. cursorShape: Qt.SplitHCursor cambia el cursor
                // al icono de redimensionamiento horizontal.
                MouseArea {
                    id: splitDragMa
                    anchors.fill: parent
                    anchors.margins: -Style.resize(4)
                    hoverEnabled: true
                    cursorShape: Qt.SplitHCursor
                    drag.target: null

                    property real startX: 0
                    property real startSplit: 0

                    onPressed: function(mouse) {
                        startX = mouse.x
                        startSplit = splitSection.splitPos
                    }
                    onPositionChanged: function(mouse) {
                        if (pressed) {
                            var dx = mouse.x - startX
                            var newSplit = startSplit + dx / splitDivider.parent.width
                            splitSection.splitPos = Math.max(0.15, Math.min(0.85, newSplit))
                        }
                    }
                }
            }
        }
    }
}
