// =============================================================================
// CodeBlock.qml — Bloque expandible de codigo con resultado
// =============================================================================
// Componente reutilizable que muestra un ejemplo de codigo C++ con su
// resultado esperado. Funciona como un "accordion": colapsado muestra solo
// el titulo, expandido muestra el codigo fuente y opcionalmente la salida.
//
// Estructura visual (expandido):
//   +-------------------------------+
//   | ▼ Titulo del ejemplo          |  <- Header (siempre visible)
//   +-------------------------------+
//   | codigo fuente en Markdown     |  <- Code content (solo expandido)
//   +-------------------------------+
//   | Resultado:                    |  <- Result section (solo si hay result)
//   | salida del programa           |
//   +-------------------------------+
//
// Patrones importantes:
//   - textFormat: TextEdit.MarkdownText permite mostrar codigo con formato
//     Markdown, incluyendo bloques de codigo con syntax.
//   - implicitHeight basado en contenido: el Rectangle padre ajusta su
//     altura segun el contenido del TextEdit, permitiendo que el layout
//     padre (ColumnLayout) distribuya el espacio correctamente.
//   - Esquinas redondeadas selectivas: se usan Rectangles superpuestos
//     para redondear solo las esquinas deseadas (arriba siempre, abajo
//     solo cuando esta colapsado o en la seccion de resultado).
//   - selectByMouse: true permite al usuario seleccionar y copiar codigo.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils 1.0

Rectangle {
    id: root

    property string title: ""
    property string code: ""
    property string result: ""
    property bool expanded: false

    radius: Style.resize(8)
    color: "#1E1E2E"
    implicitHeight: blockColumn.implicitHeight

    ColumnLayout {
        id: blockColumn
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 0

        // -- Header clickeable: muestra titulo y flecha de expand/collapse.
        //    Las esquinas redondeadas se ajustan segun el estado expandido.
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(40)
            color: "#2D2D3D"
            radius: root.expanded ? 0 : Style.resize(8)

            // -- Truco para esquinas selectivas: Rectangle superpuesto en
            //    la parte superior asegura esquinas redondeadas arriba siempre.
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: Style.resize(8)
                color: parent.color
                radius: Style.resize(8)
            }

            // -- Esquinas inferiores redondeadas solo cuando esta colapsado
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: Style.resize(8)
                color: parent.color
                radius: root.expanded ? 0 : Style.resize(8)
                visible: !root.expanded
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.resize(12)
                anchors.rightMargin: Style.resize(12)

                Label {
                    text: root.expanded ? "\u25BC" : "\u25B6"
                    font.pixelSize: Style.resize(10)
                    color: Style.mainColor
                }

                Label {
                    text: root.title
                    font.pixelSize: Style.resize(13)
                    font.bold: true
                    color: "#E0E0E0"
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.expanded = !root.expanded
            }
        }

        // -- Seccion de codigo: TextEdit con formato Markdown.
        //    Usar Markdown permite que el parser C++ envie el codigo
        //    envuelto en bloques ``` para resaltado basico.
        Rectangle {
            Layout.fillWidth: true
            color: "#1E1E2E"
            visible: root.expanded
            implicitHeight: codeEdit.implicitHeight + Style.resize(24)

            TextEdit {
                id: codeEdit
                anchors.fill: parent
                anchors.margins: Style.resize(12)
                text: root.code
                textFormat: TextEdit.MarkdownText
                readOnly: true
                wrapMode: TextEdit.WordWrap
                font.family: "Consolas"
                font.pixelSize: Style.resize(12)
                color: "#D4D4D4"
                selectByMouse: true
                selectedTextColor: "white"
                selectionColor: Style.mainColor
            }
        }

        // -- Seccion de resultado: solo visible si hay resultado Y esta expandido.
        //    Color verde (#A0D0A0) para diferenciar la salida del codigo fuente.
        Rectangle {
            Layout.fillWidth: true
            color: "#252535"
            visible: root.expanded && root.result !== ""
            implicitHeight: resultColumn.implicitHeight + Style.resize(16)
            radius: Style.resize(8)

            // -- Solo esquinas inferiores redondeadas (cierra el bloque)
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: Style.resize(8)
                color: parent.color
            }

            ColumnLayout {
                id: resultColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: Style.resize(12)
                spacing: Style.resize(4)

                // -- Linea separadora entre codigo y resultado
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#3D3D4D"
                }

                Label {
                    text: "Resultado:"
                    font.pixelSize: Style.resize(11)
                    font.bold: true
                    color: Style.mainColor
                }

                TextEdit {
                    Layout.fillWidth: true
                    text: root.result
                    readOnly: true
                    wrapMode: TextEdit.WordWrap
                    font.family: "Consolas"
                    font.pixelSize: Style.resize(12)
                    color: "#A0D0A0"
                    selectByMouse: true
                }
            }
        }
    }
}
