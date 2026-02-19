// =============================================================================
// HorizontalSplitCard.qml — SplitView horizontal básico
// =============================================================================
// Demuestra el uso más simple de SplitView: dos paneles divididos
// horizontalmente (sidebar + contenido principal). El usuario arrastra
// el handle para redimensionar los paneles.
//
// Conceptos clave:
// - orientation: Qt.Horizontal para dividir de izquierda a derecha
// - handle personalizado con feedback visual (hover/pressed)
// - SplitView.preferredWidth vs SplitView.fillWidth
// - SplitView.minimumWidth para limitar el tamaño mínimo
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
            text: "Horizontal SplitView"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        SplitView {
            id: hSplit
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Horizontal

            // -- Handle personalizado --
            // SplitView permite reemplazar el handle por defecto con cualquier
            // componente visual. Usamos SplitHandle.pressed y SplitHandle.hovered
            // (propiedades attached) para dar retroalimentación visual al usuario.
            // El rectángulo interior blanco actúa como indicador de agarre ("grip").
            handle: Rectangle {
                implicitWidth: Style.resize(6)
                implicitHeight: Style.resize(6)
                color: SplitHandle.pressed ? Style.mainColor
                     : SplitHandle.hovered ? Qt.lighter(Style.mainColor, 1.5)
                     : Style.inactiveColor

                Rectangle {
                    anchors.centerIn: parent
                    width: Style.resize(2)
                    height: Style.resize(30)
                    radius: Style.resize(1)
                    color: "#FFFFFF"
                    opacity: 0.5
                }
            }

            // -- Panel izquierdo (Sidebar) --
            // preferredWidth establece el ancho inicial (30% del contenedor).
            // minimumWidth evita que el usuario colapse el panel por debajo
            // de un umbral usable.
            Rectangle {
                SplitView.preferredWidth: root.width * 0.3
                SplitView.minimumWidth: Style.resize(80)
                color: Style.bgColor
                radius: Style.resize(4)

                Label {
                    anchors.centerIn: parent
                    text: "Sidebar\n" + Math.round(parent.width) + " px"
                    font.pixelSize: Style.resize(14)
                    color: Style.mainColor
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            // -- Panel derecho (Contenido principal) --
            // SplitView.fillWidth: true hace que este panel ocupe todo
            // el espacio restante, adaptándose cuando el sidebar cambia.
            Rectangle {
                SplitView.fillWidth: true
                color: Style.surfaceColor
                radius: Style.resize(4)

                Label {
                    anchors.centerIn: parent
                    text: "Main Content\n" + Math.round(parent.width) + " px"
                    font.pixelSize: Style.resize(14)
                    color: Style.fontPrimaryColor
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
}
