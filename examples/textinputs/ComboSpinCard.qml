import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "ComboBox & SpinBox"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // ComboBox
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(5)

            Label {
                text: "Color (ComboBox):"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: colorCombo
                Layout.fillWidth: true
                model: ["Red", "Green", "Blue", "Orange", "Purple"]
            }
        }

        // SpinBox - Radius
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(15)

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Style.resize(5)

                Label {
                    text: "Radius (SpinBox):"
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                }

                SpinBox {
                    id: radiusSpin
                    from: 0
                    to: 50
                    stepSize: 5
                    value: 10
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Style.resize(5)

                Label {
                    text: "Size (SpinBox):"
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                }

                SpinBox {
                    id: sizeSpin
                    from: 50
                    to: 200
                    stepSize: 10
                    value: 100
                }
            }
        }

        // Preview Rectangle
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: Style.resize(100)

            Rectangle {
                id: previewRect
                anchors.centerIn: parent
                width: sizeSpin.value
                height: sizeSpin.value
                radius: radiusSpin.value
                color: {
                    switch (colorCombo.currentIndex) {
                        case 0: return "#E74C3C";
                        case 1: return "#2ECC71";
                        case 2: return "#3498DB";
                        case 3: return "#E67E22";
                        case 4: return "#9B59B6";
                        default: return "#E74C3C";
                    }
                }

                Behavior on width { NumberAnimation { duration: 200 } }
                Behavior on height { NumberAnimation { duration: 200 } }
                Behavior on radius { NumberAnimation { duration: 200 } }
                Behavior on color { ColorAnimation { duration: 200 } }

                Label {
                    anchors.centerIn: parent
                    text: previewRect.width.toFixed(0) + "x" + previewRect.height.toFixed(0)
                          + " r:" + previewRect.radius.toFixed(0)
                    color: "white"
                    font.pixelSize: Style.resize(11)
                    font.bold: true
                }
            }
        }

        Label {
            text: "ComboBox provides dropdown selection, SpinBox provides bounded numeric input"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
