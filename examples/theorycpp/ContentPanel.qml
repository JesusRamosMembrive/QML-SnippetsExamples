// =============================================================================
// ContentPanel.qml — Panel de contenido con teoria y ejemplos de codigo
// =============================================================================
// Panel derecho del visor de teoria C++. Muestra la explicacion teorica
// (en Markdown) y los bloques de codigo de ejemplo (usando CodeBlock.qml)
// para el tema seleccionado.
//
// Flujo de carga de contenido:
//   1. ChapterPanel emite topicSelected -> Main.qml actualiza propiedades
//   2. onChapterDirChanged / onTopicFileChanged disparan loadContent()
//   3. loadContent() llama a parser.getExplanationHtml() y parser.getCodeSections()
//   4. Los resultados se asignan a propiedades locales que alimentan la UI
//   5. contentFlickable.contentY = 0 resetea el scroll al inicio
//
// Patrones importantes:
//   - Flickable en vez de ScrollView: da mas control sobre el comportamiento
//     del scroll (boundsBehavior, ScrollBar manual). Util cuando se necesita
//     resetear contentY programaticamente.
//   - Pantalla de bienvenida condicional: visible cuando chapterDir esta
//     vacio, se oculta automaticamente al seleccionar un tema.
//   - Breadcrumb con separador Unicode (\u203A): patron simple y efectivo
//     para mostrar la ruta de navegacion sin necesitar un componente especial.
//   - implicitHeight basado en contenido: los TextEdit y CodeBlocks reportan
//     su altura ideal, y el Flickable la usa como contentHeight.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils 1.0
import theoryparser

Item {
    id: root

    // -- Referencia al parser C++ y propiedades de navegacion.
    //    Estas se asignan desde Main.qml cuando el usuario selecciona un tema.
    property TheoryParser parser
    property string chapterDir: ""
    property string chapterDisplay: ""
    property string topicFile: ""
    property string topicDisplay: ""

    // -- Contenido cargado: se actualizan en loadContent()
    property string explanationHtml: ""
    property var codeSections: []

    // -- Recargar contenido cuando cambia el capitulo o tema seleccionado
    onChapterDirChanged: loadContent()
    onTopicFileChanged: loadContent()

    // -- Funcion que llama al parser C++ para obtener el contenido.
    //    Usa getExplanationHtml() para obtener HTML estilizado, pasando
    //    los colores del tema actual para que los headers, codigo inline
    //    y listas se rendericen con la paleta correcta.
    //    Resetea el scroll para que el nuevo contenido empiece desde arriba.
    function loadContent() {
        if (chapterDir === "" || topicFile === "")
            return

        explanationHtml = parser.getExplanationHtml(
            chapterDir, topicFile,
            Style.mainColor, Style.fontPrimaryColor,
            Style.fontSecondaryColor, "#1E1E2E"
        )
        codeSections = parser.getCodeSections(chapterDir, topicFile)
        contentFlickable.contentY = 0
    }

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // -- Breadcrumb: muestra "Capitulo > Tema" o mensaje de instruccion.
            //    Cambia de estilo segun si hay algo seleccionado o no.
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(50)
                color: Style.cardColor

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(20)
                    anchors.rightMargin: Style.resize(20)
                    spacing: Style.resize(8)

                    Label {
                        text: root.chapterDir !== ""
                              ? root.chapterDisplay + "  \u203A  " + root.topicDisplay
                              : "Selecciona un tema del panel izquierdo"
                        font.pixelSize: Style.resize(14)
                        font.bold: root.chapterDir !== ""
                        color: root.chapterDir !== "" ? Style.fontPrimaryColor : Style.inactiveColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                // -- Linea separadora inferior
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 1
                    color: "#3A3D45"
                }
            }

            // -- Area de contenido scrolleable con Flickable.
            //    Se usa Flickable (no ScrollView) para poder resetear
            //    contentY programaticamente al cambiar de tema.
            Flickable {
                id: contentFlickable
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentWidth: width
                contentHeight: contentColumn.height
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }

                ColumnLayout {
                    id: contentColumn
                    width: contentFlickable.width
                    spacing: Style.resize(16)

                    // -- Pantalla de bienvenida: visible solo cuando no hay
                    //    ningun tema seleccionado.
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(300)
                        visible: root.chapterDir === ""

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: Style.resize(16)

                            Label {
                                text: "Teoria C++"
                                font.pixelSize: Style.resize(32)
                                font.bold: true
                                color: Style.mainColor
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Label {
                                text: "Selecciona un capitulo y tema del panel izquierdo\npara ver la teoria y ejemplos de codigo."
                                font.pixelSize: Style.resize(14)
                                color: Style.inactiveColor
                                horizontalAlignment: Text.AlignHCenter
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }

                    // -- Encabezado de la seccion de explicacion
                    Label {
                        Layout.leftMargin: Style.resize(20)
                        Layout.topMargin: Style.resize(16)
                        text: "Explicacion"
                        font.pixelSize: Style.resize(16)
                        font.bold: true
                        color: Style.fontPrimaryColor
                        visible: root.chapterDir !== ""
                    }

                    // -- Seccion de teoria: TextEdit con HTML estilizado.
                    //    El HTML viene de parser.getExplanationHtml() con estilos
                    //    inline para headers coloreados, bloques de codigo con fondo
                    //    oscuro, listas con bullets accent, y blockquotes con borde.
                    //    La barra accent izquierda (4px) da identidad visual al card.
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.leftMargin: Style.resize(20)
                        Layout.rightMargin: Style.resize(20)
                        radius: Style.resize(8)
                        color: Style.cardColor
                        visible: root.chapterDir !== ""
                        implicitHeight: explanationEdit.implicitHeight + Style.resize(40)

                        // -- Barra accent izquierda
                        Rectangle {
                            width: Style.resize(4)
                            height: parent.height
                            color: Style.mainColor
                            radius: Style.resize(4)
                            anchors.left: parent.left
                        }

                        TextEdit {
                            id: explanationEdit
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            anchors.leftMargin: Style.resize(24)
                            text: root.explanationHtml
                            textFormat: TextEdit.RichText
                            readOnly: true
                            wrapMode: TextEdit.WordWrap
                            font.pixelSize: Style.resize(14)
                            color: Style.fontPrimaryColor
                            selectByMouse: true
                            selectedTextColor: "white"
                            selectionColor: Style.mainColor
                        }
                    }

                    // -- Separador visual entre explicacion y ejemplos de codigo
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.leftMargin: Style.resize(40)
                        Layout.rightMargin: Style.resize(40)
                        height: 1
                        color: Style.mainColor
                        opacity: 0.3
                        visible: root.codeSections.length > 0
                    }

                    // -- Encabezado de la seccion de codigo con contador
                    Label {
                        Layout.leftMargin: Style.resize(20)
                        text: "Ejemplos de Codigo (" + root.codeSections.length + ")"
                        font.pixelSize: Style.resize(16)
                        font.bold: true
                        color: Style.fontPrimaryColor
                        visible: root.codeSections.length > 0
                    }

                    // -- Bloques de codigo: un CodeBlock por cada seccion
                    //    devuelta por parser.getCodeSections().
                    //    Cada seccion tiene {title, code, result}.
                    Repeater {
                        model: root.codeSections

                        CodeBlock {
                            required property var modelData
                            required property int index

                            Layout.fillWidth: true
                            Layout.leftMargin: Style.resize(20)
                            Layout.rightMargin: Style.resize(20)
                            title: modelData.title
                            code: modelData.code
                            result: modelData.result
                        }
                    }

                    // -- Espaciador inferior para que el ultimo bloque no
                    //    quede pegado al borde de la ventana.
                    Item {
                        Layout.preferredHeight: Style.resize(40)
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
