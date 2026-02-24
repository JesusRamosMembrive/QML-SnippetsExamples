// =============================================================================
// SendMessageCard.qml — Constructor de mensajes STANAG 4586
// =============================================================================
// Permite construir y enviar mensajes STANAG con:
//   - Message ID (SpinBox)
//   - Bitmask de presencia: checkboxes para los 14 campos de telemetria
//   - Valores editables para cada campo activo
//   - Modo "Raw Hex" para enviar tramas manuales
//
// Los checkboxes se generan dinamicamente desde la tabla de fieldDefinitions
// que viene del C++ (EthernetController.getFieldDefinitions()).
//
// Al pulsar "Send", se recopilan los valores de los campos activos en un
// QVariantList y se pasan a EthernetController.sendMessage() junto con
// el bitmask calculado de los checkboxes.
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
    property var fieldDefinitions: []

    signal sendMessageRequested(int messageId, int presenceMask, var fieldValues)
    signal sendRawHexRequested(string hexString)

    // --- Estado interno ---
    property bool rawMode: false

    // Recopilar el bitmask y los valores de los campos activos
    function collectAndSend() {
        var presenceMask = 0
        var values = []

        for (var i = 0; i < fieldRepeater.count; ++i) {
            var item = fieldRepeater.itemAt(i)
            if (item && item.fieldChecked) {
                presenceMask |= (1 << i)
                values.push(item.fieldValue)
            }
        }

        root.sendMessageRequested(msgIdSpin.value, presenceMask, values)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(12)
        spacing: Style.resize(6)

        // --- Cabecera con controles ---
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Send Message"
                font.pixelSize: Style.resize(16)
                font.bold: true
                color: Style.mainColor
            }

            Item { Layout.fillWidth: true }

            // Toggle Raw Hex mode
            Label {
                text: "Raw Hex"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }
            Switch {
                id: rawSwitch
                checked: root.rawMode
                onToggled: root.rawMode = checked
                scale: 0.6
            }
        }

        // --- Modo Raw Hex ---
        RowLayout {
            Layout.fillWidth: true
            visible: root.rawMode
            spacing: Style.resize(8)

            TextField {
                id: rawHexField
                Layout.fillWidth: true
                placeholderText: "00 01 13 88 ..."
                font.pixelSize: Style.resize(12)
                font.family: "Courier New"
                selectByMouse: true
            }

            Button {
                text: "Send Raw"
                onClicked: root.sendRawHexRequested(rawHexField.text)
            }
        }

        // --- Modo Estructurado ---
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: !root.rawMode
            spacing: Style.resize(4)

            // Message ID + Send button en la misma fila
            RowLayout {
                Layout.fillWidth: true
                spacing: Style.resize(8)

                Label {
                    text: "Msg ID:"
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                }

                SpinBox {
                    id: msgIdSpin
                    from: 1
                    to: 65535
                    value: 1
                    editable: true
                    Layout.preferredWidth: Style.resize(100)
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: "Send"
                    onClicked: root.collectAndSend()
                }
            }

            // --- Campos de telemetria (7 filas x 2 columnas) ---
            // GridLayout con 2 columnas: cada celda es un Row con
            // checkbox + nombre + spinbox. 14 campos / 2 = 7 filas.
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                GridLayout {
                    width: parent.width
                    columns: 2
                    columnSpacing: Style.resize(4)
                    rowSpacing: Style.resize(1)

                    Repeater {
                        id: fieldRepeater
                        model: root.fieldDefinitions

                        RowLayout {
                            id: fieldRow
                            spacing: Style.resize(2)
                            Layout.fillWidth: true

                            property bool fieldChecked: fieldCheck.checked
                            property double fieldValue: fieldSpin.value

                            required property var modelData
                            required property int index

                            CheckBox {
                                id: fieldCheck
                                checked: false
                                scale: 0.6
                            }

                            Label {
                                text: fieldRow.modelData.name
                                font.pixelSize: Style.resize(11)
                                color: fieldCheck.checked
                                           ? Style.fontPrimaryColor
                                           : Style.inactiveColor
                                Layout.preferredWidth: Style.resize(80)
                                Layout.minimumWidth: Style.resize(60)
                                elide: Text.ElideRight
                            }

                            SpinBox {
                                id: fieldSpin
                                from: -32768
                                to: 65535
                                value: 0
                                editable: true
                                enabled: fieldCheck.checked
                                Layout.fillWidth: true
                                opacity: fieldCheck.checked ? 1.0 : 0.3
                            }
                        }
                    }
                }
            }
        }
    }
}
