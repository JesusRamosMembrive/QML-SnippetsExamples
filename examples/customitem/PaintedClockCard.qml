import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import customitem
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date()
            clock.hours = now.getHours()
            clock.minutes = now.getMinutes()
            clock.seconds = now.getSeconds()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Analog Clock"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "QQuickPaintedItem with QPainter — live clock"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // Clock display
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            AnalogClock {
                id: clock
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height) - Style.resize(20)
                height: width
            }
        }

        // Time label
        Label {
            text: {
                var h = clock.hours.toString().padStart(2, '0')
                var m = clock.minutes.toString().padStart(2, '0')
                var s = clock.seconds.toString().padStart(2, '0')
                return h + ":" + m + ":" + s
            }
            font.pixelSize: Style.resize(22)
            font.bold: true
            color: Style.fontPrimaryColor
            Layout.alignment: Qt.AlignHCenter
        }

        // Accent color selector
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Accent:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }

            Repeater {
                model: ["#00D1A9", "#FF6B6B", "#4FC3F7", "#FFD93D", "#C084FC"]

                Rectangle {
                    required property string modelData
                    required property int index
                    width: Style.resize(24)
                    height: Style.resize(24)
                    radius: Style.resize(12)
                    color: modelData
                    border.width: clock.accentColor == modelData ? 2 : 0
                    border.color: "#FFFFFF"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: clock.accentColor = parent.modelData
                    }
                }
            }
        }
    }
}
