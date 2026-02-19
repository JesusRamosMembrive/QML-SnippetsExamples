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
        spacing: Style.resize(20)

        Label {
            text: "Editable ComboBox"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Editable combo
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Type or select a font size"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: editableCombo
                Layout.fillWidth: true
                editable: true
                model: ["8", "10", "12", "14", "16", "18", "20", "24", "28", "32", "48", "72"]
                currentIndex: 4
            }

            Label {
                text: "Current value: " + editableCombo.editText + " pt"
                font.pixelSize: Style.resize(13)
                color: Style.mainColor
            }
        }

        // Editable with accepted signal
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Add custom items (press Enter)"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: dynamicCombo
                Layout.fillWidth: true
                editable: true
                model: ListModel {
                    id: dynamicModel
                    ListElement { text: "Red" }
                    ListElement { text: "Green" }
                    ListElement { text: "Blue" }
                }
                onAccepted: {
                    if (find(editText) === -1) {
                        dynamicModel.append({text: editText})
                        currentIndex = dynamicModel.count - 1
                    }
                }
            }

            Label {
                text: "Items: " + dynamicModel.count
                font.pixelSize: Style.resize(13)
                color: Style.mainColor
            }
        }

        // Editable with validator
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Numeric only (IntValidator 0-999)"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: validatorCombo
                Layout.fillWidth: true
                editable: true
                model: ["100", "200", "300", "500"]
                validator: IntValidator { bottom: 0; top: 999 }
            }

            Label {
                text: "Value: " + validatorCombo.editText
                font.pixelSize: Style.resize(13)
                color: Style.mainColor
            }
        }
    }
}
