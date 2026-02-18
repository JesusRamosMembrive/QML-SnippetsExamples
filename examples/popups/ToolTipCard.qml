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
            text: "ToolTip"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Button {
            text: "Instant ToolTip"
            Layout.fillWidth: true
            ToolTip.delay: 0
            ToolTip.timeout: 3000
            ToolTip.visible: hovered
            ToolTip.text: "This appears immediately!"
        }

        Button {
            text: "500ms Delay"
            Layout.fillWidth: true
            ToolTip.delay: 500
            ToolTip.timeout: 3000
            ToolTip.visible: hovered
            ToolTip.text: "This appears after 500ms"
        }

        Button {
            text: "1500ms Delay"
            Layout.fillWidth: true
            ToolTip.delay: 1500
            ToolTip.timeout: 5000
            ToolTip.visible: hovered
            ToolTip.text: "This appears after 1.5 seconds"
        }

        Item { Layout.fillHeight: true }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(60)
            color: Style.bgColor
            radius: Style.resize(8)
            border.color: Style.inactiveColor
            border.width: 1

            Label {
                anchors.centerIn: parent
                text: "Hover over this area"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            MouseArea {
                id: hoverArea
                anchors.fill: parent
                hoverEnabled: true
            }

            ToolTip {
                parent: hoverArea
                visible: hoverArea.containsMouse
                delay: 300
                timeout: 4000
                text: "ToolTips work on any item with a MouseArea"
            }
        }

        Label {
            text: "ToolTip shows contextual help on hover with configurable delay and timeout"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
