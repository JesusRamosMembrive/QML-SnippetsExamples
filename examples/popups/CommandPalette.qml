import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Command Palette"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        id: paletteSection
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(350)
        clip: true

        property bool paletteOpen: false
        property string selectedCmd: ""

        readonly property var commands: [
            { cmd: "Open File", shortcut: "Ctrl+O", icon: "📂", cat: "File" },
            { cmd: "Save", shortcut: "Ctrl+S", icon: "💾", cat: "File" },
            { cmd: "Find & Replace", shortcut: "Ctrl+H", icon: "🔍", cat: "Edit" },
            { cmd: "Toggle Terminal", shortcut: "Ctrl+`", icon: "▸", cat: "View" },
            { cmd: "Go to Definition", shortcut: "F12", icon: "→", cat: "Navigate" },
            { cmd: "Run Build", shortcut: "Ctrl+B", icon: "⚙", cat: "Build" },
            { cmd: "Git Commit", shortcut: "Ctrl+K", icon: "✓", cat: "Git" },
            { cmd: "Toggle Sidebar", shortcut: "Ctrl+B", icon: "◧", cat: "View" },
            { cmd: "Format Document", shortcut: "Alt+F", icon: "✎", cat: "Edit" },
            { cmd: "Debug Start", shortcut: "F5", icon: "▶", cat: "Debug" }
        ]

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
        }

        // Background content
        ColumnLayout {
            anchors.centerIn: parent
            spacing: Style.resize(12)

            Label {
                text: paletteSection.selectedCmd || "No command selected"
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
                Layout.alignment: Qt.AlignHCenter
            }

            Button {
                text: "Open Command Palette"
                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    paletteSection.paletteOpen = true
                    paletteSearchField.text = ""
                    paletteSearchField.forceActiveFocus()
                }
            }
        }

        // Palette overlay
        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.5)
            opacity: paletteSection.paletteOpen ? 1 : 0
            visible: opacity > 0

            Behavior on opacity { NumberAnimation { duration: 150 } }

            MouseArea {
                anchors.fill: parent
                onClicked: paletteSection.paletteOpen = false
            }
        }

        // Palette panel
        Rectangle {
            id: palettePanel
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: paletteSection.paletteOpen ? Style.resize(20) : -height
            width: parent.width * 0.8
            height: Style.resize(290)
            radius: Style.resize(12)
            color: Style.cardColor
            border.color: Style.mainColor
            border.width: Style.resize(1)

            Behavior on anchors.topMargin {
                NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(12)
                spacing: Style.resize(8)

                // Search field
                Rectangle {
                    Layout.fillWidth: true
                    height: Style.resize(36)
                    radius: Style.resize(8)
                    color: Style.bgColor

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(8)
                        spacing: Style.resize(8)

                        Label {
                            text: ">"
                            font.pixelSize: Style.resize(14)
                            font.bold: true
                            color: Style.mainColor
                        }

                        TextInput {
                            id: paletteSearchField
                            Layout.fillWidth: true
                            font.pixelSize: Style.resize(13)
                            font.family: Style.fontFamilyRegular
                            color: Style.fontPrimaryColor
                            clip: true
                            selectByMouse: true

                            Text {
                                anchors.fill: parent
                                text: "Type a command..."
                                font: parent.font
                                color: Style.inactiveColor
                                visible: !parent.text && !parent.activeFocus
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }

                // Results list
                ListView {
                    id: paletteResults
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: Style.resize(2)
                    currentIndex: 0

                    model: {
                        var filter = paletteSearchField.text.toLowerCase()
                        var results = []
                        for (var i = 0; i < paletteSection.commands.length; i++) {
                            var c = paletteSection.commands[i]
                            if (!filter || c.cmd.toLowerCase().indexOf(filter) >= 0
                                || c.cat.toLowerCase().indexOf(filter) >= 0) {
                                results.push(c)
                            }
                        }
                        return results
                    }

                    delegate: Rectangle {
                        id: cmdItem
                        required property var modelData
                        required property int index

                        width: paletteResults.width
                        height: Style.resize(34)
                        radius: Style.resize(6)
                        color: paletteResults.currentIndex === cmdItem.index
                               ? Qt.rgba(0, 0.82, 0.66, 0.1)
                               : cmdHoverMa.containsMouse
                                 ? Qt.rgba(1, 1, 1, 0.04)
                                 : "transparent"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: Style.resize(10)
                            anchors.rightMargin: Style.resize(10)
                            spacing: Style.resize(8)

                            Label {
                                text: cmdItem.modelData.icon
                                font.pixelSize: Style.resize(14)
                            }

                            Label {
                                text: cmdItem.modelData.cmd
                                font.pixelSize: Style.resize(13)
                                color: Style.fontPrimaryColor
                                Layout.fillWidth: true
                            }

                            Rectangle {
                                width: catLabel.implicitWidth + Style.resize(10)
                                height: Style.resize(18)
                                radius: Style.resize(3)
                                color: Qt.rgba(1, 1, 1, 0.06)

                                Label {
                                    id: catLabel
                                    anchors.centerIn: parent
                                    text: cmdItem.modelData.cat
                                    font.pixelSize: Style.resize(9)
                                    color: Style.inactiveColor
                                }
                            }

                            Label {
                                text: cmdItem.modelData.shortcut
                                font.pixelSize: Style.resize(10)
                                font.family: "monospace"
                                color: Style.inactiveColor
                            }
                        }

                        MouseArea {
                            id: cmdHoverMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                paletteSection.selectedCmd = "Executed: " + cmdItem.modelData.cmd
                                paletteSection.paletteOpen = false
                            }
                            onEntered: paletteResults.currentIndex = cmdItem.index
                        }
                    }
                }

                // Footer
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(10)

                    Label {
                        text: paletteResults.count + " commands"
                        font.pixelSize: Style.resize(10)
                        color: Style.inactiveColor
                        Layout.fillWidth: true
                    }

                    Label {
                        text: "↑↓ Navigate   ↵ Select   Esc Close"
                        font.pixelSize: Style.resize(10)
                        color: Style.inactiveColor
                    }
                }
            }
        }
    }
}
