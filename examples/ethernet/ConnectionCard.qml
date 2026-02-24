// =============================================================================
// ConnectionCard.qml — Configuracion de puertos UDP y estado de conexion
// =============================================================================
// Permite configurar los puertos de escucha (listen) y envio (send) para
// la comunicacion UDP. Muestra un indicador de estado y contadores de
// mensajes enviados, recibidos y errores.
//
// Patron: propiedades de entrada (bound, statusText, contadores) y senales
// de salida (bindClicked, unbindClicked). El padre (Main.qml) conecta
// estas senales al EthernetController.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // --- API publica ---
    property bool bound: false
    property string statusText: ""
    property int sentCount: 0
    property int receivedCount: 0
    property int errorCount: 0

    // Puertos configurados (leidos desde los SpinBox)
    readonly property int listenPort: listenPortSpin.value
    readonly property int sendPort: sendPortSpin.value

    signal bindClicked()
    signal unbindClicked()

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: Style.resize(12)
        spacing: Style.resize(8)

        Label {
            text: "UDP Connection"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.mainColor
        }

        // --- Puertos ---
        GridLayout {
            Layout.fillWidth: true
            columns: 4
            columnSpacing: Style.resize(8)
            rowSpacing: Style.resize(6)

            Label {
                text: "Listen:"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }

            SpinBox {
                id: listenPortSpin
                from: 1024
                to: 65535
                value: 5000
                enabled: !root.bound
                Layout.preferredWidth: Style.resize(110)
                editable: true
            }

            Label {
                text: "Send:"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }

            SpinBox {
                id: sendPortSpin
                from: 1024
                to: 65535
                value: 5001
                enabled: !root.bound
                Layout.preferredWidth: Style.resize(110)
                editable: true
            }
        }

        // --- Estado + Botones ---
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            // Indicador circular
            Rectangle {
                width: Style.resize(10)
                height: Style.resize(10)
                radius: width / 2
                color: root.bound ? "#4CAF50" : "#F44336"

                SequentialAnimation on opacity {
                    running: root.statusText.indexOf("Listening") >= 0
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.5; duration: 800 }
                    NumberAnimation { to: 1.0; duration: 800 }
                }
            }

            Label {
                text: root.statusText
                font.pixelSize: Style.resize(12)
                color: root.bound ? "#4CAF50" : Style.fontSecondaryColor
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Button {
                text: "Bind"
                enabled: !root.bound
                onClicked: root.bindClicked()
            }

            Button {
                text: "Unbind"
                enabled: root.bound
                onClicked: root.unbindClicked()
            }
        }

        // --- Contadores ---
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(15)

            // Enviados
            Row {
                spacing: Style.resize(4)
                Rectangle {
                    width: Style.resize(8); height: Style.resize(8)
                    radius: 2; color: Style.mainColor
                    anchors.verticalCenter: parent.verticalCenter
                }
                Label {
                    text: "Sent: " + root.sentCount
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }
            }

            // Recibidos
            Row {
                spacing: Style.resize(4)
                Rectangle {
                    width: Style.resize(8); height: Style.resize(8)
                    radius: 2; color: "#4A90D9"
                    anchors.verticalCenter: parent.verticalCenter
                }
                Label {
                    text: "Recv: " + root.receivedCount
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }
            }

            // Errores
            Row {
                spacing: Style.resize(4)
                Rectangle {
                    width: Style.resize(8); height: Style.resize(8)
                    radius: 2; color: "#F44336"
                    anchors.verticalCenter: parent.verticalCenter
                }
                Label {
                    text: "Err: " + root.errorCount
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }
            }
        }
    }
}
