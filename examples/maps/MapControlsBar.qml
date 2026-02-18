import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root

    property bool playing: false
    property real simSpeed: 1.0
    property bool followAircraft: true

    signal playToggled()
    signal resetClicked()
    signal speedSelected(real speed)
    signal followClicked()

    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: Style.resize(15)
    width: controlsRow.implicitWidth + Style.resize(30)
    height: Style.resize(44)
    radius: Style.resize(22)
    color: Qt.rgba(0, 0, 0, 0.75)
    border.color: Qt.rgba(1, 1, 1, 0.15)
    border.width: 1

    RowLayout {
        id: controlsRow
        anchors.centerIn: parent
        spacing: Style.resize(8)

        // Reset
        Label {
            text: "\u23EE"
            font.pixelSize: Style.resize(20)
            color: resetMa.containsMouse ? "white" : "#CCCCCC"

            MouseArea {
                id: resetMa
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.resetClicked()
            }
        }

        // Play / Pause
        Label {
            text: root.playing ? "\u23F8" : "\u25B6"
            font.pixelSize: Style.resize(22)
            color: playMa.containsMouse ? Style.mainColor : "white"

            MouseArea {
                id: playMa
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.playToggled()
            }
        }

        // Separator
        Rectangle {
            width: 1
            height: Style.resize(20)
            color: "#555555"
        }

        // Speed buttons
        Repeater {
            model: [1, 2, 4]

            Label {
                required property real modelData

                text: modelData + "x"
                font.pixelSize: Style.resize(13)
                font.bold: root.simSpeed === modelData
                color: root.simSpeed === modelData
                       ? Style.mainColor
                       : (spdMa.containsMouse ? "white" : "#AAAAAA")

                MouseArea {
                    id: spdMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.speedSelected(parent.modelData)
                }
            }
        }

        // Separator
        Rectangle {
            width: 1
            height: Style.resize(20)
            color: "#555555"
        }

        // Follow toggle
        Label {
            text: root.followAircraft ? "\uD83D\uDCCD Follow" : "\uD83D\uDD13 Free"
            font.pixelSize: Style.resize(12)
            color: followMa.containsMouse
                   ? "white"
                   : (root.followAircraft ? Style.mainColor : "#AAAAAA")

            MouseArea {
                id: followMa
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.followClicked()
            }
        }
    }
}
