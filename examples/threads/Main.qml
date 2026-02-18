import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils
import threads

Item {
    id: root

    property bool fullSize: false
    anchors.fill: parent
    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    ThreadPipeline {
        id: pipeline
    }

    // Stop pipeline when leaving page
    onFullSizeChanged: {
        if (!fullSize && pipeline.running)
            pipeline.stop()
    }

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
                spacing: Style.resize(20)

                // Title
                Label {
                    text: "Threads (C++ Pipeline)"
                    font.pixelSize: Style.resize(28)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                Label {
                    text: "Demonstrates QThread + moveToThread worker pattern with cross-thread signal/slot communication. " +
                          "Adapted from a 3-thread pipeline: Generator produces random byte arrays, Filter searches for a byte pattern, " +
                          "Collector stores matches with timestamps."
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                // Row 1: Pipeline Flow + Controls
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(20)

                    PipelineFlowCard {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(380)
                        pipeline: pipeline
                    }

                    PipelineControlCard {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(380)
                        pipeline: pipeline
                    }
                }

                // Row 2: Records + Thread Info
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(20)

                    RecordsCard {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(400)
                        pipeline: pipeline
                    }

                    ThreadInfoCard {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(400)
                        pipeline: pipeline
                    }
                }

                Item { Layout.preferredHeight: Style.resize(20) }
            }
        }
    }
}
