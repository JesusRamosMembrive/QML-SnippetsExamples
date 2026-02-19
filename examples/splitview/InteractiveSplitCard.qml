// =============================================================================
// InteractiveSplitCard.qml — Mezclador de colores RGB con SplitView
// =============================================================================
// Ejemplo creativo que reutiliza SplitView como control interactivo: en lugar
// de dividir paneles de contenido, los handles sirven para ajustar la
// proporción de los canales Rojo, Verde y Azul de un color.
//
// La idea es que el ancho de cada panel (relativo al ancho total) determina
// la intensidad del canal RGB correspondiente. El resultado mezclado se
// muestra en tiempo real en la barra inferior.
//
// Demuestra que SplitView no está limitado a layouts estáticos — se puede
// usar como mecanismo de entrada donde el usuario "arrastra para ajustar".
// También ilustra el binding reactivo de QML: al mover un handle, el color
// de los paneles y la vista previa se actualizan automáticamente.
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
            text: "Color Mixer"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Drag handles to mix RGB channels"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        // -- SplitView como control de mezcla RGB --
        // Tres paneles de colores primarios. Al arrastrar los handles,
        // cambian las proporciones de ancho y, por tanto, la intensidad
        // de cada canal. El truco está en usar la razón
        // panel.width / colorSplit.width como valor normalizado (0..1).
        SplitView {
            id: colorSplit
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Horizontal

            handle: Rectangle {
                implicitWidth: Style.resize(6)
                implicitHeight: Style.resize(6)
                color: SplitHandle.pressed ? "#FFFFFF" : Style.inactiveColor

                Rectangle {
                    anchors.centerIn: parent
                    width: Style.resize(2)
                    height: Style.resize(24)
                    radius: 1
                    color: "#FFFFFF"
                    opacity: 0.6
                }
            }

            // -- Canal Rojo --
            // La opacidad (alpha) del color rojo se vincula al ancho relativo
            // del panel: más ancho = más intenso. El Label muestra el valor
            // equivalente en escala 0-255 para referencia.
            Rectangle {
                id: redPanel
                SplitView.preferredWidth: colorSplit.width / 3
                SplitView.minimumWidth: Style.resize(30)
                color: Qt.rgba(1, 0, 0, redPanel.width / colorSplit.width)
                radius: Style.resize(4)

                Label {
                    anchors.centerIn: parent
                    text: "R\n" + Math.round(255 * redPanel.width / colorSplit.width)
                    font.pixelSize: Style.resize(16)
                    font.bold: true
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            // -- Canal Verde --
            Rectangle {
                id: greenPanel
                SplitView.preferredWidth: colorSplit.width / 3
                SplitView.minimumWidth: Style.resize(30)
                color: Qt.rgba(0, 0.8, 0, greenPanel.width / colorSplit.width)
                radius: Style.resize(4)

                Label {
                    anchors.centerIn: parent
                    text: "G\n" + Math.round(255 * greenPanel.width / colorSplit.width)
                    font.pixelSize: Style.resize(16)
                    font.bold: true
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            // -- Canal Azul --
            // fillWidth: true para que ocupe el espacio restante.
            // Es el último panel, así que no necesita preferredWidth.
            Rectangle {
                id: bluePanel
                SplitView.fillWidth: true
                SplitView.minimumWidth: Style.resize(30)
                color: Qt.rgba(0, 0.3, 1, bluePanel.width / colorSplit.width)
                radius: Style.resize(4)

                Label {
                    anchors.centerIn: parent
                    text: "B\n" + Math.round(255 * bluePanel.width / colorSplit.width)
                    font.pixelSize: Style.resize(16)
                    font.bold: true
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        // -- Vista previa del color mezclado --
        // Combina los tres canales usando Qt.rgba() con los valores
        // normalizados de cada panel. El binding reactivo de QML garantiza
        // que esta barra se actualice en cada frame mientras el usuario
        // arrastra un handle.
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(35)
            radius: Style.resize(6)
            color: Qt.rgba(
                redPanel.width / colorSplit.width,
                0.8 * greenPanel.width / colorSplit.width,
                bluePanel.width / colorSplit.width,
                1.0
            )

            Label {
                anchors.centerIn: parent
                text: "Mixed: rgb(" +
                      Math.round(255 * redPanel.width / colorSplit.width) + ", " +
                      Math.round(255 * 0.8 * greenPanel.width / colorSplit.width) + ", " +
                      Math.round(255 * bluePanel.width / colorSplit.width) + ")"
                font.pixelSize: Style.resize(13)
                font.bold: true
                color: "#FFFFFF"
            }
        }
    }
}
