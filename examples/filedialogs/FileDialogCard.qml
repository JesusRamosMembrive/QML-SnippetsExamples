import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property var selectedFiles: []
    property int filterIndex: 0

    readonly property var filters: [
        "All files (*)",
        "Images (*.png *.jpg *.svg)",
        "Documents (*.pdf *.txt *.md)",
        "QML files (*.qml)",
        "C++ files (*.cpp *.h)"
    ]

    FileDialog {
        id: openDialog
        title: "Open File"
        nameFilters: root.filters
        fileMode: multiCheck.checked ? FileDialog.OpenFiles : FileDialog.OpenFile
        onAccepted: {
            root.selectedFiles = selectedFiles
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "FileDialog (Open)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Native file picker with filters"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        // Selected files display
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(8)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(4)

                Label {
                    text: "Selected files:"
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                    color: Style.fontPrimaryColor
                }

                Flickable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    contentHeight: fileCol.height

                    ColumnLayout {
                        id: fileCol
                        width: parent.width
                        spacing: Style.resize(4)

                        Repeater {
                            model: root.selectedFiles

                            Rectangle {
                                required property url modelData
                                required property int index
                                Layout.fillWidth: true
                                height: Style.resize(28)
                                radius: Style.resize(4)
                                color: index % 2 === 0 ? "#2A2D35" : "transparent"

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: Style.resize(4)
                                    spacing: Style.resize(6)

                                    Label {
                                        text: "\u2759"
                                        font.pixelSize: Style.resize(12)
                                        color: Style.mainColor
                                    }
                                    Label {
                                        text: modelData.toString().replace(/^file:\/\/\//, "")
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontSecondaryColor
                                        elide: Text.ElideMiddle
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }

                        // Empty state
                        Label {
                            text: "No files selected"
                            font.pixelSize: Style.resize(13)
                            color: Style.inactiveColor
                            visible: root.selectedFiles.length === 0
                            Layout.alignment: Qt.AlignHCenter
                            Layout.topMargin: Style.resize(30)
                        }
                    }
                }
            }
        }

        // Options
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Switch {
                id: multiCheck
                text: "Multi-select"
                font.pixelSize: Style.resize(11)
            }

            Label {
                text: root.selectedFiles.length + " file(s)"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
            }
        }

        Button {
            text: "Open File Dialog"
            Layout.fillWidth: true
            onClicked: openDialog.open()
        }
    }
}
