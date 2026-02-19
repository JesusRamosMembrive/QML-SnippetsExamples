// =============================================================================
// Main.qml — Pagina principal del modulo Teoria C++
// =============================================================================
// Visor de teoria y ejemplos de codigo C++ con navegacion tipo documentacion.
// A diferencia de las otras paginas del proyecto (que usan GridLayout de
// tarjetas), esta pagina usa un layout master-detail: panel de capitulos
// a la izquierda (ChapterPanel) y panel de contenido a la derecha
// (ContentPanel).
//
// Integracion con C++:
//   - TheoryParser: clase C++ expuesta a QML (via import theoryparser) que
//     lee archivos .md del disco y los parsea en capitulos, explicaciones
//     y secciones de codigo. Las propiedades chapters, getExplanation() y
//     getCodeSections() son accesibles desde QML.
//
// Patron master-detail:
//   - ChapterPanel emite topicSelected(chapter, display, file, display)
//   - Main.qml almacena la seleccion en propiedades locales
//   - ContentPanel lee esas propiedades y llama al parser para cargar contenido
//
// Este es un buen ejemplo de como separar responsabilidades en QML:
// la logica de parseo vive en C++, la navegacion en ChapterPanel,
// y la presentacion en ContentPanel.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils 1.0
import theoryparser

Item {
    id: root

    // -- Patron de visibilidad animada estandar del proyecto
    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    anchors.fill: parent

    // -- Estado de navegacion: que capitulo y tema estan seleccionados.
    //    Se actualizan cuando el usuario hace clic en ChapterPanel.
    //    "current*" son los nombres internos (directorios/archivos).
    //    "current*Display" son los nombres legibles para el usuario.
    property string currentChapter: ""
    property string currentChapterDisplay: ""
    property string currentTopic: ""
    property string currentTopicDisplay: ""

    // -- TheoryParser: objeto C++ que parsea los archivos Markdown de teoria.
    //    Se instancia aqui y se pasa como propiedad a ContentPanel.
    TheoryParser {
        id: parser
    }

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        // -- Layout master-detail horizontal:
        //    izquierda = panel de navegacion (ancho fijo),
        //    separador de 1px,
        //    derecha = panel de contenido (ancho flexible).
        RowLayout {
            anchors.fill: parent
            spacing: 0

            ChapterPanel {
                id: chapterPanel
                Layout.preferredWidth: Style.resize(280)
                Layout.fillHeight: true
                chapters: parser.chapters

                // -- Signal handler: cuando el usuario selecciona un tema,
                //    actualizamos las propiedades de navegacion del root.
                onTopicSelected: function(chapterName, chapterDisplay, topicFile, topicDisplay) {
                    root.currentChapter = chapterName
                    root.currentChapterDisplay = chapterDisplay
                    root.currentTopic = topicFile
                    root.currentTopicDisplay = topicDisplay
                }
            }

            // -- Separador visual entre los dos paneles
            Rectangle {
                Layout.preferredWidth: 1
                Layout.fillHeight: true
                color: "#3A3D45"
            }

            ContentPanel {
                Layout.fillWidth: true
                Layout.fillHeight: true
                parser: parser
                chapterDir: root.currentChapter
                chapterDisplay: root.currentChapterDisplay
                topicFile: root.currentTopic
                topicDisplay: root.currentTopicDisplay
            }
        }
    }
}
