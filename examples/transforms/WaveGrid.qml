import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    property bool active: false
    property bool waveActive: false

    RowLayout {
        Layout.fillWidth: true
        Label {
            text: "6. Wave Grid"
            font.pixelSize: Style.resize(16)
            font.bold: true
            color: Style.fontPrimaryColor
        }
        Item { Layout.fillWidth: true }
        Button {
            text: root.waveActive ? "Pause" : "Start"
            onClicked: root.waveActive = !root.waveActive
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(230)
        color: Style.surfaceColor
        radius: Style.resize(6)
        clip: true

        Item {
            id: waveSection
            anchors.fill: parent
            property real wavePhase: 0

            Timer {
                interval: 40
                repeat: true
                running: root.active && root.waveActive
                onTriggered: waveSection.wavePhase += 0.08
            }

            Grid {
                anchors.centerIn: parent
                rows: 6
                columns: 10
                spacing: Style.resize(4)

                Repeater {
                    model: 60

                    Rectangle {
                        property int col: index % 10
                        property int row: Math.floor(index / 10)
                        property real wave: Math.sin(waveSection.wavePhase + (col + row) * 0.4)
                        property real t: (wave + 1) / 2

                        width: Style.resize(22)
                        height: Style.resize(22)
                        radius: Style.resize(4)
                        scale: 0.55 + 0.45 * t
                        color: Qt.rgba(1 - t * 0.75, t * 0.6 + 0.3, t * 0.5 + 0.2, 1)

                        transform: Translate { y: wave * Style.resize(12) }
                    }
                }
            }
        }
    }
}
