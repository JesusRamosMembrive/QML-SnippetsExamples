import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Nested Dashboard Layout"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(340)

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                spacing: Style.resize(6)

                // Top bar
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(6)

                    Repeater {
                        model: [
                            { label: "Total Sales", val: "$24,580", change: "+12.5%", up: true, clr: "#00D1A9" },
                            { label: "Active Users", val: "3,847", change: "+8.2%", up: true, clr: "#5B8DEF" },
                            { label: "Bounce Rate", val: "32.1%", change: "-2.4%", up: false, clr: "#FF3B30" },
                            { label: "Conversion", val: "5.7%", change: "+0.8%", up: true, clr: "#FF9500" }
                        ]

                        delegate: Rectangle {
                            id: kpiCard
                            required property var modelData
                            Layout.fillWidth: true
                            height: Style.resize(60)
                            radius: Style.resize(6)
                            color: Style.surfaceColor

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: Style.resize(8)
                                spacing: Style.resize(2)

                                Label {
                                    text: kpiCard.modelData.label
                                    font.pixelSize: Style.resize(9)
                                    color: Style.fontSecondaryColor
                                }

                                Label {
                                    text: kpiCard.modelData.val
                                    font.pixelSize: Style.resize(16)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }

                                Label {
                                    text: kpiCard.modelData.change
                                    font.pixelSize: Style.resize(10)
                                    font.bold: true
                                    color: kpiCard.modelData.up ? "#34C759" : "#FF3B30"
                                }
                            }
                        }
                    }
                }

                // Middle: chart area + side panel
                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Style.resize(6)

                    // Chart area
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: Style.resize(6)
                        color: Style.surfaceColor

                        // Fake chart bars
                        Row {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: Style.resize(15)
                            anchors.bottomMargin: Style.resize(25)
                            spacing: Style.resize(6)
                            height: Style.resize(120)

                            Repeater {
                                model: [0.6, 0.8, 0.45, 0.9, 0.7, 0.55, 0.85, 0.65, 0.75, 0.5, 0.92, 0.6]

                                delegate: Rectangle {
                                    id: chartBar
                                    required property real modelData
                                    required property int index

                                    width: (parent.width - Style.resize(6) * 11) / 12
                                    height: parent.height * chartBar.modelData
                                    anchors.bottom: parent.bottom
                                    radius: Style.resize(3)
                                    color: Qt.hsla(0.47, 0.65, 0.35 + chartBar.modelData * 0.2, 1)
                                }
                            }
                        }

                        Label {
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.margins: Style.resize(10)
                            text: "Monthly Revenue"
                            font.pixelSize: Style.resize(11)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        // X-axis labels
                        Row {
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: Style.resize(15)
                            anchors.bottomMargin: Style.resize(6)

                            Repeater {
                                model: ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]
                                Label {
                                    required property string modelData
                                    width: (parent.width) / 12
                                    text: modelData
                                    font.pixelSize: Style.resize(8)
                                    color: Style.inactiveColor
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                        }
                    }

                    // Side panel
                    Rectangle {
                        Layout.preferredWidth: Style.resize(160)
                        Layout.fillHeight: true
                        radius: Style.resize(6)
                        color: Style.surfaceColor

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(10)
                            spacing: Style.resize(6)

                            Label {
                                text: "Recent Activity"
                                font.pixelSize: Style.resize(11)
                                font.bold: true
                                color: Style.fontPrimaryColor
                            }

                            Repeater {
                                model: [
                                    { ev: "New signup", t: "2m ago", clr: "#34C759" },
                                    { ev: "Purchase", t: "5m ago", clr: "#5B8DEF" },
                                    { ev: "Refund", t: "12m ago", clr: "#FF3B30" },
                                    { ev: "Login", t: "18m ago", clr: "#FF9500" },
                                    { ev: "Upload", t: "25m ago", clr: "#AF52DE" }
                                ]

                                delegate: RowLayout {
                                    id: activityRow
                                    required property var modelData
                                    Layout.fillWidth: true
                                    spacing: Style.resize(6)

                                    Rectangle {
                                        width: Style.resize(6)
                                        height: Style.resize(6)
                                        radius: width / 2
                                        color: activityRow.modelData.clr
                                    }

                                    Label {
                                        text: activityRow.modelData.ev
                                        font.pixelSize: Style.resize(10)
                                        color: Style.fontPrimaryColor
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                    }

                                    Label {
                                        text: activityRow.modelData.t
                                        font.pixelSize: Style.resize(9)
                                        color: Style.inactiveColor
                                    }
                                }
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }
                }

                // Bottom bar
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(6)

                    Repeater {
                        model: [
                            { label: "Pending Orders", count: "23" },
                            { label: "Support Tickets", count: "7" },
                            { label: "Scheduled Tasks", count: "14" }
                        ]

                        delegate: Rectangle {
                            id: bottomCard
                            required property var modelData
                            Layout.fillWidth: true
                            height: Style.resize(36)
                            radius: Style.resize(6)
                            color: Style.surfaceColor

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Style.resize(10)
                                anchors.rightMargin: Style.resize(10)

                                Label {
                                    text: bottomCard.modelData.label
                                    font.pixelSize: Style.resize(10)
                                    color: Style.fontSecondaryColor
                                    Layout.fillWidth: true
                                }

                                Rectangle {
                                    width: Style.resize(24)
                                    height: Style.resize(20)
                                    radius: Style.resize(4)
                                    color: Qt.rgba(0, 0.82, 0.66, 0.15)

                                    Label {
                                        anchors.centerIn: parent
                                        text: bottomCard.modelData.count
                                        font.pixelSize: Style.resize(10)
                                        font.bold: true
                                        color: Style.mainColor
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
