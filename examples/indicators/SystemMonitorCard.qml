import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: monitorCard
    color: Style.cardColor
    radius: Style.resize(8)

    property bool active: false
    property real cpuValue: 25

    Timer {
        running: monitorCard.active
        interval: 1500
        repeat: true
        onTriggered: {
            monitorCard.cpuValue = Math.min(100, Math.max(0,
                monitorCard.cpuValue + (Math.random() * 30 - 15)));
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(12)

        Label {
            text: "Interactive Demo - System Monitor"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // CPU Dial + BusyIndicator
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(20)
            Layout.alignment: Qt.AlignHCenter

            ColumnLayout {
                spacing: Style.resize(5)
                Layout.alignment: Qt.AlignHCenter

                Dial {
                    id: cpuDial
                    Layout.preferredWidth: Style.resize(130)
                    Layout.preferredHeight: Style.resize(130)
                    Layout.alignment: Qt.AlignHCenter
                    from: 0
                    to: 100
                    value: monitorCard.cpuValue
                    enabled: false
                    suffix: "%"
                    progressColor: monitorCard.cpuValue > 80 ? "#FF5900" : Style.mainColor

                    Behavior on value {
                        NumberAnimation { duration: 500 }
                    }
                }

                Label {
                    text: "CPU Usage"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // High CPU warning
            ColumnLayout {
                spacing: Style.resize(5)
                Layout.alignment: Qt.AlignHCenter

                BusyIndicator {
                    running: monitorCard.cpuValue > 80
                    opacity: monitorCard.cpuValue > 80 ? 1.0 : 0.2
                    Layout.alignment: Qt.AlignHCenter

                    Behavior on opacity {
                        NumberAnimation { duration: 300 }
                    }
                }

                Label {
                    text: monitorCard.cpuValue > 80 ? "High Load!" : "Normal"
                    font.pixelSize: Style.resize(12)
                    font.bold: monitorCard.cpuValue > 80
                    color: monitorCard.cpuValue > 80 ? "#FF5900" : Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // Memory ProgressBar
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(4)

            Label {
                text: "Memory: " + (memorySlider.value * 100).toFixed(0) + "%"
                font.pixelSize: Style.resize(13)
                color: Style.fontPrimaryColor
            }

            ProgressBar {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(8)
                value: memorySlider.value
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(30)

                Slider {
                    id: memorySlider
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 1
                    value: 0.62
                    stepSize: 0.01
                }
            }
        }

        // Disk ProgressBar
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(4)

            Label {
                text: "Disk: 78%"
                font.pixelSize: Style.resize(13)
                color: Style.fontPrimaryColor
            }

            ProgressBar {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(8)
                value: 0.78
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(1)
            color: Style.bgColor
        }

        Label {
            text: "CPU: " + monitorCard.cpuValue.toFixed(0) + "%"
                  + "  |  Memory: " + (memorySlider.value * 100).toFixed(0) + "%"
                  + "  |  Disk: 78%"
            font.pixelSize: Style.resize(13)
            color: Style.fontPrimaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item { Layout.fillHeight: true }
    }
}
