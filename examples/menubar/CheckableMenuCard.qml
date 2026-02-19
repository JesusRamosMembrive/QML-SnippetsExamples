import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property bool showGrid: true
    property bool showRulers: false
    property bool snapToGrid: true
    property string zoomLevel: "100%"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Checkable & Radio Menus"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Menu button
        Button {
            text: "View Options \u25BE"
            onClicked: viewMenu.popup()

            Menu {
                id: viewMenu

                MenuItem {
                    text: "Show Grid"
                    checkable: true
                    checked: root.showGrid
                    onCheckedChanged: root.showGrid = checked
                }

                MenuItem {
                    text: "Show Rulers"
                    checkable: true
                    checked: root.showRulers
                    onCheckedChanged: root.showRulers = checked
                }

                MenuItem {
                    text: "Snap to Grid"
                    checkable: true
                    checked: root.snapToGrid
                    onCheckedChanged: root.snapToGrid = checked
                }

                MenuSeparator {}

                Menu {
                    title: "Zoom"

                    MenuItem { text: "50%"; onTriggered: root.zoomLevel = "50%" }
                    MenuItem { text: "75%"; onTriggered: root.zoomLevel = "75%" }
                    MenuItem { text: "100%"; onTriggered: root.zoomLevel = "100%" }
                    MenuItem { text: "150%"; onTriggered: root.zoomLevel = "150%" }
                    MenuItem { text: "200%"; onTriggered: root.zoomLevel = "200%" }
                }
            }
        }

        // Preview area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.bgColor
            radius: Style.resize(4)
            clip: true

            // Grid overlay
            Canvas {
                anchors.fill: parent
                visible: root.showGrid
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.strokeStyle = "#333333"
                    ctx.lineWidth = 0.5
                    var step = 20
                    for (var x = 0; x < width; x += step) {
                        ctx.beginPath()
                        ctx.moveTo(x, 0)
                        ctx.lineTo(x, height)
                        ctx.stroke()
                    }
                    for (var y = 0; y < height; y += step) {
                        ctx.beginPath()
                        ctx.moveTo(0, y)
                        ctx.lineTo(width, y)
                        ctx.stroke()
                    }
                }
            }

            // Ruler top
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: Style.resize(16)
                color: "#2A2D35"
                visible: root.showRulers

                Row {
                    anchors.fill: parent
                    spacing: Style.resize(20)
                    Repeater {
                        model: 15
                        Label {
                            required property int index
                            text: (index * 20).toString()
                            font.pixelSize: Style.resize(8)
                            color: Style.inactiveColor
                            width: Style.resize(20)
                        }
                    }
                }
            }

            // Ruler left
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                width: Style.resize(16)
                color: "#2A2D35"
                visible: root.showRulers
            }

            // Center info
            Label {
                anchors.centerIn: parent
                text: "Zoom: " + root.zoomLevel
                font.pixelSize: Style.resize(18)
                font.bold: true
                color: Style.mainColor
            }
        }

        // Status
        Label {
            text: "Grid: " + root.showGrid + " | Rulers: " + root.showRulers + " | Snap: " + root.snapToGrid
            font.pixelSize: Style.resize(11)
            color: Style.inactiveColor
        }
    }
}
