import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root

    property real aircraftHeading: 0
    property real aircraftLat: 0
    property real aircraftLon: 0
    property int currentSegment: 0
    property var waypoints: []
    property real simSpeed: 1.0

    anchors.top: parent.top
    anchors.right: parent.right
    anchors.margins: Style.resize(12)
    width: Style.resize(190)
    implicitHeight: infoColumn.implicitHeight + Style.resize(20)
    color: Qt.rgba(0, 0, 0, 0.7)
    radius: Style.resize(8)

    ColumnLayout {
        id: infoColumn
        anchors.fill: parent
        anchors.margins: Style.resize(10)
        spacing: Style.resize(3)

        Label {
            text: "Flight Info"
            font.pixelSize: Style.resize(14)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "HDG  " + Math.round(root.aircraftHeading).toString().padStart(3, "0") + "\u00B0"
            font.pixelSize: Style.resize(12)
            font.family: "monospace"
            color: "#00FF00"
        }

        Label {
            text: "LAT  " + root.aircraftLat.toFixed(4)
            font.pixelSize: Style.resize(12)
            font.family: "monospace"
            color: "white"
        }

        Label {
            text: "LON  " + root.aircraftLon.toFixed(4)
            font.pixelSize: Style.resize(12)
            font.family: "monospace"
            color: "white"
        }

        Label {
            text: "WPT  " + (root.currentSegment < root.waypoints.length
                ? root.waypoints[root.currentSegment].name : "---")
            font.pixelSize: Style.resize(12)
            font.family: "monospace"
            color: "#00FF00"
        }

        Label {
            text: "SEG  " + (root.currentSegment + 1) + "/" + (root.waypoints.length - 1)
            font.pixelSize: Style.resize(12)
            font.family: "monospace"
            color: "white"
        }

        Label {
            text: "SPD  " + root.simSpeed.toFixed(0) + "x"
            font.pixelSize: Style.resize(12)
            font.family: "monospace"
            color: "white"
        }
    }
}
