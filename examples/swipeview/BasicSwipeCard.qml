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
        spacing: Style.resize(15)

        Label {
            text: "Basic SwipeView"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        SwipeView {
            id: basicSwipe
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                Label {
                    anchors.centerIn: parent
                    text: "Page 1"
                    font.pixelSize: Style.resize(24)
                    font.bold: true
                    color: Style.mainColor
                }
            }

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                Label {
                    anchors.centerIn: parent
                    text: "Page 2"
                    font.pixelSize: Style.resize(24)
                    font.bold: true
                    color: "#FEA601"
                }
            }

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                Label {
                    anchors.centerIn: parent
                    text: "Page 3"
                    font.pixelSize: Style.resize(24)
                    font.bold: true
                    color: "#4FC3F7"
                }
            }
        }

        // Navigation buttons
        RowLayout {
            Layout.fillWidth: true

            Button {
                text: "\u25C0 Prev"
                enabled: basicSwipe.currentIndex > 0
                onClicked: basicSwipe.currentIndex--
            }

            Item { Layout.fillWidth: true }

            Label {
                text: (basicSwipe.currentIndex + 1) + " / " + basicSwipe.count
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "Next \u25B6"
                enabled: basicSwipe.currentIndex < basicSwipe.count - 1
                onClicked: basicSwipe.currentIndex++
            }
        }
    }
}
