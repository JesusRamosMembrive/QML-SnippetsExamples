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
        spacing: Style.resize(10)

        Label {
            text: "Row & Column Layout"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Spacing control
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Spacing: " + spacingSlider.value.toFixed(0) + "px"
                font.pixelSize: Style.resize(12)
                color: Style.fontPrimaryColor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(30)

                Slider {
                    id: spacingSlider
                    anchors.fill: parent
                    from: 0
                    to: 30
                    value: 8
                    stepSize: 1
                }
            }
        }

        // RowLayout demo
        Label {
            text: "RowLayout"
            font.pixelSize: Style.resize(13)
            font.bold: true
            color: Style.fontPrimaryColor
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(50)
            color: Style.bgColor
            radius: Style.resize(4)

            RowLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(4)
                spacing: spacingSlider.value

                Rectangle {
                    Layout.preferredWidth: Style.resize(60)
                    Layout.fillHeight: true
                    color: "#4A90D9"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "Fixed"; color: "white"; font.pixelSize: Style.resize(10) }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#00D1A9"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "fillWidth"; color: "white"; font.pixelSize: Style.resize(10) }
                }

                Rectangle {
                    Layout.preferredWidth: Style.resize(80)
                    Layout.fillHeight: true
                    color: "#FEA601"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "Fixed"; color: "white"; font.pixelSize: Style.resize(10) }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#9B59B6"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "fillWidth"; color: "white"; font.pixelSize: Style.resize(10) }
                }
            }
        }

        // ColumnLayout demo
        Label {
            text: "ColumnLayout"
            font.pixelSize: Style.resize(13)
            font.bold: true
            color: Style.fontPrimaryColor
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(4)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(4)
                spacing: spacingSlider.value

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(30)
                    color: "#E74C3C"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "preferredHeight: 30"; color: "white"; font.pixelSize: Style.resize(10) }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#1ABC9C"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "fillHeight"; color: "white"; font.pixelSize: Style.resize(10) }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(25)
                    color: "#FF5900"
                    radius: Style.resize(4)
                    Label { anchors.centerIn: parent; text: "preferredHeight: 25"; color: "white"; font.pixelSize: Style.resize(10) }
                }
            }
        }

        Label {
            text: "RowLayout arranges horizontally, ColumnLayout vertically. fillWidth/fillHeight expand to fill"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
