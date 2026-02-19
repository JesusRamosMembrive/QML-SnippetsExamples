import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property string selectedEmoji: ""
    property int categoryIndex: 0

    readonly property var categories: [
        { name: "Faces",   emojis: ["\u263A", "\u2639", "\u2764", "\u2605", "\u263B", "\u2666", "\u2663", "\u2660", "\u2665", "\u266A", "\u266B", "\u2602"] },
        { name: "Symbols", emojis: ["\u2713", "\u2715", "\u2726", "\u2728", "\u2699", "\u26A1", "\u2600", "\u2601", "\u2614", "\u2708", "\u2693", "\u2692"] },
        { name: "Arrows",  emojis: ["\u2190", "\u2191", "\u2192", "\u2193", "\u2194", "\u2195", "\u21BB", "\u21BA", "\u2196", "\u2197", "\u2198", "\u2199"] },
        { name: "Shapes",  emojis: ["\u25A0", "\u25A1", "\u25B2", "\u25B3", "\u25C6", "\u25C7", "\u25CB", "\u25CF", "\u25D0", "\u25D1", "\u2B22", "\u2B23"] }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(12)

        Label {
            text: "Emoji Picker"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Selected emoji display
        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(50)
            radius: Style.resize(8)
            color: Style.surfaceColor

            RowLayout {
                anchors.centerIn: parent
                spacing: Style.resize(10)

                Label {
                    text: root.selectedEmoji || "?"
                    font.pixelSize: Style.resize(30)
                    color: root.selectedEmoji ? Style.fontPrimaryColor : Style.inactiveColor
                }
                Label {
                    text: root.selectedEmoji ? "Selected!" : "Pick an emoji below"
                    font.pixelSize: Style.resize(14)
                    color: root.selectedEmoji ? Style.mainColor : Style.inactiveColor
                }
            }
        }

        // Category tabs
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(4)

            Repeater {
                model: root.categories

                Button {
                    required property var modelData
                    required property int index
                    text: modelData.name
                    font.pixelSize: Style.resize(10)
                    highlighted: root.categoryIndex === index
                    Layout.fillWidth: true
                    onClicked: root.categoryIndex = index
                }
            }
        }

        // Emoji grid
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(8)

            GridView {
                id: emojiGrid
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                clip: true
                cellWidth: width / 4
                cellHeight: cellWidth

                model: root.categories[root.categoryIndex].emojis

                delegate: Item {
                    required property string modelData
                    required property int index
                    width: emojiGrid.cellWidth
                    height: emojiGrid.cellHeight

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Style.resize(3)
                        radius: Style.resize(8)
                        color: root.selectedEmoji === parent.modelData ? "#1A3A35" : "transparent"
                        border.color: root.selectedEmoji === parent.modelData ? "#00D1A9" : "transparent"
                        border.width: Style.resize(1)

                        Label {
                            anchors.centerIn: parent
                            text: modelData
                            font.pixelSize: Style.resize(24)
                            color: Style.fontPrimaryColor
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.selectedEmoji = modelData
                        }
                    }
                }
            }
        }
    }
}
