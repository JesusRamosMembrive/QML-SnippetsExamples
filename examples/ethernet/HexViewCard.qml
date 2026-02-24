// =============================================================================
// HexViewCard.qml — Visor hexadecimal y campos decodificados
// =============================================================================
// Muestra dos secciones:
//   1. Hex Dump: vista monoespaciada de los bytes crudos de la trama,
//      formateados en filas de 16 bytes con offsets
//   2. Decoded Fields: tabla con los campos parseados del payload
//      (nombre, bytes hex crudos, valor decodificado)
//
// Se actualiza cuando:
//   - Se hace click en una entrada del MessageLogCard (currentHex)
//   - Se recibe un mensaje nuevo (decodedFields via EthernetController)
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // Hex dump de la trama seleccionada
    property string currentHex: ""
    // Campos decodificados del ultimo mensaje recibido
    property var decodedFields: []

    // Formatear el hex dump en filas de 16 bytes con offset
    // Entrada: "00 01 13 88 ..."
    // Salida:  "0000: 00 01 13 88 13 89 00 00  00 08 00 03 42 24 CC CD\n..."
    function formatHexDump(hex) {
        if (!hex) return ""

        var bytes = hex.split(" ")
        var lines = []

        for (var i = 0; i < bytes.length; i += 16) {
            // Offset en hexadecimal (4 digitos)
            var offset = i.toString(16).toUpperCase()
            while (offset.length < 4) offset = "0" + offset

            // Bytes de esta fila (maximo 16)
            var rowBytes = bytes.slice(i, Math.min(i + 16, bytes.length))

            // Separar en dos grupos de 8 para legibilidad
            var left = rowBytes.slice(0, 8).join(" ")
            var right = rowBytes.slice(8).join(" ")

            // Padding para alinear filas incompletas
            if (rowBytes.length < 8) {
                left = left + "   ".repeat(8 - rowBytes.length)
                right = ""
            } else if (rowBytes.length < 16) {
                right = right + "   ".repeat(16 - rowBytes.length)
            }

            lines.push(offset + ":  " + left + "  " + right)
        }

        return lines.join("\n")
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(12)
        spacing: Style.resize(8)

        // --- Seccion 1: Hex Dump ---
        Label {
            text: "Hex Dump"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.mainColor
        }

        // Fondo oscuro estilo terminal para el hex dump
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(100)
            color: "#1A1A2E"
            radius: Style.resize(4)

            ScrollView {
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                clip: true

                Label {
                    text: root.currentHex
                              ? root.formatHexDump(root.currentHex)
                              : "Select a message from the log to view its hex dump"
                    font.pixelSize: Style.resize(12)
                    font.family: "Courier New"
                    color: root.currentHex ? "#E0E0E0" : Style.inactiveColor
                    lineHeight: 1.4
                }
            }

            // Leyenda de la estructura de la trama
            RowLayout {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: Style.resize(6)
                spacing: Style.resize(10)
                visible: root.currentHex !== ""

                // Header
                Row {
                    spacing: Style.resize(3)
                    Rectangle {
                        width: Style.resize(8); height: Style.resize(8)
                        color: "#5C6BC0"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Label {
                        text: "Header (12B)"
                        font.pixelSize: Style.resize(9)
                        color: "#5C6BC0"
                    }
                }

                // Payload
                Row {
                    spacing: Style.resize(3)
                    Rectangle {
                        width: Style.resize(8); height: Style.resize(8)
                        color: Style.mainColor
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Label {
                        text: "Payload"
                        font.pixelSize: Style.resize(9)
                        color: Style.mainColor
                    }
                }

                // Checksum
                Row {
                    spacing: Style.resize(3)
                    Rectangle {
                        width: Style.resize(8); height: Style.resize(8)
                        color: "#FF9800"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Label {
                        text: "Checksum (1B)"
                        font.pixelSize: Style.resize(9)
                        color: "#FF9800"
                    }
                }
            }
        }

        // --- Seccion 2: Campos Decodificados ---
        Label {
            text: "Decoded Fields"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.mainColor
        }

        // Cabecera de la tabla
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(4)

            Label {
                text: "#"
                font.pixelSize: Style.resize(11)
                font.bold: true
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(25)
            }
            Label {
                text: "Field Name"
                font.pixelSize: Style.resize(11)
                font.bold: true
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(110)
            }
            Label {
                text: "Raw Hex"
                font.pixelSize: Style.resize(11)
                font.bold: true
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(100)
            }
            Label {
                text: "Value"
                font.pixelSize: Style.resize(11)
                font.bold: true
                color: Style.fontSecondaryColor
                Layout.fillWidth: true
            }
        }

        // Tabla de campos
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.decodedFields
            clip: true
            spacing: Style.resize(1)

            delegate: Rectangle {
                width: parent ? parent.width : 0
                height: Style.resize(26)
                color: index % 2 === 0 ? Style.surfaceColor : "transparent"
                radius: Style.resize(3)

                required property var modelData
                required property int index

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(4)
                    anchors.rightMargin: Style.resize(4)
                    spacing: Style.resize(4)

                    // Indice del campo
                    Label {
                        text: modelData.index
                        font.pixelSize: Style.resize(11)
                        font.family: "Courier New"
                        color: Style.fontSecondaryColor
                        Layout.preferredWidth: Style.resize(25)
                    }

                    // Nombre del campo
                    Label {
                        text: modelData.name
                        font.pixelSize: Style.resize(11)
                        color: Style.mainColor
                        elide: Text.ElideRight
                        Layout.preferredWidth: Style.resize(110)
                    }

                    // Bytes hex crudos
                    Label {
                        text: modelData.hex
                        font.pixelSize: Style.resize(11)
                        font.family: "Courier New"
                        color: "#B0BEC5"
                        Layout.preferredWidth: Style.resize(100)
                    }

                    // Valor decodificado
                    Label {
                        text: {
                            var v = modelData.value
                            // Floats: 4 decimales, enteros: sin decimales
                            if (v !== Math.floor(v))
                                return v.toFixed(4)
                            return v.toString()
                        }
                        font.pixelSize: Style.resize(12)
                        font.bold: true
                        color: Style.fontPrimaryColor
                        Layout.fillWidth: true
                    }
                }
            }

            // Estado vacio
            Label {
                anchors.centerIn: parent
                text: "No decoded fields.\nReceive a message to see parsed data."
                font.pixelSize: Style.resize(12)
                color: Style.inactiveColor
                horizontalAlignment: Text.AlignHCenter
                visible: root.decodedFields.length === 0
            }
        }
    }
}
