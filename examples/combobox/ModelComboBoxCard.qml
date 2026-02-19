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
            text: "ListModel & Roles"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // textRole / valueRole
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "textRole + valueRole"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: roleCombo
                Layout.fillWidth: true
                textRole: "name"
                valueRole: "code"
                model: ListModel {
                    ListElement { name: "United States"; code: "US" }
                    ListElement { name: "United Kingdom"; code: "UK" }
                    ListElement { name: "Germany"; code: "DE" }
                    ListElement { name: "Japan"; code: "JP" }
                    ListElement { name: "Spain"; code: "ES" }
                    ListElement { name: "France"; code: "FR" }
                }
            }

            Label {
                text: "Country: " + roleCombo.currentText + " — Code: " + roleCombo.currentValue
                font.pixelSize: Style.resize(13)
                color: Style.mainColor
            }
        }

        // displayText override
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Custom displayText"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: displayCombo
                Layout.fillWidth: true
                textRole: "label"
                valueRole: "value"
                displayText: currentIndex === -1 ? "-- Select priority --" : currentText + " (" + currentValue + ")"
                model: ListModel {
                    ListElement { label: "Low"; value: 1 }
                    ListElement { label: "Medium"; value: 2 }
                    ListElement { label: "High"; value: 3 }
                    ListElement { label: "Critical"; value: 4 }
                }
            }

            Label {
                text: displayCombo.currentIndex >= 0
                      ? "Priority level: " + displayCombo.currentValue
                      : "No selection"
                font.pixelSize: Style.resize(13)
                color: Style.mainColor
            }
        }

        // Large model with scroll
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Large model (scrollable popup)"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: largeCombo
                Layout.fillWidth: true
                model: 50
                displayText: "Item " + currentIndex
            }

            Label {
                text: "Selected index: " + largeCombo.currentIndex
                font.pixelSize: Style.resize(13)
                color: Style.mainColor
            }
        }
    }
}
