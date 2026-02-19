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
            text: "Basic ComboBox"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Simple string list
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "String list"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: basicCombo
                Layout.fillWidth: true
                model: ["Apple", "Banana", "Cherry", "Dragonfruit", "Elderberry"]
            }

            Label {
                text: "Selected: " + basicCombo.currentText
                font.pixelSize: Style.resize(13)
                color: Style.mainColor
            }
        }

        // With currentIndex
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Pre-selected index (2)"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: indexCombo
                Layout.fillWidth: true
                model: ["Small", "Medium", "Large", "Extra Large"]
                currentIndex: 2
            }

            Label {
                text: "Index: " + indexCombo.currentIndex + " — Value: " + indexCombo.currentText
                font.pixelSize: Style.resize(13)
                color: Style.mainColor
            }
        }

        // Disabled
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Disabled ComboBox"
                font.pixelSize: Style.resize(14)
                color: "#999"
            }

            ComboBox {
                Layout.fillWidth: true
                model: ["Cannot select"]
                enabled: false
            }
        }
    }
}
