import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Dial — Styled Qt Controls"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(30)

            // Temperature dial
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Style.resize(8)

                Dial {
                    id: tempDial
                    Layout.preferredWidth: Style.resize(180)
                    Layout.preferredHeight: Style.resize(180)
                    Layout.alignment: Qt.AlignHCenter
                    from: 16
                    to: 32
                    value: 22
                    stepSize: 0.5
                    valueDecimals: 1
                    suffix: "°C"
                    progressColor: {
                        var ratio = tempDial.position
                        if (ratio < 0.35) return "#4FC3F7"
                        if (ratio < 0.65) return Style.mainColor
                        return "#FF7043"
                    }
                }

                Label {
                    text: "Temperature"
                    font.pixelSize: Style.resize(14)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Volume dial
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Style.resize(8)

                Dial {
                    Layout.preferredWidth: Style.resize(180)
                    Layout.preferredHeight: Style.resize(180)
                    Layout.alignment: Qt.AlignHCenter
                    from: 0
                    to: 100
                    value: 65
                    stepSize: 1
                    suffix: "%"
                    progressColor: "#7C4DFF"
                    trackWidth: Style.resize(12)
                }

                Label {
                    text: "Volume"
                    font.pixelSize: Style.resize(14)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Speed dial (no ticks, thin)
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Style.resize(8)

                Dial {
                    Layout.preferredWidth: Style.resize(180)
                    Layout.preferredHeight: Style.resize(180)
                    Layout.alignment: Qt.AlignHCenter
                    from: 0
                    to: 200
                    value: 80
                    stepSize: 5
                    suffix: "km/h"
                    showTicks: false
                    trackWidth: Style.resize(6)
                    progressColor: "#FF5900"
                }

                Label {
                    text: "Speed"
                    font.pixelSize: Style.resize(14)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Info column
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: Style.resize(10)

                Label {
                    text: "Custom Properties"
                    font.pixelSize: Style.resize(16)
                    font.bold: true
                    color: Style.fontSecondaryColor
                }

                Label {
                    text: "• progressColor — arc color\n• trackWidth — arc thickness\n• showTicks / tickCount\n• suffix — unit label\n• valueDecimals — precision\n• showValue — center display"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    lineHeight: 1.4
                }

                Label {
                    text: "Native Dial interaction:\ndrag, mouse wheel, arrow keys"
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                    color: Style.mainColor
                }
            }
        }
    }
}
