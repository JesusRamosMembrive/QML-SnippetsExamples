import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Draggable Split Pane"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        id: splitSection
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(200)

        property real splitPos: 0.5

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
            clip: true

            // Left panel
            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * splitSection.splitPos - Style.resize(3)
                color: Style.surfaceColor
                radius: Style.resize(6)

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(4)

                    Label {
                        text: "Left Panel"
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: "#5B8DEF"
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Label {
                        text: Math.round(splitSection.splitPos * 100) + "%"
                        font.pixelSize: Style.resize(20)
                        font.bold: true
                        color: Style.fontPrimaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // Right panel
            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * (1 - splitSection.splitPos) - Style.resize(3)
                color: Style.surfaceColor
                radius: Style.resize(6)

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Style.resize(4)

                    Label {
                        text: "Right Panel"
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: "#00D1A9"
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Label {
                        text: Math.round((1 - splitSection.splitPos) * 100) + "%"
                        font.pixelSize: Style.resize(20)
                        font.bold: true
                        color: Style.fontPrimaryColor
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // Divider handle
            Rectangle {
                id: splitDivider
                x: parent.width * splitSection.splitPos - width / 2
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: Style.resize(6)
                color: splitDragMa.containsMouse || splitDragMa.pressed
                       ? Style.mainColor : Qt.rgba(1, 1, 1, 0.2)
                radius: Style.resize(2)

                Behavior on color { ColorAnimation { duration: 150 } }

                // Handle grip dots
                Column {
                    anchors.centerIn: parent
                    spacing: Style.resize(3)

                    Repeater {
                        model: 3
                        Rectangle {
                            width: Style.resize(3)
                            height: Style.resize(3)
                            radius: width / 2
                            color: Qt.rgba(1, 1, 1, 0.5)
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                MouseArea {
                    id: splitDragMa
                    anchors.fill: parent
                    anchors.margins: -Style.resize(4)
                    hoverEnabled: true
                    cursorShape: Qt.SplitHCursor
                    drag.target: null

                    property real startX: 0
                    property real startSplit: 0

                    onPressed: function(mouse) {
                        startX = mouse.x
                        startSplit = splitSection.splitPos
                    }
                    onPositionChanged: function(mouse) {
                        if (pressed) {
                            var dx = mouse.x - startX
                            var newSplit = startSplit + dx / splitDivider.parent.width
                            splitSection.splitPos = Math.max(0.15, Math.min(0.85, newSplit))
                        }
                    }
                }
            }
        }
    }
}
