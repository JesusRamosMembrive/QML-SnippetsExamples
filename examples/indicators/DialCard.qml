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

                Dial {
                    id: basicDial
                    Layout.preferredWidth: Style.resize(140)
                    Layout.preferredHeight: Style.resize(140)
                    Layout.alignment: Qt.AlignHCenter
                    from: 0
                    to: 100
                    value: 35
                }

                Label {
                    text: "Basic (0-100)"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Stepped Dial
            ColumnLayout {
                spacing: Style.resize(8)
                Layout.alignment: Qt.AlignHCenter

                Dial {
                    id: steppedDial
                    Layout.preferredWidth: Style.resize(140)
                    Layout.preferredHeight: Style.resize(140)
                    Layout.alignment: Qt.AlignHCenter
                    from: 0
                    to: 100
                    stepSize: 10
                    snapMode: Dial.SnapAlways
                    value: 50
                }

                Label {
                    text: "Stepped (10)"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Temperature Dial
            ColumnLayout {
                spacing: Style.resize(8)
                Layout.alignment: Qt.AlignHCenter

                Dial {
                    id: tempDial
                    Layout.preferredWidth: Style.resize(140)
                    Layout.preferredHeight: Style.resize(140)
                    Layout.alignment: Qt.AlignHCenter
                    from: 0
                    to: 40
                    stepSize: 1
                    snapMode: Dial.SnapAlways
                    value: 21
                    suffix: "°C"
                }

                Label {
                    text: "Temp (0-40°C)"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        Label {
            text: "Dial provides a rotary control for selecting values within a range"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
