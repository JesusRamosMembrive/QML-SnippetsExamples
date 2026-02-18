import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Bottom Sheet"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        id: bottomSheetSection
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(350)
        clip: true

        property bool sheetOpen: false

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
        }

        // Background content
        ColumnLayout {
            anchors.centerIn: parent
            spacing: Style.resize(15)

            Label {
                text: "Main Content Area"
                font.pixelSize: Style.resize(16)
                color: Style.fontSecondaryColor
                Layout.alignment: Qt.AlignHCenter
            }

            Button {
                text: "Open Bottom Sheet"
                Layout.alignment: Qt.AlignHCenter
                onClicked: bottomSheetSection.sheetOpen = true
            }
        }

        // Dim overlay
        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.4)
            opacity: bottomSheetSection.sheetOpen ? 1 : 0
            visible: opacity > 0

            Behavior on opacity { NumberAnimation { duration: 200 } }

            MouseArea {
                anchors.fill: parent
                onClicked: bottomSheetSection.sheetOpen = false
            }
        }

        // Sheet
        Rectangle {
            id: bottomSheet
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Style.resize(240)
            radius: Style.resize(16)
            color: Style.cardColor
            y: bottomSheetSection.sheetOpen
               ? parent.height - height
               : parent.height

            Behavior on y {
                NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(16)
                spacing: Style.resize(12)

                // Drag handle
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: Style.resize(40)
                    height: Style.resize(4)
                    radius: Style.resize(2)
                    color: Qt.rgba(1, 1, 1, 0.2)
                }

                Label {
                    text: "Share with"
                    font.pixelSize: Style.resize(16)
                    font.bold: true
                    color: Style.fontPrimaryColor
                }

                // Share options
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(15)
                    Layout.alignment: Qt.AlignHCenter

                    Repeater {
                        model: [
                            { name: "Email", icon: "✉", clr: "#5B8DEF" },
                            { name: "Link", icon: "🔗", clr: "#00D1A9" },
                            { name: "Twitter", icon: "𝕏", clr: "#1DA1F2" },
                            { name: "Slack", icon: "#", clr: "#E01E5A" },
                            { name: "Save", icon: "💾", clr: "#FF9500" }
                        ]

                        delegate: ColumnLayout {
                            id: shareDelegate
                            required property var modelData
                            spacing: Style.resize(6)

                            Rectangle {
                                Layout.preferredWidth: Style.resize(48)
                                Layout.preferredHeight: Style.resize(48)
                                Layout.alignment: Qt.AlignHCenter
                                radius: Style.resize(12)
                                color: Qt.rgba(
                                    Qt.color(shareDelegate.modelData.clr).r,
                                    Qt.color(shareDelegate.modelData.clr).g,
                                    Qt.color(shareDelegate.modelData.clr).b, 0.15)

                                scale: shareMa.containsMouse ? 1.15 : 1.0
                                Behavior on scale { NumberAnimation { duration: 100 } }

                                Label {
                                    anchors.centerIn: parent
                                    text: shareDelegate.modelData.icon
                                    font.pixelSize: Style.resize(20)
                                }

                                MouseArea {
                                    id: shareMa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: bottomSheetSection.sheetOpen = false
                                }
                            }

                            Label {
                                text: shareDelegate.modelData.name
                                font.pixelSize: Style.resize(10)
                                color: Style.fontSecondaryColor
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }

                // Action buttons
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(10)

                    Button {
                        text: "Copy Link"
                        Layout.fillWidth: true
                        onClicked: bottomSheetSection.sheetOpen = false
                    }

                    Button {
                        text: "Cancel"
                        flat: true
                        Layout.fillWidth: true
                        onClicked: bottomSheetSection.sheetOpen = false
                    }
                }
            }
        }
    }
}
