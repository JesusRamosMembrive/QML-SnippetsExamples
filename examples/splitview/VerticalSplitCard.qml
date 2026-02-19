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
            text: "Vertical SplitView"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        SplitView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Vertical

            handle: Rectangle {
                implicitWidth: Style.resize(6)
                implicitHeight: Style.resize(6)
                color: SplitHandle.pressed ? Style.mainColor
                     : SplitHandle.hovered ? Qt.lighter(Style.mainColor, 1.5)
                     : Style.inactiveColor

                Rectangle {
                    anchors.centerIn: parent
                    width: Style.resize(30)
                    height: Style.resize(2)
                    radius: Style.resize(1)
                    color: "#FFFFFF"
                    opacity: 0.5
                }
            }

            Rectangle {
                SplitView.preferredHeight: root.height * 0.25
                SplitView.minimumHeight: Style.resize(50)
                color: Style.bgColor
                radius: Style.resize(4)

                Label {
                    anchors.centerIn: parent
                    text: "Header — " + Math.round(parent.height) + " px"
                    font.pixelSize: Style.resize(14)
                    color: Style.mainColor
                }
            }

            Rectangle {
                SplitView.fillHeight: true
                color: Style.surfaceColor
                radius: Style.resize(4)

                Label {
                    anchors.centerIn: parent
                    text: "Content — " + Math.round(parent.height) + " px"
                    font.pixelSize: Style.resize(14)
                    color: Style.fontPrimaryColor
                }
            }

            Rectangle {
                SplitView.preferredHeight: root.height * 0.2
                SplitView.minimumHeight: Style.resize(40)
                color: Style.bgColor
                radius: Style.resize(4)

                Label {
                    anchors.centerIn: parent
                    text: "Footer — " + Math.round(parent.height) + " px"
                    font.pixelSize: Style.resize(14)
                    color: Style.inactiveColor
                }
            }
        }
    }
}
