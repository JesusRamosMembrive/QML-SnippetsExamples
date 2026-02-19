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
            text: "Horizontal SplitView"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        SplitView {
            id: hSplit
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Horizontal

            handle: Rectangle {
                implicitWidth: Style.resize(6)
                implicitHeight: Style.resize(6)
                color: SplitHandle.pressed ? Style.mainColor
                     : SplitHandle.hovered ? Qt.lighter(Style.mainColor, 1.5)
                     : Style.inactiveColor

                Rectangle {
                    anchors.centerIn: parent
                    width: Style.resize(2)
                    height: Style.resize(30)
                    radius: Style.resize(1)
                    color: "#FFFFFF"
                    opacity: 0.5
                }
            }

            Rectangle {
                SplitView.preferredWidth: root.width * 0.3
                SplitView.minimumWidth: Style.resize(80)
                color: Style.bgColor
                radius: Style.resize(4)

                Label {
                    anchors.centerIn: parent
                    text: "Sidebar\n" + Math.round(parent.width) + " px"
                    font.pixelSize: Style.resize(14)
                    color: Style.mainColor
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                SplitView.fillWidth: true
                color: Style.surfaceColor
                radius: Style.resize(4)

                Label {
                    anchors.centerIn: parent
                    text: "Main Content\n" + Math.round(parent.width) + " px"
                    font.pixelSize: Style.resize(14)
                    color: Style.fontPrimaryColor
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
}
