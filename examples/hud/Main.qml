import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Style.resize(20)
            spacing: Style.resize(10)

            Label {
                text: "Head-Up Display (HUD)"
                font.pixelSize: Style.resize(28)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
                Layout.leftMargin: Style.resize(20)
            }

            HudCanvas {
                Layout.fillWidth: true
                Layout.fillHeight: true
                pitch: controls.pitch
                roll: controls.roll
                heading: controls.heading
                speed: controls.speed
                altitude: controls.altitude
                fpa: controls.fpa
            }

            HudControlsPanel {
                id: controls
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(110)
            }

            Label {
                text: "Canvas-drawn fighter HUD: pitch ladder (solid above, dashed below horizon), flight path vector, heading tape, speed/altitude readouts. All green phosphor monochrome."
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.leftMargin: Style.resize(20)
            }
        }
    }
}
