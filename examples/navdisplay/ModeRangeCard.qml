import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property string ndMode: "ROSE"
    property int rangeIndex: 2
    property var rangeValues: [10, 20, 40, 80, 160, 320]
    property real currentRange: rangeValues[rangeIndex]
    property real heading: 0
    property var flightPlan: []

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Mode & Range"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: "#1a1a1a"
                radius: Style.resize(6)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(15)
                    spacing: Style.resize(15)

                    // ND Mode
                    Label {
                        text: "ND MODE"
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: "#FFFFFF"
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        columnSpacing: Style.resize(8)
                        rowSpacing: Style.resize(8)

                        Repeater {
                            model: ["ROSE", "ARC", "PLAN", "VOR"]

                            Rectangle {
                                required property string modelData

                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(40)
                                color: root.ndMode === modelData ? "#00FF00" : "#333333"
                                radius: Style.resize(4)
                                border.color: "#00FF00"
                                border.width: root.ndMode === modelData ? 2 : 1

                                Label {
                                    anchors.centerIn: parent
                                    text: parent.modelData
                                    font.pixelSize: Style.resize(14)
                                    font.bold: true
                                    color: parent.color === "#00FF00" ? "#000000" : "#00FF00"
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: root.ndMode = parent.modelData
                                }
                            }
                        }
                    }

                    // Range
                    Label {
                        text: "RANGE"
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: "#FFFFFF"
                        Layout.topMargin: Style.resize(10)
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 3
                        columnSpacing: Style.resize(8)
                        rowSpacing: Style.resize(8)

                        Repeater {
                            model: root.rangeValues.length

                            Rectangle {
                                required property int index

                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(36)
                                color: root.rangeIndex === index ? "#00FF00" : "#333333"
                                radius: Style.resize(4)
                                border.color: "#00FF00"
                                border.width: root.rangeIndex === index ? 2 : 1

                                Label {
                                    anchors.centerIn: parent
                                    text: root.rangeValues[parent.index] + " NM"
                                    font.pixelSize: Style.resize(12)
                                    font.bold: true
                                    color: parent.color === "#00FF00" ? "#000000" : "#00FF00"
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: root.rangeIndex = parent.index
                                }
                            }
                        }
                    }

                    // Status info
                    Item { Layout.preferredHeight: Style.resize(10) }

                    Label {
                        text: "STATUS"
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: "#FFFFFF"
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        columnSpacing: Style.resize(10)
                        rowSpacing: Style.resize(4)

                        Label { text: "Mode:"; font.pixelSize: Style.resize(12); color: "#888888" }
                        Label { text: root.ndMode; font.pixelSize: Style.resize(12); color: "#00FF00"; font.bold: true }

                        Label { text: "Range:"; font.pixelSize: Style.resize(12); color: "#888888" }
                        Label { text: root.currentRange + " NM"; font.pixelSize: Style.resize(12); color: "#00FF00"; font.bold: true }

                        Label { text: "Heading:"; font.pixelSize: Style.resize(12); color: "#888888" }
                        Label { text: Math.round(root.heading).toString().padStart(3, "0") + "\u00B0"; font.pixelSize: Style.resize(12); color: "#00FF00"; font.bold: true }

                        Label { text: "Waypoints:"; font.pixelSize: Style.resize(12); color: "#888888" }
                        Label { text: root.flightPlan.length; font.pixelSize: Style.resize(12); color: "#00FF00"; font.bold: true }
                    }

                    Item { Layout.fillHeight: true }
                }
            }
        }

        Label {
            text: "Switch ND mode (ROSE/ARC/PLAN/VOR) and range. PLAN mode is north-up, others heading-up."
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
