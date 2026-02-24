// =============================================================================
// Main.qml — Pagina principal del ejemplo Ethernet / STANAG 4586
// =============================================================================
// Demuestra comunicacion UDP con parsing de protocolo STANAG 4586 E4.
// La arquitectura sigue el patron fachada: EthernetController (C++) gestiona
// toda la logica de red y protocolo, QML solo se encarga de la presentacion.
//
// Estructura:
//   - EthernetController (C++): fachada que engloba UDP + codec STANAG
//   - ListModel (logModel): almacen central de mensajes (sent/received/error)
//   - ConnectionCard: configuracion de puertos y bind/unbind
//   - SendMessageCard: constructor de mensajes con bitmask de campos
//   - MessageLogCard: historial de comunicacion con hex dumps
//   - HexViewCard: visor hexadecimal + campos decodificados
//
// Flujo de datos:
//   SEND: QML → sendMessage() → encode BigEndian → UDP localhost
//   RECV: UDP localhost → decode BigEndian → signals → QML ListModel
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle
import ethernet

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    // =========================================================================
    // EthernetController (C++) — Instanciado como componente QML
    // =========================================================================
    // Gracias a QML_ELEMENT, esta clase C++ se usa igual que cualquier tipo QML.
    // Las propiedades listenPort y sendPort se vinculan bidireccionalmente con
    // los SpinBox del ConnectionCard.
    //
    // Los handlers de senales (onMessageSent, etc.) reciben los datos
    // ya parseados como tipos simples (QString, int, bool) e insertan
    // entries en el ListModel para que el log se actualice reactivamente.
    // =========================================================================
    EthernetController {
        id: controller

        onMessageSent: function(timestamp, hexDump, messageId, fieldCount, byteSize) {
            logModel.insert(0, {
                time: timestamp,
                direction: "sent",
                msgId: messageId,
                fields: fieldCount,
                size: byteSize,
                hex: hexDump,
                checksumOk: true,
                errorText: ""
            })
        }

        onMessageReceived: function(timestamp, hexDump, messageId, sourcePort,
                                     fieldCount, byteSize, checksumOk) {
            logModel.insert(0, {
                time: timestamp,
                direction: "received",
                msgId: messageId,
                fields: fieldCount,
                size: byteSize,
                hex: hexDump,
                checksumOk: checksumOk,
                errorText: ""
            })
        }

        onFieldsDecoded: function(fields) {
            hexViewCard.decodedFields = fields
        }

        onProtocolError: function(timestamp, error, hexDump) {
            logModel.insert(0, {
                time: timestamp,
                direction: "error",
                msgId: 0,
                fields: 0,
                size: 0,
                hex: hexDump,
                checksumOk: false,
                errorText: error
            })
        }
    }

    // Modelo central de mensajes
    ListModel {
        id: logModel
    }

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            spacing: Style.resize(15)

            // --- Titulo ---
            Label {
                text: "Ethernet — STANAG 4586 Protocol (C++ ↔ QML)"
                font.pixelSize: Style.resize(28)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
            }

            Label {
                text: "UDP transport + BigEndian serialization + bitmask payload. Backend: EthernetController → StanagCodec → UdpTransport"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            // --- Fila superior: Connection + Send ---
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.maximumHeight: Style.resize(350)
                spacing: Style.resize(15)

                ConnectionCard {
                    id: connectionCard
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(170)
                    Layout.alignment: Qt.AlignTop
                    Layout.preferredWidth: 1
                    bound: controller.bound
                    statusText: controller.statusText
                    sentCount: controller.sentCount
                    receivedCount: controller.receivedCount
                    errorCount: controller.errorCount
                    onBindClicked: {
                        controller.listenPort = connectionCard.listenPort
                        controller.sendPort = connectionCard.sendPort
                        controller.startListening()
                    }
                    onUnbindClicked: controller.stopListening()
                }

                SendMessageCard {
                    id: sendCard
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 1
                    Layout.alignment: Qt.AlignTop
                    enabled: controller.bound
                    fieldDefinitions: controller.getFieldDefinitions()
                    onSendMessageRequested: function(messageId, presenceMask, fieldValues) {
                        controller.sendMessage(messageId, presenceMask, fieldValues)
                    }
                    onSendRawHexRequested: function(hexString) {
                        controller.sendRawHex(hexString)
                    }
                }
            }

            // --- Fila inferior: Log + Hex View ---
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Style.resize(15)

                MessageLogCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 1
                    logModel: logModel
                    onEntrySelected: function(hex) {
                        hexViewCard.currentHex = hex
                    }
                }

                HexViewCard {
                    id: hexViewCard
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 1
                }
            }

            // --- Pie de pagina ---
            Label {
                text: "C++ EthernetController (QML_ELEMENT) wraps StanagCodec (QDataStream BigEndian) + UdpTransport (QUdpSocket). Protocol: 12B header + variable payload (bitmask) + XOR checksum."
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
    }
}
