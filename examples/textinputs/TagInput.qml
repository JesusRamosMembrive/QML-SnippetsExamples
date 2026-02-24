// =============================================================================
// TagInput.qml — Sistema de etiquetas (tags) con entrada y eliminacion
// =============================================================================
// Implementa un campo de entrada de etiquetas (tags/chips) similar al que se
// encuentra en Gmail, Stack Overflow o cualquier sistema de categorizacion.
// El usuario escribe texto y presiona Enter para agregar una etiqueta; puede
// eliminarla haciendo clic en la X de cada chip.
//
// Patrones educativos:
//   - Inmutabilidad de arrays en QML: las propiedades `var` que contienen
//     arrays NO notifican cambios si se mutan in-place (push, splice).
//     Por eso addTag() usa `concat()` y removeTag() usa `slice()` + `splice()`
//     para crear una NUEVA referencia de array, forzando la re-evaluacion
//     de los bindings. Este es uno de los "gotchas" mas comunes en QML.
//   - Flow layout: a diferencia de Row/RowLayout, Flow envuelve los hijos
//     a la siguiente linea cuando no caben en el ancho disponible. Ideal
//     para chips/tags cuya cantidad es variable.
//   - Repeater con model numerico: `model: tags.length` regenera todos los
//     chips cuando el array cambia. Cada chip accede a su texto via
//     `tagContainer.tags[index]`.
//   - Colores ciclicos: `tagColors[index % tagColors.length]` asigna
//     colores de forma rotativa, evitando el desbordamiento del indice.
//   - Qt.rgba() con canal alfa: crea un fondo semitransparente usando
//     los componentes RGB del color del chip con alfa 0.2, generando un
//     efecto visual cohesivo sin definir colores adicionales.
//   - Keys.onReturnPressed + Keys.onEnterPressed: en Qt, Return (teclado
//     principal) y Enter (teclado numerico) son teclas distintas. Se
//     manejan ambas para compatibilidad completa.
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
        text: "Tag Input"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    // -------------------------------------------------------------------------
    // Contenedor principal: Rectangle con borde reactivo al foco del TextInput
    // interno. implicitHeight se calcula automaticamente a partir del Flow,
    // por lo que la altura crece al agregar mas tags.
    // -------------------------------------------------------------------------
    Rectangle {
        id: tagContainer
        Layout.fillWidth: true
        implicitHeight: tagFlow.implicitHeight + Style.resize(20)
        radius: Style.resize(8)
        color: Style.surfaceColor
        border.color: tagInput.activeFocus ? Style.mainColor : "#3A3D45"
        border.width: tagInput.activeFocus ? 2 : 1

        Behavior on border.color { ColorAnimation { duration: 200 } }

        // Estado: array de tags y paleta de colores ciclica
        property var tags: ["QML", "Qt Quick", "JavaScript"]

        property list<color> tagColors: [
            "#4FC3F7", "#66BB6A", "#FF8A65",
            "#CE93D8", "#FFD54F", "#EF5350",
            "#26A69A", "#AB47BC", "#42A5F5"
        ]

        // -----------------------------------------------------------------
        // addTag: verifica que no este vacio ni duplicado. Usa concat()
        // en vez de push() para crear un NUEVO array — si usaramos push(),
        // QML no detectaria el cambio porque la referencia del array
        // sigue siendo la misma.
        // -----------------------------------------------------------------
        function addTag(text) {
            var t = text.trim()
            if (t.length > 0 && tags.indexOf(t) === -1) {
                tags = tags.concat([t])
            }
        }

        // removeTag: crea una copia con slice(), elimina el elemento con
        // splice(), y reasigna para forzar la notificacion de cambio.
        function removeTag(idx) {
            var copy = tags.slice()
            copy.splice(idx, 1)
            tags = copy
        }

        // -----------------------------------------------------------------
        // Flow: layout que envuelve automaticamente los hijos a la siguiente
        // fila. Los chips y el TextInput coexisten dentro del Flow, dando
        // la apariencia de un campo de texto con etiquetas inline.
        // -----------------------------------------------------------------
        Flow {
            id: tagFlow
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Style.resize(10)
            spacing: Style.resize(6)

            Repeater {
                model: tagContainer.tags.length

                // Cada chip: un Rectangle con borde coloreado y fondo
                // semitransparente creado con Qt.rgba() + alfa 0.2
                Rectangle {
                    id: tagChip
                    required property int index

                    property string tagText: tagContainer.tags[index]
                    property string chipColor: tagContainer.tagColors[index % tagContainer.tagColors.length]

                    width: chipRow.implicitWidth + Style.resize(16)
                    height: Style.resize(30)
                    radius: height / 2
                    color: Qt.rgba(Qt.color(chipColor).r,
                                   Qt.color(chipColor).g,
                                   Qt.color(chipColor).b, 0.2)
                    border.color: chipColor
                    border.width: 1

                    RowLayout {
                        id: chipRow
                        anchors.centerIn: parent
                        spacing: Style.resize(4)

                        Label {
                            text: tagChip.tagText
                            font.pixelSize: Style.resize(12)
                            font.bold: true
                            color: tagChip.chipColor
                        }

                        // Boton X para eliminar: anchors.margins negativo
                        // amplía el area clickeable mas alla del texto
                        Label {
                            text: "\u2715"
                            font.pixelSize: Style.resize(10)
                            color: tagChip.chipColor
                            opacity: tagRemoveMa.containsMouse ? 1.0 : 0.6

                            MouseArea {
                                id: tagRemoveMa
                                anchors.fill: parent
                                anchors.margins: -4
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: tagContainer.removeTag(tagChip.index)
                            }
                        }
                    }
                }
            }

            // -----------------------------------------------------------------
            // TextInput inline dentro del Flow: se comporta como el "cursor"
            // al final de los tags. Al presionar Enter, agrega el tag y
            // limpia el campo. Se manejan Return y Enter por separado
            // porque Qt los trata como teclas distintas.
            // -----------------------------------------------------------------
            TextInput {
                id: tagInput
                width: Style.resize(180)
                height: Style.resize(30)
                font.pixelSize: Style.resize(13)
                color: Style.fontPrimaryColor
                clip: true
                verticalAlignment: TextInput.AlignVCenter
                selectByMouse: true
                selectionColor: Style.mainColor

                // Placeholder manual
                Text {
                    anchors.fill: parent
                    text: "Type and press Enter to add..."
                    font: parent.font
                    color: Style.inactiveColor
                    visible: !parent.text && !parent.activeFocus
                    verticalAlignment: Text.AlignVCenter
                }

                Keys.onReturnPressed: {
                    tagContainer.addTag(text)
                    text = ""
                }
                Keys.onEnterPressed: {
                    tagContainer.addTag(text)
                    text = ""
                }
            }
        }
    }
}
