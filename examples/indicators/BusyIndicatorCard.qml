import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
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
                    color: Style.fontSecondaryColor
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
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Custom gradient arc spinner
            ColumnLayout {
                spacing: Style.resize(10)
                Layout.alignment: Qt.AlignHCenter

                Rectangle {
                    Layout.preferredWidth: Style.resize(90)
                    Layout.preferredHeight: Style.resize(90)
                    Layout.alignment: Qt.AlignHCenter
                    radius: Style.resize(12)
                    color: "#1B2838"

                    Item {
                        id: spinnerContainer
                        anchors.centerIn: parent
                        width: Style.resize(50)
                        height: Style.resize(50)

                        RotationAnimation on rotation {
                            from: 0; to: 360
                            duration: 1200
                            loops: Animation.Infinite
                            running: busySwitch.checked
                        }

                        Canvas {
                            id: gradientSpinner
                            anchors.fill: parent

                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.reset()

                                var cx = width / 2
                                var cy = height / 2
                                var r = cx - Style.resize(4)
                                var lw = Style.resize(3.5)
                                var steps = 40
                                var arcSpan = 1.6 * Math.PI // ~290°

                                for (var i = 0; i < steps; i++) {
                                    var a0 = -Math.PI / 2 + (i / steps) * arcSpan
                                    var a1 = -Math.PI / 2 + ((i + 1.5) / steps) * arcSpan
                                    var alpha = i / steps

                                    ctx.beginPath()
                                    ctx.arc(cx, cy, r, a0, a1, false)
                                    ctx.strokeStyle = Qt.rgba(0, 0.82, 0.66, alpha)
                                    ctx.lineWidth = lw
                                    ctx.lineCap = "round"
                                    ctx.stroke()
                                }
                            }

                            Component.onCompleted: requestPaint()
                        }
                    }
                }

                Label {
                    text: "Custom (Canvas)"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
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
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item { Layout.fillHeight: true }
    }
}
