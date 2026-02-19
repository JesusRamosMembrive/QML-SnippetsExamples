import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property string lastAction: "None"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Basic ToolBar"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // ToolBar with ToolButtons
        ToolBar {
            Layout.fillWidth: true
            background: Rectangle {
                color: Style.bgColor
                radius: Style.resize(4)
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.resize(8)
                anchors.rightMargin: Style.resize(8)
                spacing: Style.resize(4)

                ToolButton { text: "\u2302"; onClicked: root.lastAction = "Home"; ToolTip.text: "Home"; ToolTip.visible: hovered }
                ToolButton { text: "\u2190"; onClicked: root.lastAction = "Back"; ToolTip.text: "Back"; ToolTip.visible: hovered }
                ToolButton { text: "\u2192"; onClicked: root.lastAction = "Forward"; ToolTip.text: "Forward"; ToolTip.visible: hovered }
                ToolButton { text: "\u21BB"; onClicked: root.lastAction = "Refresh"; ToolTip.text: "Refresh"; ToolTip.visible: hovered }

                Item { Layout.fillWidth: true }

                ToolButton { text: "\u2699"; onClicked: root.lastAction = "Settings"; ToolTip.text: "Settings"; ToolTip.visible: hovered }
            }
        }

        // Content area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(4)

            Label {
                anchors.centerIn: parent
                text: "ToolBar with ToolButtons and ToolTips\n\nLast action: " + root.lastAction
                font.pixelSize: Style.resize(14)
                color: Style.fontPrimaryColor
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
