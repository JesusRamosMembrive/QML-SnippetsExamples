import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                // Header
                Label {
                    text: "Button Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // Standard Buttons Section
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(180)
                    color: "white"
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(15)

                        Label {
                            text: "Standard Buttons"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        RowLayout {
                            spacing: Style.resize(15)
                            Layout.fillWidth: true

                            Button {
                                text: "Default Button"
                                Layout.preferredWidth: Style.resize(150)
                                Layout.preferredHeight: Style.resize(40)
                            }

                            Button {
                                text: "Highlighted"
                                highlighted: true
                                Layout.preferredWidth: Style.resize(150)
                                Layout.preferredHeight: Style.resize(40)
                            }

                            Button {
                                text: "Flat Button"
                                flat: true
                                Layout.preferredWidth: Style.resize(150)
                                Layout.preferredHeight: Style.resize(40)
                            }

                            Button {
                                text: "Disabled"
                                enabled: false
                                Layout.preferredWidth: Style.resize(150)
                                Layout.preferredHeight: Style.resize(40)
                            }
                        }

                        Label {
                            text: "Click any button to see the interaction"
                            font.pixelSize: Style.resize(12)
                            color: "#666"
                            Layout.topMargin: Style.resize(10)
                        }
                    }
                }

                // Icon Buttons Section
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(170)
                    color: "white"
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
                            color: "#666"
                        }
                    }
                }

                // Button States Section
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(240)
                    color: "white"
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(15)

                        Label {
                            text: "Button States & Interactions"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        RowLayout {
                            spacing: Style.resize(15)
                            Layout.fillWidth: true

                            Button {
                                id: clickableButton
                                text: clickableButton.down ? "Pressed!" : "Press Me"
                                Layout.preferredWidth: Style.resize(150)
                                Layout.preferredHeight: Style.resize(40)
                                onClicked: {
                                    statusLabel.text = "Button clicked!";
                                    clickTimer.restart();
                                }
                            }

                            Button {
                                text: hoverButton.hovered ? "Hovering" : "Hover Me"
                                id: hoverButton
                                Layout.preferredWidth: Style.resize(150)
                                Layout.preferredHeight: Style.resize(40)
                            }

                            Button {
                                id: toggleButton
                                text: toggleButton.checked ? "Checked" : "Checkable"
                                checkable: true
                                Layout.preferredWidth: Style.resize(150)
                                Layout.preferredHeight: Style.resize(40)
                            }
                        }

                        Label {
                            id: statusLabel
                            text: "Interact with the buttons above"
                            font.pixelSize: Style.resize(14)
                            color: Style.mainColor
                            Layout.topMargin: Style.resize(10)

                            Timer {
                                id: clickTimer
                                interval: 2000
                                onTriggered: statusLabel.text = "Interact with the buttons above"
                            }
                        }

                        Label {
                            text: "• down: Button is being pressed\n• hovered: Mouse is over the button\n• checkable: Button can be toggled on/off"
                            font.pixelSize: Style.resize(12)
                            color: "#666"
                        }
                    }
                }

                // Custom Styled Buttons
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(160)
                    color: "white"
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(15)

                        Label {
                            text: "Custom Styled Buttons"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        RowLayout {
                            spacing: Style.resize(15)
                            Layout.fillWidth: true

                            Button {
                                text: "Success"
                                Layout.preferredWidth: Style.resize(120)
                                Layout.preferredHeight: Style.resize(40)
                                palette.button: "#00D1A8"
                                palette.buttonText: "white"
                            }

                            Button {
                                text: "Warning"
                                Layout.preferredWidth: Style.resize(120)
                                Layout.preferredHeight: Style.resize(40)
                                palette.button: "#FFE361"
                                palette.buttonText: "#333"
                            }

                            Button {
                                text: "Danger"
                                Layout.preferredWidth: Style.resize(120)
                                Layout.preferredHeight: Style.resize(40)
                                palette.button: "#FF5900"
                                palette.buttonText: "white"
                            }
                        }

                        Label {
                            text: "You can customize button colors using the palette property"
                            font.pixelSize: Style.resize(12)
                            color: "#666"
                        }
                    }
                }
            }
        }
    }
}
