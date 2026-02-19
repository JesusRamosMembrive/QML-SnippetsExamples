// =============================================================================
// NestedSplitCard.qml — SplitViews anidados (layout estilo IDE)
// =============================================================================
// Demuestra cómo anidar un SplitView dentro de otro para crear layouts
// complejos como los de un IDE: explorador de archivos a la izquierda,
// editor principal en el centro y terminal en la parte inferior.
//
// La técnica clave es colocar un SplitView vertical DENTRO de un panel
// del SplitView horizontal externo. Cada SplitView puede tener su propio
// handle personalizado, aunque aquí ambos comparten un estilo minimalista.
//
// Este patrón es muy común en aplicaciones de escritorio (VS Code, Qt Creator)
// y demuestra que SplitView se compone de forma natural con sí mismo.
// =============================================================================

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

        Label {
            text: "Nested SplitView (IDE Layout)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // -- SplitView externo (horizontal) --
        // Divide la interfaz en: explorador de archivos | área principal.
        // El handle es minimalista (solo cambia de color al presionar).
        SplitView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Horizontal

            handle: Rectangle {
                implicitWidth: Style.resize(4)
                implicitHeight: Style.resize(4)
                color: SplitHandle.pressed ? Style.mainColor : Style.inactiveColor
            }

            // -- Panel izquierdo: Explorador de archivos --
            // Simula un árbol de archivos con Labels estáticos. En una app
            // real, se usaría un TreeView o ListView con un modelo de archivos.
            // El Item con fillHeight al final empuja todo el contenido arriba.
            Rectangle {
                SplitView.preferredWidth: root.width * 0.25
                SplitView.minimumWidth: Style.resize(60)
                color: Style.bgColor
                radius: Style.resize(4)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(8)
                    spacing: Style.resize(4)

                    Label { text: "Explorer"; font.pixelSize: Style.resize(12); font.bold: true; color: Style.mainColor }
                    Label { text: "\u25BE src/"; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                    Label { text: "   main.cpp"; font.pixelSize: Style.resize(11); color: Style.fontPrimaryColor }
                    Label { text: "   app.h"; font.pixelSize: Style.resize(11); color: Style.fontPrimaryColor }
                    Label { text: "\u25BE qml/"; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                    Label { text: "   Main.qml"; font.pixelSize: Style.resize(11); color: Style.fontPrimaryColor }
                    Item { Layout.fillHeight: true }
                }
            }

            // -- SplitView interno (vertical) --
            // Anidado dentro del panel derecho del SplitView externo.
            // Divide verticalmente en: editor (arriba) y terminal (abajo).
            // SplitView.fillWidth: true hace que este SplitView ocupe
            // todo el espacio restante después del explorador.
            SplitView {
                SplitView.fillWidth: true
                orientation: Qt.Vertical

                handle: Rectangle {
                    implicitWidth: Style.resize(4)
                    implicitHeight: Style.resize(4)
                    color: SplitHandle.pressed ? Style.mainColor : Style.inactiveColor
                }

                // Área del editor — ocupa el espacio restante
                Rectangle {
                    SplitView.fillHeight: true
                    color: Style.surfaceColor
                    radius: Style.resize(4)

                    Label {
                        anchors.centerIn: parent
                        text: "Editor"
                        font.pixelSize: Style.resize(14)
                        color: Style.fontPrimaryColor
                    }
                }

                // -- Panel de terminal --
                // Color oscuro (#0D0F12) para simular una terminal real.
                // Usa font.family: "Consolas" para tipografía monoespaciada,
                // reforzando la apariencia de línea de comandos.
                Rectangle {
                    SplitView.preferredHeight: root.height * 0.25
                    SplitView.minimumHeight: Style.resize(40)
                    color: "#0D0F12"
                    radius: Style.resize(4)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(8)
                        spacing: Style.resize(2)

                        Label { text: "Terminal"; font.pixelSize: Style.resize(12); font.bold: true; color: Style.mainColor }
                        Label { text: "$ cmake --build build"; font.pixelSize: Style.resize(11); color: "#66BB6A"; font.family: "Consolas" }
                        Label { text: "Build finished."; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor; font.family: "Consolas" }
                        Item { Layout.fillHeight: true }
                    }
                }
            }
        }
    }
}
