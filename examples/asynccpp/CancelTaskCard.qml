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
            text: "Task Cancellation"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "QFuture::cancel + QPromise::isCanceled"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: "Start (10 steps)"
                Layout.fillWidth: true
                implicitHeight: Style.resize(38)
                enabled: !task.running
                onClicked: task.runSteps(10)
            }

            Button {
                text: "Cancel"
                Layout.fillWidth: true
                implicitHeight: Style.resize(38)
                enabled: task.running
                onClicked: task.cancel()
            }
        }

        ProgressBar {
            Layout.fillWidth: true
            value: task.progress
        }

        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(40)
            radius: Style.resize(6)
            color: {
                if (task.status === "Completed") return "#1A4CAF50"
                if (task.status === "Cancelled") return "#1AFF6B6B"
                if (task.running) return "#1A00D1A9"
                return Style.surfaceColor
            }

            Label {
                anchors.centerIn: parent
                text: task.status || "Ready"
                font.pixelSize: Style.resize(14)
                font.bold: true
                color: {
                    if (task.status === "Completed") return "#4CAF50"
                    if (task.status === "Cancelled") return "#FF6B6B"
                    if (task.running) return Style.mainColor
                    return Style.fontSecondaryColor
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.resize(6)
            color: Style.surfaceColor

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(12)
                spacing: Style.resize(6)

                Label {
                    text: "How cancellation works:"
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                    color: Style.fontPrimaryColor
                }

                Repeater {
                    model: [
                        "1. QFuture::cancel() sets cancel flag",
                        "2. Worker checks QPromise::isCanceled()",
                        "3. Worker returns early if cancelled",
                        "4. QFutureWatcher emits finished()",
                        "5. Check watcher.isCanceled() for status"
                    ]
                    Label {
                        required property string modelData
                        text: modelData
                        font.pixelSize: Style.resize(11)
                        color: Style.fontSecondaryColor
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
    }
}
