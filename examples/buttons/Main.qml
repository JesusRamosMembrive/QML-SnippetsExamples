import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils 1.0
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

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
                GridLayout{
                    columns: 2
                    rows: 3
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                // Standard Buttons Section
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(180)
                    color: Style.cardColor
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
                                text: "Default"
                                Layout.preferredWidth: Style.resize(130)
                                Layout.preferredHeight: Style.resize(40)
                            }

                            Button {
                                text: "Highlighted"
                                highlighted: true
                                Layout.preferredWidth: Style.resize(130)
                                Layout.preferredHeight: Style.resize(40)
                            }

                            Button {
                                text: "Flat Button"
                                flat: true
                                Layout.preferredWidth: Style.resize(130)
                                Layout.preferredHeight: Style.resize(40)
                            }

                            Button {
                                text: "Disabled"
                                enabled: false
                                Layout.preferredWidth: Style.resize(130)
                                Layout.preferredHeight: Style.resize(40)
                            }
                        }

                        Label {
                            text: "flat: no background · highlighted: brighter + bold · disabled: grayed out"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                            Layout.topMargin: Style.resize(10)
                        }
                    }
                }

                // Icon Buttons Section
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(180)
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

                // Button States Section
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(240)
                    color: Style.cardColor
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
                                id: hoverButton
                                text: hoverButton.hovered ? "Hovering" : "Hover Me"
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
                            color: Style.fontSecondaryColor
                        }
                    }
                }

                // Custom Styled Buttons
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(240)
                    color: Style.cardColor
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

                        RowLayout {
                            spacing: Style.resize(15)
                            Layout.fillWidth: true

                            Button {
                                text: "Success Flat"
                                flat: true
                                Layout.preferredWidth: Style.resize(120)
                                Layout.preferredHeight: Style.resize(40)
                                palette.button: "#00D1A8"
                            }

                            Button {
                                text: "Warning Flat"
                                flat: true
                                Layout.preferredWidth: Style.resize(120)
                                Layout.preferredHeight: Style.resize(40)
                                palette.button: "#FFE361"
                            }

                            Button {
                                text: "Danger Flat"
                                flat: true
                                Layout.preferredWidth: Style.resize(120)
                                Layout.preferredHeight: Style.resize(40)
                                palette.button: "#FF5900"
                            }
                        }

                        Label {
                            text: "palette.button changes color for both solid and flat variants"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                        }
                    }
                }

                // Specialized Button Components Section
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(200)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(15)

                        Label {
                            text: "Specialized Button Components"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Flow {
                            spacing: Style.resize(15)
                            Layout.fillWidth: true

                            GlowButton {
                                text: "Glow Effect"
                                glowColor: "#00D1A8"
                                width: Style.resize(150)
                                height: Style.resize(40)
                            }

                            GradientButton {
                                text: "Gradient"
                                startColor: "#FF5900"
                                endColor: "#FFE361"
                                width: Style.resize(150)
                                height: Style.resize(40)
                            }

                            PulseButton {
                                text: "Pulse Animation"
                                pulseColor: Style.mainColor
                                width: Style.resize(150)
                                height: Style.resize(40)
                            }

                            NeumorphicButton {
                                text: "Neumorphic"
                                baseColor: Style.bgColor
                                width: Style.resize(150)
                                height: Style.resize(40)
                            }
                        }

                        Label {
                            text: "These specialized components are reusable across all examples"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                        }
                    }
                }

                // ToolButton with Menu Section
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(200)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(15)

                        Label {
                            text: "ToolButton with Menu"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        RowLayout {
                            spacing: Style.resize(20)
                            Layout.fillWidth: true

                            ToolButton {
                                id: fileToolBtn
                                text: "File"
                                icon.source: Style.icon("inbox")
                                Layout.preferredWidth: Style.resize(100)
                                Layout.preferredHeight: Style.resize(40)
                                onClicked: fileMenu.open()

                                Menu {
                                    id: fileMenu
                                    y: fileToolBtn.height

                                    MenuItem { text: "New" }
                                    MenuItem { text: "Open" }
                                    MenuItem { text: "Save" }
                                    MenuSeparator {}
                                    MenuItem { text: "Close" }
                                }
                            }

                            ToolButton {
                                id: settingsToolBtn
                                text: "Settings"
                                icon.source: Style.icon("settings")
                                Layout.preferredWidth: Style.resize(130)
                                Layout.preferredHeight: Style.resize(40)
                                onClicked: settingsMenu.open()

                                Menu {
                                    id: settingsMenu
                                    y: settingsToolBtn.height

                                    MenuItem { text: "Preferences" }
                                    MenuItem { text: "Account" }
                                    MenuItem { text: "Notifications"; checkable: true; checked: true }
                                }
                            }

                            ToolButton {
                                id: moreToolBtn
                                icon.source: Style.icon("expand")
                                Layout.preferredWidth: Style.resize(40)
                                Layout.preferredHeight: Style.resize(40)
                                onClicked: moreMenu.open()

                                Menu {
                                    id: moreMenu
                                    y: moreToolBtn.height

                                    MenuItem { text: "Help" }
                                    MenuItem { text: "About" }
                                }
                            }
                        }

                        Label {
                            text: "Click each ToolButton to open its dropdown Menu"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                        }
                    }
                }
                }
            }
        }
    }
}
