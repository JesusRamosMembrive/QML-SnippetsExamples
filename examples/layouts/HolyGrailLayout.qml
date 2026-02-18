import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Holy Grail Layout"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(240)

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(6)
                spacing: Style.resize(4)

                // Header
                Rectangle {
                    Layout.fillWidth: true
                    height: Style.resize(36)
                    radius: Style.resize(4)
                    color: "#5B8DEF"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(12)
                        anchors.rightMargin: Style.resize(12)

                        Label {
                            text: "\u26A1 Header / Navbar"
                            font.pixelSize: Style.resize(12)
                            font.bold: true
                            color: "#FFF"
                        }

                        Item { Layout.fillWidth: true }

                        Repeater {
                            model: ["Home", "About", "Contact"]
                            Label {
                                required property string modelData
                                text: modelData
                                font.pixelSize: Style.resize(10)
                                color: Qt.rgba(1, 1, 1, 0.8)
                            }
                        }
                    }
                }

                // Middle row: sidebar + content + aside
                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: Style.resize(4)

                    // Left sidebar
                    Rectangle {
                        Layout.preferredWidth: Style.resize(100)
                        Layout.fillHeight: true
                        radius: Style.resize(4)
                        color: "#2D3436"

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(8)
                            spacing: Style.resize(4)

                            Label {
                                text: "Nav"
                                font.pixelSize: Style.resize(11)
                                font.bold: true
                                color: "#00D1A9"
                            }

                            Repeater {
                                model: ["Dashboard", "Users", "Reports", "Settings"]
                                Label {
                                    required property string modelData
                                    required property int index
                                    text: "\u2022 " + modelData
                                    font.pixelSize: Style.resize(10)
                                    color: index === 0 ? Style.mainColor : Style.fontSecondaryColor
                                }
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }

                    // Main content
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: Style.resize(4)
                        color: Style.surfaceColor

                        Label {
                            anchors.centerIn: parent
                            text: "Main Content\n(fills remaining space)"
                            font.pixelSize: Style.resize(13)
                            color: Style.fontPrimaryColor
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    // Right aside
                    Rectangle {
                        Layout.preferredWidth: Style.resize(90)
                        Layout.fillHeight: true
                        radius: Style.resize(4)
                        color: "#2D3436"

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Style.resize(8)
                            spacing: Style.resize(4)

                            Label {
                                text: "Aside"
                                font.pixelSize: Style.resize(11)
                                font.bold: true
                                color: "#FF9500"
                            }

                            Label {
                                text: "Related\nlinks and\nwidgets"
                                font.pixelSize: Style.resize(10)
                                color: Style.fontSecondaryColor
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }
                }

                // Footer
                Rectangle {
                    Layout.fillWidth: true
                    height: Style.resize(28)
                    radius: Style.resize(4)
                    color: "#636E72"

                    Label {
                        anchors.centerIn: parent
                        text: "Footer \u2014 \u00A9 2026 QML Snippets"
                        font.pixelSize: Style.resize(10)
                        color: Qt.rgba(1, 1, 1, 0.6)
                    }
                }
            }
        }
    }
}
