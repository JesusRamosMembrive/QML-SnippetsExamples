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
            text: "Basic TabBar"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // TabBar + StackLayout
        TabBar {
            id: basicTabBar
            Layout.fillWidth: true

            TabButton { text: "Home" }
            TabButton { text: "Profile" }
            TabButton { text: "Settings" }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: basicTabBar.currentIndex

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                Label {
                    anchors.centerIn: parent
                    text: "Home content"
                    font.pixelSize: Style.resize(16)
                    color: Style.fontPrimaryColor
                }
            }

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                Label {
                    anchors.centerIn: parent
                    text: "Profile content"
                    font.pixelSize: Style.resize(16)
                    color: Style.fontPrimaryColor
                }
            }

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                Label {
                    anchors.centerIn: parent
                    text: "Settings content"
                    font.pixelSize: Style.resize(16)
                    color: Style.fontPrimaryColor
                }
            }
        }

        Label {
            text: "Current tab index: " + basicTabBar.currentIndex
            font.pixelSize: Style.resize(13)
            color: Style.mainColor
        }
    }
}
