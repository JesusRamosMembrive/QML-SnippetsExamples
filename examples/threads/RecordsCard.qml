import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    required property var pipeline

    ListModel {
        id: recordsModel
    }

    Connections {
        target: root.pipeline
        function onRecordAdded(timestamp, hexData, size) {
            recordsModel.insert(0, {
                "timestamp": timestamp,
                "hexData": hexData,
                "byteSize": size
            })
            if (recordsModel.count > 500)
                recordsModel.remove(500, recordsModel.count - 500)
        }
        function onRunningChanged() {
            if (!root.pipeline.running) {
                // stopped — keep records visible
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(8)

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Matched Records"
                font.pixelSize: Style.resize(20)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
            }
            Rectangle {
                Layout.preferredWidth: countLabel.implicitWidth + Style.resize(16)
                Layout.preferredHeight: Style.resize(22)
                radius: Style.resize(11)
                color: "#00D1A9"
                visible: recordsModel.count > 0
                Label {
                    id: countLabel
                    anchors.centerIn: parent
                    text: recordsModel.count
                    font.pixelSize: Style.resize(11)
                    font.bold: true
                    color: "#1a1a2e"
                }
            }
            Button {
                text: "Clear"
                onClicked: {
                    root.pipeline.clear()
                    recordsModel.clear()
                }
            }
        }

        // Records list
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            // Empty state
            Label {
                anchors.centerIn: parent
                text: "No matches yet.\nStart the pipeline to see filtered data."
                font.pixelSize: Style.resize(13)
                color: Style.inactiveColor
                horizontalAlignment: Text.AlignHCenter
                visible: recordsModel.count === 0
            }

            ListView {
                id: recordsListView
                anchors.fill: parent
                model: recordsModel
                visible: recordsModel.count > 0
                clip: true
                spacing: 1

                delegate: Rectangle {
                    id: recordDelegate
                    width: recordsListView.width
                    height: Style.resize(48)
                    color: index % 2 === 0 ? Style.surfaceColor : "transparent"
                    radius: Style.resize(4)

                    required property int index
                    required property string timestamp
                    required property string hexData
                    required property int byteSize

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(10)
                        anchors.rightMargin: Style.resize(10)
                        anchors.topMargin: Style.resize(4)
                        anchors.bottomMargin: Style.resize(4)
                        spacing: Style.resize(2)

                        RowLayout {
                            Layout.fillWidth: true
                            Label {
                                text: recordDelegate.timestamp
                                font.pixelSize: Style.resize(10)
                                color: Style.fontSecondaryColor
                                Layout.fillWidth: true
                            }
                            Label {
                                text: recordDelegate.byteSize + " bytes"
                                font.pixelSize: Style.resize(10)
                                font.bold: true
                                color: "#FEA601"
                            }
                        }
                        Label {
                            text: recordDelegate.hexData
                            font.pixelSize: Style.resize(10)
                            font.family: "Consolas, monospace"
                            color: Style.fontPrimaryColor
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }

        Label {
            text: "CollectorWorker stores records with QMutex protection. Data arrives via QueuedConnection."
            font.pixelSize: Style.resize(11)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
