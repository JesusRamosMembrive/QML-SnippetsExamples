import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property url savedFile: ""
    property string fileName: "untitled"
    property int formatIndex: 0

    readonly property var formats: [
        { ext: ".txt",  filter: "Text files (*.txt)",     icon: "\u2759" },
        { ext: ".json", filter: "JSON files (*.json)",    icon: "\u007B" },
        { ext: ".csv",  filter: "CSV files (*.csv)",      icon: "\u2637" },
        { ext: ".qml",  filter: "QML files (*.qml)",      icon: "\u25C8" }
    ]

    FileDialog {
        id: saveDialog
        title: "Save File As"
        fileMode: FileDialog.SaveFile
        nameFilters: [root.formats[root.formatIndex].filter, "All files (*)"]
        onAccepted: {
            root.savedFile = selectedFile
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "FileDialog (Save)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Save file dialog with format selection"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        // File name input
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Label {
                text: "File name:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }

            TextField {
                Layout.fillWidth: true
                text: root.fileName
                font.pixelSize: Style.resize(13)
                placeholderText: "Enter file name..."
                onTextChanged: root.fileName = text
            }
        }

        // Format selector
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Label {
                text: "Format:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Style.resize(6)

                Repeater {
                    model: root.formats

                    Button {
                        required property var modelData
                        required property int index
                        text: modelData.icon + " " + modelData.ext
                        font.pixelSize: Style.resize(11)
                        highlighted: root.formatIndex === index
                        onClicked: root.formatIndex = index
                        Layout.fillWidth: true
                    }
                }
            }
        }

        // Preview
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(8)

            ColumnLayout {
                anchors.centerIn: parent
                spacing: Style.resize(8)

                Label {
                    text: root.formats[root.formatIndex].icon
                    font.pixelSize: Style.resize(40)
                    color: Style.mainColor
                    Layout.alignment: Qt.AlignHCenter
                }

                Label {
                    text: root.fileName + root.formats[root.formatIndex].ext
                    font.pixelSize: Style.resize(16)
                    font.bold: true
                    color: Style.fontPrimaryColor
                    Layout.alignment: Qt.AlignHCenter
                }

                Label {
                    text: root.savedFile.toString()
                          ? "Saved to: " + root.savedFile.toString().replace(/^file:\/\/\//, "")
                          : "Not saved yet"
                    font.pixelSize: Style.resize(11)
                    color: root.savedFile.toString() ? "#00D1A9" : Style.inactiveColor
                    Layout.alignment: Qt.AlignHCenter
                    Layout.maximumWidth: Style.resize(250)
                    wrapMode: Text.WrapAnywhere
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        Button {
            text: "Save As..."
            Layout.fillWidth: true
            onClicked: saveDialog.open()
        }
    }
}
