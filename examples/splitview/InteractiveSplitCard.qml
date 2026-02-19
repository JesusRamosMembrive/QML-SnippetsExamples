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
            text: "Color Mixer"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Drag handles to mix RGB channels"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        SplitView {
            id: colorSplit
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: Qt.Horizontal

            handle: Rectangle {
                implicitWidth: Style.resize(6)
                implicitHeight: Style.resize(6)
                color: SplitHandle.pressed ? "#FFFFFF" : Style.inactiveColor

                Rectangle {
                    anchors.centerIn: parent
                    width: Style.resize(2)
                    height: Style.resize(24)
                    radius: 1
                    color: "#FFFFFF"
                    opacity: 0.6
                }
            }

            Rectangle {
                id: redPanel
                SplitView.preferredWidth: colorSplit.width / 3
                SplitView.minimumWidth: Style.resize(30)
                color: Qt.rgba(1, 0, 0, redPanel.width / colorSplit.width)
                radius: Style.resize(4)

                Label {
                    anchors.centerIn: parent
                    text: "R\n" + Math.round(255 * redPanel.width / colorSplit.width)
                    font.pixelSize: Style.resize(16)
                    font.bold: true
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                id: greenPanel
                SplitView.preferredWidth: colorSplit.width / 3
                SplitView.minimumWidth: Style.resize(30)
                color: Qt.rgba(0, 0.8, 0, greenPanel.width / colorSplit.width)
                radius: Style.resize(4)

                Label {
                    anchors.centerIn: parent
                    text: "G\n" + Math.round(255 * greenPanel.width / colorSplit.width)
                    font.pixelSize: Style.resize(16)
                    font.bold: true
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                id: bluePanel
                SplitView.fillWidth: true
                SplitView.minimumWidth: Style.resize(30)
                color: Qt.rgba(0, 0.3, 1, bluePanel.width / colorSplit.width)
                radius: Style.resize(4)

                Label {
                    anchors.centerIn: parent
                    text: "B\n" + Math.round(255 * bluePanel.width / colorSplit.width)
                    font.pixelSize: Style.resize(16)
                    font.bold: true
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        // Mixed color preview
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(35)
            radius: Style.resize(6)
            color: Qt.rgba(
                redPanel.width / colorSplit.width,
                0.8 * greenPanel.width / colorSplit.width,
                bluePanel.width / colorSplit.width,
                1.0
            )

            Label {
                anchors.centerIn: parent
                text: "Mixed: rgb(" +
                      Math.round(255 * redPanel.width / colorSplit.width) + ", " +
                      Math.round(255 * 0.8 * greenPanel.width / colorSplit.width) + ", " +
                      Math.round(255 * bluePanel.width / colorSplit.width) + ")"
                font.pixelSize: Style.resize(13)
                font.bold: true
                color: "#FFFFFF"
            }
        }
    }
}
