// =============================================================================
// ActionToolBarCard.qml — ToolBar con acciones agrupadas y log
// =============================================================================
// Demuestra una barra de herramientas mas completa con grupos de acciones
// separados por ToolSeparator, y un ComboBox integrado para zoom.
// Todas las acciones se registran en un log visible debajo de la barra.
//
// Conceptos clave:
//   - ToolSeparator: linea vertical que divide grupos logicos de herramientas.
//     Ayuda al usuario a encontrar herramientas por categoria visual.
//   - ComboBox dentro de ToolBar: demuestra que una ToolBar puede contener
//     cualquier control, no solo ToolButtons. Comun en apps reales (seleccion
//     de fuente, zoom, etc.).
//   - Funcion log(): JavaScript en QML para logica de presentacion.
//     Prepend (msg + "\n" + logText) hace que las nuevas acciones aparezcan
//     arriba. El truncado a 200 caracteres evita crecimiento infinito.
//   - Operador || en binding: "logText || placeholder" muestra texto por
//     defecto cuando logText esta vacio (string vacio es falsy en JS).
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

    property string logText: ""

    // -- Funcion helper para agregar entradas al log.
    //    Nuevas entradas van al inicio (prepend). Se trunca para no crecer
    //    indefinidamente en memoria.
    function log(msg) {
        logText = msg + "\n" + logText
        if (logText.length > 200)
            logText = logText.substring(0, 200)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "ToolBar with Actions"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // -- ToolBar con controles mixtos: ToolButtons + ToolSeparators + ComboBox.
        //    Los grupos (New | Cut/Copy/Paste | Undo/Redo | Zoom) siguen la
        //    convencion de aplicaciones de oficina.
        ToolBar {
            Layout.fillWidth: true
            background: Rectangle {
                color: Style.bgColor
                radius: Style.resize(4)
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.resize(8)
                anchors.rightMargin: Style.resize(8)
                spacing: Style.resize(6)

                ToolButton { text: "\u2795"; font.pixelSize: Style.resize(14); onClicked: root.log("New file") }

                ToolSeparator {}

                ToolButton { text: "\u2702"; font.pixelSize: Style.resize(14); onClicked: root.log("Cut") }
                ToolButton { text: "\u2398"; font.pixelSize: Style.resize(14); onClicked: root.log("Copy") }
                ToolButton { text: "\u2399"; font.pixelSize: Style.resize(14); onClicked: root.log("Paste") }

                ToolSeparator {}

                ToolButton { text: "\u21B6"; font.pixelSize: Style.resize(14); onClicked: root.log("Undo") }
                ToolButton { text: "\u21B7"; font.pixelSize: Style.resize(14); onClicked: root.log("Redo") }

                Item { Layout.fillWidth: true }

                // -- ComboBox integrado en la toolbar para seleccion de zoom.
                //    onActivated se dispara al cambiar la seleccion.
                ComboBox {
                    model: ["100%", "75%", "50%", "125%", "150%"]
                    implicitWidth: Style.resize(90)
                    onActivated: root.log("Zoom: " + currentText)
                }
            }
        }

        // -- Area de log que muestra el historial de acciones ejecutadas
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(4)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(4)

                Label {
                    text: "Action Log"
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                    color: Style.mainColor
                }

                Label {
                    text: root.logText || "Click toolbar buttons..."
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }
}
