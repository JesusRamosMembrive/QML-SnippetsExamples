import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Click-to-Edit Labels"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    GridLayout {
        Layout.fillWidth: true
        columns: 2
        columnSpacing: Style.resize(15)
        rowSpacing: Style.resize(10)

        Repeater {
            model: [
                { label: "Project Name", value: "QML Snippets", color: "#4FC3F7" },
                { label: "Version", value: "1.0.0", color: "#66BB6A" },
                { label: "Author", value: "Developer", color: "#FF8A65" },
                { label: "License", value: "MIT", color: "#CE93D8" }
            ]

            Rectangle {
                id: editableField
                required property var modelData
                required property int index

                property bool editing: false
                property string currentValue: modelData.value

                Layout.fillWidth: true
                height: Style.resize(60)
                radius: Style.resize(8)
                color: editing ? Style.surfaceColor : "transparent"
                border.color: editing ? modelData.color : "transparent"
                border.width: editing ? 2 : 0

                Behavior on color { ColorAnimation { duration: 200 } }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(10)
                    spacing: Style.resize(2)

                    Label {
                        text: editableField.modelData.label
                        font.pixelSize: Style.resize(11)
                        font.bold: true
                        color: editableField.modelData.color
                    }

                    // Display mode
                    Label {
                        visible: !editableField.editing
                        text: editableField.currentValue
                        font.pixelSize: Style.resize(15)
                        color: Style.fontPrimaryColor
                        Layout.fillWidth: true

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                editableField.editing = true
                                inlineEditor.text = editableField.currentValue
                                inlineEditor.forceActiveFocus()
                                inlineEditor.selectAll()
                            }
                        }
                    }

                    // Edit mode
                    TextInput {
                        id: inlineEditor
                        visible: editableField.editing
                        font.pixelSize: Style.resize(15)
                        color: Style.fontPrimaryColor
                        Layout.fillWidth: true
                        selectByMouse: true
                        selectionColor: editableField.modelData.color

                        Keys.onReturnPressed: {
                            editableField.currentValue = text
                            editableField.editing = false
                        }
                        Keys.onEscapePressed: {
                            editableField.editing = false
                        }
                        onActiveFocusChanged: {
                            if (!activeFocus && editableField.editing) {
                                editableField.currentValue = text
                                editableField.editing = false
                            }
                        }
                    }
                }

                // Edit hint icon
                Label {
                    anchors.right: parent.right
                    anchors.rightMargin: Style.resize(10)
                    anchors.verticalCenter: parent.verticalCenter
                    text: editableField.editing ? "\u2705" : "\u270F"
                    font.pixelSize: Style.resize(14)
                    opacity: editableField.editing ? 1.0 : 0.4
                }
            }
        }
    }
}
