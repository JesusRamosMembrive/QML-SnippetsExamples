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

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                // Header
                Label {
                    text: "Dials & Indicators Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    // ========================================
                    // Card 1: Dial
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                        color: "white"
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(15)

                            Label {
                                text: "Dial"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: Style.resize(20)

                                // Basic Dial
                                ColumnLayout {
                                    spacing: Style.resize(8)
                                    Layout.alignment: Qt.AlignHCenter

                                    Item {
                                        Layout.preferredWidth: Style.resize(100)
                                        Layout.preferredHeight: Style.resize(100)
                                        Layout.alignment: Qt.AlignHCenter

                                        Dial {
                                            id: basicDial
                                            anchors.fill: parent
                                            from: 0
                                            to: 100
                                            value: 35
                                        }

                                        Label {
                                            anchors.centerIn: parent
                                            text: basicDial.value.toFixed(0)
                                            font.pixelSize: Style.resize(16)
                                            font.bold: true
                                            color: Style.mainColor
                                        }
                                    }

                                    Label {
                                        text: "Basic (0-100)"
                                        font.pixelSize: Style.resize(12)
                                        color: "#666"
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                // Stepped Dial
                                ColumnLayout {
                                    spacing: Style.resize(8)
                                    Layout.alignment: Qt.AlignHCenter

                                    Item {
                                        Layout.preferredWidth: Style.resize(100)
                                        Layout.preferredHeight: Style.resize(100)
                                        Layout.alignment: Qt.AlignHCenter

                                        Dial {
                                            id: steppedDial
                                            anchors.fill: parent
                                            from: 0
                                            to: 100
                                            stepSize: 10
                                            snapMode: Dial.SnapAlways
                                            value: 50
                                        }

                                        Label {
                                            anchors.centerIn: parent
                                            text: steppedDial.value.toFixed(0)
                                            font.pixelSize: Style.resize(16)
                                            font.bold: true
                                            color: Style.mainColor
                                        }
                                    }

                                    Label {
                                        text: "Stepped (10)"
                                        font.pixelSize: Style.resize(12)
                                        color: "#666"
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                // Temperature Dial
                                ColumnLayout {
                                    spacing: Style.resize(8)
                                    Layout.alignment: Qt.AlignHCenter

                                    Item {
                                        Layout.preferredWidth: Style.resize(100)
                                        Layout.preferredHeight: Style.resize(100)
                                        Layout.alignment: Qt.AlignHCenter

                                        Dial {
                                            id: tempDial
                                            anchors.fill: parent
                                            from: 0
                                            to: 40
                                            stepSize: 1
                                            snapMode: Dial.SnapAlways
                                            value: 21
                                        }

                                        Label {
                                            anchors.centerIn: parent
                                            text: tempDial.value.toFixed(0) + "°C"
                                            font.pixelSize: Style.resize(14)
                                            font.bold: true
                                            color: Style.mainColor
                                        }
                                    }

                                    Label {
                                        text: "Temp (0-40°C)"
                                        font.pixelSize: Style.resize(12)
                                        color: "#666"
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }

                            Label {
                                text: "Dial provides a rotary control for selecting values within a range"
                                font.pixelSize: Style.resize(12)
                                color: "#666"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 2: ProgressBar
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                        color: "white"
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(15)

                            Label {
                                text: "ProgressBar"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            // Determinate ProgressBar
                            Label {
                                text: "Determinate: " + (progressSlider.value * 100).toFixed(0) + "%"
                                font.pixelSize: Style.resize(13)
                                color: "#333"
                            }

                            ProgressBar {
                                id: determinateBar
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(8)
                                from: 0
                                to: 1
                                value: progressSlider.value
                            }

                            Item {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(40)

                                Slider {
                                    id: progressSlider
                                    anchors.fill: parent
                                    anchors.leftMargin: Style.resize(10)
                                    anchors.rightMargin: Style.resize(10)
                                    from: 0
                                    to: 1
                                    value: 0.65
                                    stepSize: 0.01
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                color: Style.bgColor
                            }

                            // Indeterminate ProgressBar
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(10)

                                Label {
                                    text: "Indeterminate:"
                                    font.pixelSize: Style.resize(13)
                                    color: "#333"
                                    Layout.fillWidth: true
                                }

                                Switch {
                                    id: indeterminateSwitch
                                    text: indeterminateSwitch.checked ? "ON" : "OFF"
                                    checked: true
                                }
                            }

                            ProgressBar {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(8)
                                indeterminate: indeterminateSwitch.checked
                            }

                            Item { Layout.fillHeight: true }

                            Label {
                                text: "ProgressBar shows task completion. Indeterminate mode indicates unknown duration"
                                font.pixelSize: Style.resize(12)
                                color: "#666"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // ========================================
                    // Card 3: BusyIndicator
                    // ========================================
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                        color: "white"
                        radius: Style.resize(8)

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(20)
                            spacing: Style.resize(15)

                            Label {
                                text: "BusyIndicator"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            Switch {
                                id: busySwitch
                                text: "Running"
                                checked: true
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: Style.resize(40)
                                Layout.alignment: Qt.AlignHCenter

                                // Default size
                                ColumnLayout {
                                    spacing: Style.resize(10)
                                    Layout.alignment: Qt.AlignHCenter

                                    BusyIndicator {
                                        running: busySwitch.checked
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Label {
                                        text: "Default (40px)"
                                        font.pixelSize: Style.resize(12)
                                        color: "#666"
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }

                                // Large size
                                ColumnLayout {
                                    spacing: Style.resize(10)
                                    Layout.alignment: Qt.AlignHCenter

                                    BusyIndicator {
                                        running: busySwitch.checked
                                        implicitWidth: Style.resize(80)
                                        implicitHeight: Style.resize(80)
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    Label {
                                        text: "Large (80px)"
                                        font.pixelSize: Style.resize(12)
                                        color: "#666"
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }

                            Label {
                                text: busySwitch.checked ? "Status: Loading..." : "Status: Idle"
                                font.pixelSize: Style.resize(14)
                                font.bold: true
                                color: busySwitch.checked ? Style.mainColor : Style.inactiveColor
                            }

                            Label {
                                text: "BusyIndicator shows that an operation is in progress"
                                font.pixelSize: Style.resize(12)
                                color: "#666"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }

                    // ========================================
                    // Card 4: Interactive Demo - System Monitor
                    // ========================================
                    Rectangle {
                        id: monitorCard
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                        color: "white"
                        radius: Style.resize(8)

                        property real cpuValue: 25

                        Timer {
                            running: root.fullSize
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

                                    Item {
                                        Layout.preferredWidth: Style.resize(100)
                                        Layout.preferredHeight: Style.resize(100)
                                        Layout.alignment: Qt.AlignHCenter

                                        Dial {
                                            id: cpuDial
                                            anchors.fill: parent
                                            from: 0
                                            to: 100
                                            value: monitorCard.cpuValue
                                            enabled: false

                                            Behavior on value {
                                                NumberAnimation { duration: 500 }
                                            }
                                        }

                                        Label {
                                            anchors.centerIn: parent
                                            text: monitorCard.cpuValue.toFixed(0) + "%"
                                            font.pixelSize: Style.resize(14)
                                            font.bold: true
                                            color: monitorCard.cpuValue > 80 ? "#FF5900" : Style.mainColor
                                        }
                                    }

                                    Label {
                                        text: "CPU Usage"
                                        font.pixelSize: Style.resize(12)
                                        color: "#666"
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
                                        color: monitorCard.cpuValue > 80 ? "#FF5900" : "#666"
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
                                    color: "#333"
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
                                    color: "#333"
                                }

                                ProgressBar {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(8)
                                    value: 0.78
                                }
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: Style.resize(1)
                                color: Style.bgColor
                            }

                            Label {
                                text: "CPU: " + monitorCard.cpuValue.toFixed(0) + "%"
                                      + "  |  Memory: " + (memorySlider.value * 100).toFixed(0) + "%"
                                      + "  |  Disk: 78%"
                                font.pixelSize: Style.resize(13)
                                color: "#333"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }

                } // End of GridLayout
            }
        }
    }
}
