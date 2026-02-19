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
            text: "Tabs with Icons"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // TabBar with unicode icons as visual stand-ins
        TabBar {
            id: iconTabBar
            Layout.fillWidth: true

            TabButton {
                text: "\u2302  Home"
                font.pixelSize: Style.resize(14)
            }
            TabButton {
                text: "\u2709  Messages"
                font.pixelSize: Style.resize(14)
            }
            TabButton {
                text: "\u2605  Favorites"
                font.pixelSize: Style.resize(14)
            }
            TabButton {
                text: "\u2699  Config"
                font.pixelSize: Style.resize(14)
            }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: iconTabBar.currentIndex

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(8)
                    Label { text: "\u2302"; font.pixelSize: Style.resize(40); color: Style.mainColor; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Welcome Home"; font.pixelSize: Style.resize(16); color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                }
            }

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(8)
                    Label { text: "\u2709"; font.pixelSize: Style.resize(40); color: Style.mainColor; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "3 new messages"; font.pixelSize: Style.resize(16); color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                }
            }

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(8)
                    Label { text: "\u2605"; font.pixelSize: Style.resize(40); color: "#FEA601"; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Your favorites list"; font.pixelSize: Style.resize(16); color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                }
            }

            Rectangle {
                color: Style.bgColor
                radius: Style.resize(6)
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(8)
                    Label { text: "\u2699"; font.pixelSize: Style.resize(40); color: Style.inactiveColor; Layout.alignment: Qt.AlignHCenter }
                    Label { text: "Configuration panel"; font.pixelSize: Style.resize(16); color: Style.fontPrimaryColor; Layout.alignment: Qt.AlignHCenter }
                }
            }
        }
    }
}
