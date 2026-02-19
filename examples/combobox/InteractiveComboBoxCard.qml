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
            text: "Interactive Demo"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Change the shape, color, and size with combo boxes"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        // Preview
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(120)
            color: Style.bgColor
            radius: Style.resize(8)

            Rectangle {
                id: previewShape
                anchors.centerIn: parent
                width: sizeCombo.currentValue
                height: sizeCombo.currentValue
                radius: shapeCombo.currentIndex === 1 ? width / 2 : (shapeCombo.currentIndex === 2 ? Style.resize(8) : 0)
                color: colorCombo.currentValue
                rotation: shapeCombo.currentIndex === 3 ? 45 : 0

                Behavior on width { NumberAnimation { duration: 200 } }
                Behavior on height { NumberAnimation { duration: 200 } }
                Behavior on radius { NumberAnimation { duration: 200 } }
                Behavior on color { ColorAnimation { duration: 200 } }
                Behavior on rotation { NumberAnimation { duration: 200 } }
            }
        }

        // Shape selector
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Label {
                text: "Shape"
                font.pixelSize: Style.resize(14)
                color: Style.fontPrimaryColor
                Layout.preferredWidth: Style.resize(60)
            }

            ComboBox {
                id: shapeCombo
                Layout.fillWidth: true
                model: ["Square", "Circle", "Rounded", "Diamond"]
            }
        }

        // Color selector
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Label {
                text: "Color"
                font.pixelSize: Style.resize(14)
                color: Style.fontPrimaryColor
                Layout.preferredWidth: Style.resize(60)
            }

            ComboBox {
                id: colorCombo
                Layout.fillWidth: true
                textRole: "name"
                valueRole: "hex"
                model: ListModel {
                    ListElement { name: "Teal"; hex: "#00D1A9" }
                    ListElement { name: "Orange"; hex: "#FEA601" }
                    ListElement { name: "Blue"; hex: "#4FC3F7" }
                    ListElement { name: "Red"; hex: "#FF7043" }
                    ListElement { name: "Purple"; hex: "#AB47BC" }
                    ListElement { name: "Pink"; hex: "#EC407A" }
                }
            }
        }

        // Size selector
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Label {
                text: "Size"
                font.pixelSize: Style.resize(14)
                color: Style.fontPrimaryColor
                Layout.preferredWidth: Style.resize(60)
            }

            ComboBox {
                id: sizeCombo
                Layout.fillWidth: true
                textRole: "label"
                valueRole: "size"
                currentIndex: 1
                model: ListModel {
                    ListElement { label: "Small"; size: 40 }
                    ListElement { label: "Medium"; size: 60 }
                    ListElement { label: "Large"; size: 80 }
                    ListElement { label: "Extra Large"; size: 100 }
                }
            }
        }

        Label {
            text: shapeCombo.currentText + " | " + colorCombo.currentText + " | " + sizeCombo.currentText
            font.pixelSize: Style.resize(13)
            color: Style.mainColor
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
