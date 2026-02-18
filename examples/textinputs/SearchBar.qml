import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Search Bar"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Rectangle {
        Layout.fillWidth: true
        height: Style.resize(46)
        radius: height / 2
        color: Style.surfaceColor
        border.color: searchInput.activeFocus ? Style.mainColor : "#3A3D45"
        border.width: searchInput.activeFocus ? 2 : 1

        Behavior on border.color { ColorAnimation { duration: 200 } }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Style.resize(16)
            anchors.rightMargin: Style.resize(12)
            spacing: Style.resize(10)

            // Search icon
            Label {
                text: "\uD83D\uDD0D"
                font.pixelSize: Style.resize(18)
                opacity: searchInput.activeFocus ? 1.0 : 0.5

                Behavior on opacity { NumberAnimation { duration: 200 } }
            }

            TextInput {
                id: searchInput
                Layout.fillWidth: true
                font.pixelSize: Style.resize(14)
                color: Style.fontPrimaryColor
                clip: true
                selectByMouse: true
                selectionColor: Style.mainColor

                Text {
                    anchors.fill: parent
                    text: "Search anything..."
                    font: parent.font
                    color: Style.inactiveColor
                    visible: !parent.text && !parent.activeFocus
                    verticalAlignment: Text.AlignVCenter
                }
            }

            // Clear button
            Rectangle {
                width: Style.resize(24)
                height: width
                radius: width / 2
                color: clearMa.containsMouse ? "#4A4D55" : "transparent"
                visible: searchInput.text.length > 0

                Label {
                    anchors.centerIn: parent
                    text: "\u2715"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }

                MouseArea {
                    id: clearMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: searchInput.text = ""
                }
            }
        }
    }
}
