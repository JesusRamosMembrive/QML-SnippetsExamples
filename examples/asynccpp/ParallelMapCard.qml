pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import asynccpp
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    AsyncTask { id: task }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Item Processing"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Process a list with per-item progress and results"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: "Process Items"
                implicitHeight: Style.resize(34)
                enabled: !task.running
                onClicked: task.processItems([
                    "Apple", "Banana", "Cherry", "Dragon fruit",
                    "Elderberry", "Fig", "Grape", "Honeydew"
                ])
            }

            Button {
                text: "Cancel"
                implicitHeight: Style.resize(34)
                enabled: task.running
                onClicked: task.cancel()
            }

            Item { Layout.fillWidth: true }

            Label {
                text: task.results.length + " / 8"
                font.pixelSize: Style.resize(12)
                color: Style.mainColor
            }
        }

        ProgressBar {
            Layout.fillWidth: true
            value: task.progress
        }

        Label {
            text: task.status || "Press Process to start"
            font.pixelSize: Style.resize(11)
            color: task.running ? Style.mainColor : Style.fontSecondaryColor
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.resize(6)
            color: Style.surfaceColor
            clip: true

            ListView {
                id: resultList
                anchors.fill: parent
                anchors.margins: Style.resize(6)
                model: task.results
                spacing: Style.resize(3)

                delegate: Rectangle {
                    required property string modelData
                    required property int index
                    width: resultList.width
                    height: Style.resize(28)
                    radius: Style.resize(4)
                    color: "#1A00D1A9"

                    Label {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: Style.resize(8)
                        text: modelData
                        font.pixelSize: Style.resize(11)
                        color: Style.mainColor
                    }
                }
            }

            Label {
                anchors.centerIn: parent
                text: "Results will appear here"
                font.pixelSize: Style.resize(12)
                color: "#FFFFFF30"
                visible: task.results.length === 0
            }
        }
    }
}
