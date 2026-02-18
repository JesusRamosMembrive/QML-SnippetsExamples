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
            text: "Icon Buttons (ToolButton)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        RowLayout {
            spacing: Style.resize(15)
            Layout.fillWidth: true

            ToolButton {
                text: "Settings"
                icon.source: Style.icon("settings")
                Layout.preferredWidth: Style.resize(120)
                Layout.preferredHeight: Style.resize(40)
            }

            ToolButton {
                text: "Info"
                icon.source: Style.icon("status")
                Layout.preferredWidth: Style.resize(120)
                Layout.preferredHeight: Style.resize(40)
            }

            ToolButton {
                icon.source: Style.icon("onoff")
                Layout.preferredWidth: Style.resize(40)
                Layout.preferredHeight: Style.resize(40)
            }
        }

        Label {
            text: "ToolButtons are typically used in toolbars and for icon-only actions"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }
    }
}
