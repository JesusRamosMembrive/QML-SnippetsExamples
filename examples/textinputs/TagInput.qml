import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Tag Input"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    Rectangle {
        id: tagContainer
        Layout.fillWidth: true
        implicitHeight: tagFlow.implicitHeight + Style.resize(20)
        radius: Style.resize(8)
        color: Style.surfaceColor
        border.color: tagInput.activeFocus ? Style.mainColor : "#3A3D45"
        border.width: tagInput.activeFocus ? 2 : 1

        Behavior on border.color { ColorAnimation { duration: 200 } }

        property var tags: ["QML", "Qt Quick", "JavaScript"]

        property var tagColors: [
            "#4FC3F7", "#66BB6A", "#FF8A65",
            "#CE93D8", "#FFD54F", "#EF5350",
            "#26A69A", "#AB47BC", "#42A5F5"
        ]

        function addTag(text) {
            var t = text.trim()
            if (t.length > 0 && tags.indexOf(t) === -1) {
                tags = tags.concat([t])
            }
        }

        function removeTag(idx) {
            var copy = tags.slice()
            copy.splice(idx, 1)
            tags = copy
        }

        Flow {
            id: tagFlow
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Style.resize(10)
            spacing: Style.resize(6)

            Repeater {
                model: tagContainer.tags.length

                Rectangle {
                    id: tagChip
                    required property int index

                    property string tagText: tagContainer.tags[index]
                    property string chipColor: tagContainer.tagColors[index % tagContainer.tagColors.length]

                    width: chipRow.implicitWidth + Style.resize(16)
                    height: Style.resize(30)
                    radius: height / 2
                    color: Qt.rgba(Qt.color(chipColor).r,
                                   Qt.color(chipColor).g,
                                   Qt.color(chipColor).b, 0.2)
                    border.color: chipColor
                    border.width: 1

                    RowLayout {
                        id: chipRow
                        anchors.centerIn: parent
                        spacing: Style.resize(4)

                        Label {
                            text: tagChip.tagText
                            font.pixelSize: Style.resize(12)
                            font.bold: true
                            color: tagChip.chipColor
                        }

                        Label {
                            text: "\u2715"
                            font.pixelSize: Style.resize(10)
                            color: tagChip.chipColor
                            opacity: tagRemoveMa.containsMouse ? 1.0 : 0.6

                            MouseArea {
                                id: tagRemoveMa
                                anchors.fill: parent
                                anchors.margins: -4
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: tagContainer.removeTag(tagChip.index)
                            }
                        }
                    }
                }
            }

            // Inline text input
            TextInput {
                id: tagInput
                width: Style.resize(180)
                height: Style.resize(30)
                font.pixelSize: Style.resize(13)
                color: Style.fontPrimaryColor
                clip: true
                verticalAlignment: TextInput.AlignVCenter
                selectByMouse: true
                selectionColor: Style.mainColor

                Text {
                    anchors.fill: parent
                    text: "Type and press Enter to add..."
                    font: parent.font
                    color: Style.inactiveColor
                    visible: !parent.text && !parent.activeFocus
                    verticalAlignment: Text.AlignVCenter
                }

                Keys.onReturnPressed: {
                    tagContainer.addTag(text)
                    text = ""
                }
                Keys.onEnterPressed: {
                    tagContainer.addTag(text)
                    text = ""
                }
            }
        }
    }
}
