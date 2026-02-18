pragma ComponentBehavior: Bound
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
        spacing: Style.resize(10)

        Label {
            text: "System Status"
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

                GridLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(15)
                    columns: 2
                    rowSpacing: Style.resize(12)
                    columnSpacing: Style.resize(15)

                    // HYD System
                    Label {
                        text: "HYD"
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: "#FFFFFF"
                        Layout.columnSpan: 2
                    }

                    Repeater {
                        model: [
                            { name: "GREEN", clr: "#4CAF50", val: hydGreenSlider.value },
                            { name: "BLUE", clr: "#2196F3", val: hydBlueSlider.value },
                            { name: "YELLOW", clr: "#FFEB3B", val: hydYellowSlider.value }
                        ]

                        RowLayout {
                            id: hydDelegate
                            required property var modelData

                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            Label {
                                text: hydDelegate.modelData.name
                                font.pixelSize: Style.resize(12)
                                color: hydDelegate.modelData.clr
                                Layout.preferredWidth: Style.resize(60)
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: Style.resize(16)
                                color: "#333333"
                                radius: Style.resize(3)

                                Rectangle {
                                    width: parent.width * hydDelegate.modelData.val / 100
                                    height: parent.height
                                    color: hydDelegate.modelData.val > 20 ? hydDelegate.modelData.clr : "#F44336"
                                    radius: Style.resize(3)
                                    Behavior on width { NumberAnimation { duration: 200 } }
                                }
                            }

                            Label {
                                text: Math.round(hydDelegate.modelData.val) + "%"
                                font.pixelSize: Style.resize(11)
                                color: hydDelegate.modelData.val > 20 ? hydDelegate.modelData.clr : "#F44336"
                                Layout.preferredWidth: Style.resize(35)
                            }
                        }
                    }

                    // ELEC System
                    Label {
                        text: "ELEC"
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: "#FFFFFF"
                        Layout.columnSpan: 2
                        Layout.topMargin: Style.resize(5)
                    }

                    Repeater {
                        model: [
                            { name: "AC BUS 1", on: acBus1Switch.checked },
                            { name: "AC BUS 2", on: acBus2Switch.checked },
                            { name: "DC BAT", on: true }
                        ]

                        RowLayout {
                            id: elecDelegate
                            required property var modelData

                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            Label {
                                text: elecDelegate.modelData.name
                                font.pixelSize: Style.resize(12)
                                color: "#AAAAAA"
                                Layout.preferredWidth: Style.resize(70)
                            }

                            Rectangle {
                                Layout.preferredWidth: Style.resize(12)
                                Layout.preferredHeight: Style.resize(12)
                                radius: width / 2
                                color: elecDelegate.modelData.on ? "#4CAF50" : "#F44336"
                            }

                            Label {
                                text: elecDelegate.modelData.on ? "ON" : "OFF"
                                font.pixelSize: Style.resize(12)
                                font.bold: true
                                color: elecDelegate.modelData.on ? "#4CAF50" : "#F44336"
                                Layout.fillWidth: true
                            }
                        }
                    }

                    // BLEED & PRESS
                    Label {
                        text: "BLEED / PRESS"
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: "#FFFFFF"
                        Layout.columnSpan: 2
                        Layout.topMargin: Style.resize(5)
                    }

                    Repeater {
                        model: [
                            { name: "BLEED 1", on: bleed1Switch.checked },
                            { name: "BLEED 2", on: bleed2Switch.checked },
                            { name: "PACK 1", on: bleed1Switch.checked },
                            { name: "PACK 2", on: bleed2Switch.checked }
                        ]

                        RowLayout {
                            id: bleedDelegate
                            required property var modelData

                            Layout.fillWidth: true
                            spacing: Style.resize(8)

                            Label {
                                text: bleedDelegate.modelData.name
                                font.pixelSize: Style.resize(12)
                                color: "#AAAAAA"
                                Layout.preferredWidth: Style.resize(70)
                            }

                            Rectangle {
                                Layout.preferredWidth: Style.resize(12)
                                Layout.preferredHeight: Style.resize(12)
                                radius: width / 2
                                color: bleedDelegate.modelData.on ? "#4CAF50" : "#FF9800"
                            }

                            Label {
                                text: bleedDelegate.modelData.on ? "ON" : "OFF"
                                font.pixelSize: Style.resize(12)
                                font.bold: true
                                color: bleedDelegate.modelData.on ? "#4CAF50" : "#FF9800"
                                Layout.fillWidth: true
                            }
                        }
                    }

                    Item { Layout.fillHeight: true; Layout.columnSpan: 2 }
                }
            }
        }

        // System controls
        GridLayout {
            Layout.fillWidth: true
            columns: 4
            columnSpacing: Style.resize(8)
            rowSpacing: Style.resize(4)

            Label { text: "HYD G"; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
            Slider {
                id: hydGreenSlider
                Layout.fillWidth: true
                from: 0; to: 100; value: 95
            }
            Label { text: "HYD B"; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
            Slider {
                id: hydBlueSlider
                Layout.fillWidth: true
                from: 0; to: 100; value: 90
            }

            Label { text: "HYD Y"; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
            Slider {
                id: hydYellowSlider
                Layout.fillWidth: true
                from: 0; to: 100; value: 85
            }

            // Switches
            RowLayout {
                Layout.fillWidth: true
                spacing: Style.resize(4)
                Switch { id: acBus1Switch; checked: true; scale: 0.6 }
                Label { text: "AC1"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor }
                Switch { id: acBus2Switch; checked: true; scale: 0.6 }
                Label { text: "AC2"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor }
                Switch { id: bleed1Switch; checked: true; scale: 0.6 }
                Label { text: "BL1"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor }
                Switch { id: bleed2Switch; checked: true; scale: 0.6 }
                Label { text: "BL2"; font.pixelSize: Style.resize(10); color: Style.fontSecondaryColor }
            }
        }

        Label {
            text: "HYD pressure bars (Green/Blue/Yellow), ELEC bus status, BLEED/PACK indicators. Toggle switches to simulate faults."
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
