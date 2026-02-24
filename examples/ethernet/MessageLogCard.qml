// =============================================================================
// MessageLogCard.qml — Log de mensajes del protocolo STANAG 4586
// =============================================================================
// Muestra un historial en tiempo real de mensajes enviados, recibidos y
// errores de protocolo. Cada entrada incluye timestamp, direccion,
// message ID, numero de campos, tamano en bytes y badge de checksum.
//
// Al hacer click en una entrada, se emite entrySelected con el hex dump
// para que HexViewCard lo muestre en detalle.
//
// Patron de colores:
//   - Teal (#00D1A9): mensajes enviados
//   - Azul (#4A90D9): mensajes recibidos
//   - Rojo (#F44336): errores de protocolo
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

    property var logModel
    signal entrySelected(string hex)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(12)
        spacing: Style.resize(8)

        // --- Cabecera ---
        RowLayout {
            Layout.fillWidth: true

            Label {
                text: "Protocol Log"
                font.pixelSize: Style.resize(16)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
            }

            Label {
                text: (root.logModel ? root.logModel.count : 0) + " entries"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }

            Button {
                text: "Clear"
                enabled: root.logModel ? root.logModel.count > 0 : false
                onClicked: root.logModel.clear()
            }
        }

        // --- ListView ---
        ListView {
            id: logView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.logModel
            clip: true
            spacing: Style.resize(2)

            delegate: Rectangle {
                id: delegateRoot
                width: logView.width
                height: Style.resize(34)
                color: delegateMouseArea.containsMouse
                           ? Qt.lighter(Style.surfaceColor, 1.2)
                           : (index % 2 === 0 ? Style.surfaceColor : Style.cardColor)
                radius: Style.resize(4)

                required property int index
                required property string time
                required property string direction
                required property int msgId
                required property int fields
                required property int size
                required property string hex
                required property bool checksumOk
                required property string errorText

                MouseArea {
                    id: delegateMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.entrySelected(delegateRoot.hex)
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(8)
                    anchors.rightMargin: Style.resize(8)
                    spacing: Style.resize(6)

                    // Timestamp
                    Label {
                        text: delegateRoot.time
                        font.pixelSize: Style.resize(11)
                        font.family: "Courier New"
                        color: Style.fontSecondaryColor
                        Layout.preferredWidth: Style.resize(75)
                    }

                    // Flecha de direccion
                    Label {
                        text: delegateRoot.direction === "sent" ? "\u2192" :
                              delegateRoot.direction === "received" ? "\u2190" : "\u26A0"
                        font.pixelSize: Style.resize(14)
                        color: delegateRoot.direction === "sent" ? Style.mainColor :
                               delegateRoot.direction === "received" ? "#4A90D9" : "#F44336"
                        Layout.preferredWidth: Style.resize(16)
                        horizontalAlignment: Text.AlignHCenter
                    }

                    // Info del mensaje o texto de error
                    Label {
                        text: delegateRoot.direction === "error"
                                  ? delegateRoot.errorText
                                  : "ID:%1  Fields:%2  %3B".arg(delegateRoot.msgId)
                                                            .arg(delegateRoot.fields)
                                                            .arg(delegateRoot.size)
                        font.pixelSize: Style.resize(12)
                        font.family: delegateRoot.direction === "error" ? "" : "Courier New"
                        color: delegateRoot.direction === "error"
                                   ? "#F44336"
                                   : Style.fontPrimaryColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    // Badge de checksum
                    Rectangle {
                        Layout.preferredWidth: Style.resize(36)
                        Layout.preferredHeight: Style.resize(18)
                        radius: Style.resize(3)
                        visible: delegateRoot.direction !== "error"
                        color: delegateRoot.checksumOk ? "#1B3A2A" : "#3A1A1A"

                        Label {
                            anchors.centerIn: parent
                            text: delegateRoot.checksumOk ? "OK" : "FAIL"
                            font.pixelSize: Style.resize(9)
                            font.bold: true
                            color: delegateRoot.checksumOk ? "#4CAF50" : "#EF5350"
                        }
                    }

                    // Badge de direccion
                    Rectangle {
                        Layout.preferredWidth: Style.resize(40)
                        Layout.preferredHeight: Style.resize(18)
                        radius: Style.resize(3)
                        color: delegateRoot.direction === "sent" ? "#1B3A2A" :
                               delegateRoot.direction === "received" ? "#1A2A3A" : "#3A1A1A"

                        Label {
                            anchors.centerIn: parent
                            text: delegateRoot.direction
                            font.pixelSize: Style.resize(9)
                            color: delegateRoot.direction === "sent" ? "#4CAF50" :
                                   delegateRoot.direction === "received" ? "#42A5F5" : "#EF5350"
                        }
                    }
                }
            }

            // Estado vacio
            Label {
                anchors.centerIn: parent
                text: "No messages yet.\nBind a port and send a message."
                font.pixelSize: Style.resize(13)
                color: Style.inactiveColor
                horizontalAlignment: Text.AlignHCenter
                visible: root.logModel ? root.logModel.count === 0 : true
            }
        }
    }
}
