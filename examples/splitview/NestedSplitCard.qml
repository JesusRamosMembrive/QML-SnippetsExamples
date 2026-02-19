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
            text: "Nested SplitView (IDE Layout)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        SplitView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Horizontal

            handle: Rectangle {
                implicitWidth: Style.resize(4)
                implicitHeight: Style.resize(4)
                color: SplitHandle.pressed ? Style.mainColor : Style.inactiveColor
            }

            // File tree panel
            Rectangle {
                SplitView.preferredWidth: root.width * 0.25
                SplitView.minimumWidth: Style.resize(60)
                color: Style.bgColor
                radius: Style.resize(4)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(8)
                    spacing: Style.resize(4)

                    Label { text: "Explorer"; font.pixelSize: Style.resize(12); font.bold: true; color: Style.mainColor }
                    Label { text: "\u25BE src/"; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                    Label { text: "   main.cpp"; font.pixelSize: Style.resize(11); color: Style.fontPrimaryColor }
                    Label { text: "   app.h"; font.pixelSize: Style.resize(11); color: Style.fontPrimaryColor }
                    Label { text: "\u25BE qml/"; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                    Label { text: "   Main.qml"; font.pixelSize: Style.resize(11); color: Style.fontPrimaryColor }
                    Item { Layout.fillHeight: true }
                }
            }

            // Center: editor + terminal (vertical split)
            SplitView {
                SplitView.fillWidth: true
                orientation: Qt.Vertical

                handle: Rectangle {
                    implicitWidth: Style.resize(4)
                    implicitHeight: Style.resize(4)
                    color: SplitHandle.pressed ? Style.mainColor : Style.inactiveColor
                }

                Rectangle {
                    SplitView.fillHeight: true
                    color: Style.surfaceColor
                    radius: Style.resize(4)

                    Label {
                        anchors.centerIn: parent
                        text: "Editor"
                        font.pixelSize: Style.resize(14)
                        color: Style.fontPrimaryColor
                    }
                }

                Rectangle {
                    SplitView.preferredHeight: root.height * 0.25
                    SplitView.minimumHeight: Style.resize(40)
                    color: "#0D0F12"
                    radius: Style.resize(4)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(8)
                        spacing: Style.resize(2)

                        Label { text: "Terminal"; font.pixelSize: Style.resize(12); font.bold: true; color: Style.mainColor }
                        Label { text: "$ cmake --build build"; font.pixelSize: Style.resize(11); color: "#66BB6A"; font.family: "Consolas" }
                        Label { text: "Build finished."; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor; font.family: "Consolas" }
                        Item { Layout.fillHeight: true }
                    }
                }
            }
        }
    }
}
