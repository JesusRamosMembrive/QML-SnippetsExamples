import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Collapsible Sidebar"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        id: sidebarSection
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(260)

        property bool sidebarOpen: true

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
            clip: true

            // Sidebar
            Rectangle {
                id: sidebarPanel
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: sidebarSection.sidebarOpen ? Style.resize(180) : Style.resize(48)
                color: Style.surfaceColor

                Behavior on width {
                    NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(8)
                    spacing: Style.resize(4)

                    // Toggle button
                    Rectangle {
                        Layout.fillWidth: true
                        height: Style.resize(32)
                        radius: Style.resize(6)
                        color: sidebarToggleMa.containsMouse ? Qt.rgba(1, 1, 1, 0.06) : "transparent"

                        Label {
                            anchors.centerIn: parent
                            text: sidebarSection.sidebarOpen ? "\u25C0" : "\u25B6"
                            font.pixelSize: Style.resize(14)
                            color: Style.mainColor
                        }

                        MouseArea {
                            id: sidebarToggleMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: sidebarSection.sidebarOpen = !sidebarSection.sidebarOpen
                        }
                    }

                    // Menu items
                    Repeater {
                        model: [
                            { icon: "\uD83C\uDFE0", label: "Home" },
                            { icon: "\uD83D\uDCCA", label: "Analytics" },
                            { icon: "\uD83D\uDC64", label: "Profile" },
                            { icon: "\u2699", label: "Settings" },
                            { icon: "\uD83D\uDCC1", label: "Files" }
                        ]

                        delegate: Rectangle {
                            id: sidebarItem
                            required property var modelData
                            required property int index

                            Layout.fillWidth: true
                            height: Style.resize(34)
                            radius: Style.resize(6)
                            color: sidebarItemMa.containsMouse
                                   ? Qt.rgba(0, 0.82, 0.66, 0.1)
                                   : sidebarItem.index === 0
                                     ? Qt.rgba(0, 0.82, 0.66, 0.15)
                                     : "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Style.resize(8)
                                anchors.rightMargin: Style.resize(8)
                                spacing: Style.resize(10)

                                Label {
                                    text: sidebarItem.modelData.icon
                                    font.pixelSize: Style.resize(16)
                                }

                                Label {
                                    text: sidebarItem.modelData.label
                                    font.pixelSize: Style.resize(12)
                                    color: sidebarItem.index === 0 ? Style.mainColor : Style.fontPrimaryColor
                                    visible: sidebarSection.sidebarOpen
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight

                                    opacity: sidebarSection.sidebarOpen ? 1 : 0
                                    Behavior on opacity { NumberAnimation { duration: 150 } }
                                }
                            }

                            MouseArea {
                                id: sidebarItemMa
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }

                    Item { Layout.fillHeight: true }
                }
            }

            // Main content
            Rectangle {
                anchors.left: sidebarPanel.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: Style.resize(8)
                color: "transparent"

                ColumnLayout {
                    anchors.fill: parent
                    spacing: Style.resize(8)

                    Label {
                        text: "Dashboard Content"
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: Style.fontPrimaryColor
                    }

                    // Mini stats cards
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Style.resize(6)

                        Repeater {
                            model: [
                                { label: "Users", val: "1,247", clr: "#5B8DEF" },
                                { label: "Revenue", val: "$8.4k", clr: "#00D1A9" },
                                { label: "Orders", val: "384", clr: "#FF9500" }
                            ]

                            delegate: Rectangle {
                                id: statCard
                                required property var modelData
                                Layout.fillWidth: true
                                height: Style.resize(55)
                                radius: Style.resize(6)
                                color: Style.surfaceColor

                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: Style.resize(2)

                                    Label {
                                        text: statCard.modelData.val
                                        font.pixelSize: Style.resize(16)
                                        font.bold: true
                                        color: statCard.modelData.clr
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Label {
                                        text: statCard.modelData.label
                                        font.pixelSize: Style.resize(10)
                                        color: Style.fontSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }
                        }
                    }

                    // Content area
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: Style.resize(6)
                        color: Style.surfaceColor

                        Label {
                            anchors.centerIn: parent
                            text: "Main content area expands\nwhen sidebar collapses"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
        }
    }
}
