// =============================================================================
// VerticalSplitCard.qml — SplitView vertical con tres paneles
// =============================================================================
// Demuestra un SplitView orientado verticalmente con tres secciones:
// Header, Content y Footer, simulando un layout clásico de aplicación web.
//
// A diferencia del ejemplo horizontal (2 paneles), este usa 3 paneles para
// mostrar que SplitView acepta cualquier cantidad de hijos. Cada handle
// entre paneles es independiente y arrastrable.
//
// Conceptos clave:
// - orientation: Qt.Vertical divide de arriba hacia abajo
// - El handle es horizontal (ancho > alto), adaptado a la orientación
// - SplitView.fillHeight en el panel central absorbe el espacio restante
// - preferredHeight + minimumHeight en header/footer para límites razonables
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
            text: "Vertical SplitView"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        SplitView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Vertical

            // -- Handle horizontal --
            // Nótese que el indicador de agarre ("grip") aquí es horizontal
            // (width: 30, height: 2), al contrario del ejemplo horizontal
            // donde era vertical. Esto da pistas visuales de la dirección
            // en que se puede arrastrar.
            handle: Rectangle {
                implicitWidth: Style.resize(6)
                implicitHeight: Style.resize(6)
                color: SplitHandle.pressed ? Style.mainColor
                     : SplitHandle.hovered ? Qt.lighter(Style.mainColor, 1.5)
                     : Style.inactiveColor

                Rectangle {
                    anchors.centerIn: parent
                    width: Style.resize(30)
                    height: Style.resize(2)
                    radius: Style.resize(1)
                    color: "#FFFFFF"
                    opacity: 0.5
                }
            }

            // -- Panel superior (Header) --
            // preferredHeight define el alto inicial; minimumHeight evita
            // que el usuario lo colapse por completo.
            Rectangle {
                SplitView.preferredHeight: root.height * 0.25
                SplitView.minimumHeight: Style.resize(50)
                color: Style.bgColor
                radius: Style.resize(4)

                Label {
                    anchors.centerIn: parent
                    text: "Header — " + Math.round(parent.height) + " px"
                    font.pixelSize: Style.resize(14)
                    color: Style.mainColor
                }
            }

            // -- Panel central (Content) --
            // fillHeight: true absorbe todo el espacio sobrante. Cuando el
            // usuario agranda header o footer, este panel se encoge y viceversa.
            Rectangle {
                SplitView.fillHeight: true
                color: Style.surfaceColor
                radius: Style.resize(4)

                Label {
                    anchors.centerIn: parent
                    text: "Content — " + Math.round(parent.height) + " px"
                    font.pixelSize: Style.resize(14)
                    color: Style.fontPrimaryColor
                }
            }

            // -- Panel inferior (Footer) --
            Rectangle {
                SplitView.preferredHeight: root.height * 0.2
                SplitView.minimumHeight: Style.resize(40)
                color: Style.bgColor
                radius: Style.resize(4)

                Label {
                    anchors.centerIn: parent
                    text: "Footer — " + Math.round(parent.height) + " px"
                    font.pixelSize: Style.resize(14)
                    color: Style.inactiveColor
                }
            }
        }
    }
}
