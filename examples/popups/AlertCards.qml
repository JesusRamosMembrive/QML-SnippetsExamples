import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Alert Cards"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Style.resize(8)

        Repeater {
            model: [
                { type: "success", icon: "✓", title: "Success",
                  msg: "Your changes have been saved successfully.",
                  bg: "#1A3A2A", accent: "#34C759" },
                { type: "error", icon: "✕", title: "Error",
                  msg: "Unable to connect to the server. Check your network.",
                  bg: "#3A1A1A", accent: "#FF3B30" },
                { type: "warning", icon: "⚠", title: "Warning",
                  msg: "This action cannot be undone. Proceed with caution.",
                  bg: "#3A2E1A", accent: "#FF9500" },
                { type: "info", icon: "ℹ", title: "Information",
                  msg: "Scheduled maintenance window: Sunday 2:00-4:00 AM UTC.",
                  bg: "#1A2A3A", accent: "#5B8DEF" }
            ]

            delegate: Rectangle {
                id: alertCard
                required property var modelData
                required property int index

                property bool dismissed: false

                Layout.fillWidth: true
                height: dismissed ? 0 : Style.resize(70)
                radius: Style.resize(8)
                color: alertCard.modelData.bg
                border.color: Qt.rgba(
                    Qt.color(alertCard.modelData.accent).r,
                    Qt.color(alertCard.modelData.accent).g,
                    Qt.color(alertCard.modelData.accent).b, 0.3)
                border.width: Style.resize(1)
                clip: true
                opacity: dismissed ? 0 : 1

                Behavior on height { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: 200 } }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(14)
                    spacing: Style.resize(12)

                    // Icon circle
                    Rectangle {
                        width: Style.resize(34)
                        height: Style.resize(34)
                        radius: width / 2
                        color: Qt.rgba(
                            Qt.color(alertCard.modelData.accent).r,
                            Qt.color(alertCard.modelData.accent).g,
                            Qt.color(alertCard.modelData.accent).b, 0.2)

                        Label {
                            anchors.centerIn: parent
                            text: alertCard.modelData.icon
                            font.pixelSize: Style.resize(16)
                            font.bold: true
                            color: alertCard.modelData.accent
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: Style.resize(2)

                        Label {
                            text: alertCard.modelData.title
                            font.pixelSize: Style.resize(14)
                            font.bold: true
                            color: alertCard.modelData.accent
                        }
                        Label {
                            text: alertCard.modelData.msg
                            font.pixelSize: Style.resize(11)
                            color: Style.fontSecondaryColor
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }

                    // Dismiss button
                    Rectangle {
                        width: Style.resize(24)
                        height: Style.resize(24)
                        radius: width / 2
                        color: alertDismissMa.containsMouse ? Qt.rgba(1, 1, 1, 0.1) : "transparent"

                        Label {
                            anchors.centerIn: parent
                            text: "✕"
                            font.pixelSize: Style.resize(12)
                            color: Style.inactiveColor
                        }

                        MouseArea {
                            id: alertDismissMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: alertCard.dismissed = true
                        }
                    }
                }
            }
        }

        Button {
            text: "Reset Alerts"
            flat: true
            font.pixelSize: Style.resize(11)
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                for (var i = 0; i < parent.children.length; i++) {
                    var child = parent.children[i]
                    if (child.dismissed !== undefined)
                        child.dismissed = false
                }
            }
        }
    }
}
