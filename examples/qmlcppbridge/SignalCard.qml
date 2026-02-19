pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qmlcppbridge
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    SignalBridge {
        id: signals

        onDataReceived: function(data) {
            logModel.insert(0, { msg: data, type: "data" })
        }
        onTaskCompleted: function(result) {
            logModel.insert(0, { msg: result, type: "success" })
        }
        onErrorOccurred: function(error) {
            logModel.insert(0, { msg: error, type: "error" })
        }
        onCustomSignal: function(message) {
            logModel.insert(0, { msg: "Custom: " + message, type: "custom" })
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "C++ Signals"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Signals emitted from C++ handled in QML Connections"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // Progress
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: signals.running ? "Stop" : "Start Task"
                implicitHeight: Style.resize(34)
                onClicked: signals.running ? signals.stopTask() : signals.startTask()
            }

            ProgressBar {
                Layout.fillWidth: true
                value: signals.progress
            }

            Label {
                text: (signals.progress * 100).toFixed(0) + "%"
                font.pixelSize: Style.resize(11)
                color: Style.mainColor
                Layout.preferredWidth: Style.resize(35)
            }
        }

        // Custom signal
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            TextField {
                id: customMsg
                Layout.fillWidth: true
                placeholderText: "Custom signal message..."
                font.pixelSize: Style.resize(11)
            }

            Button {
                text: "Emit"
                implicitHeight: Style.resize(34)
                onClicked: {
                    if (customMsg.text !== "") {
                        signals.emitCustom(customMsg.text)
                        customMsg.text = ""
                    }
                }
            }
        }

        // Event log
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(6)
            clip: true

            ListView {
                id: logList
                anchors.fill: parent
                anchors.margins: Style.resize(6)
                model: ListModel { id: logModel }
                spacing: Style.resize(2)

                delegate: Rectangle {
                    id: logDelegate
                    required property string msg
                    required property string type
                    required property int index
                    width: logList.width
                    height: logText.implicitHeight + Style.resize(8)
                    radius: Style.resize(3)
                    color: {
                        switch (logDelegate.type) {
                        case "data": return "#1A00D1A9"
                        case "success": return "#1A4CAF50"
                        case "error": return "#1AFF6B6B"
                        case "custom": return "#1A4FC3F7"
                        default: return "transparent"
                        }
                    }

                    Label {
                        id: logText
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.margins: Style.resize(6)
                        text: logDelegate.msg
                        font.pixelSize: Style.resize(11)
                        wrapMode: Text.WordWrap
                        color: {
                            switch (logDelegate.type) {
                            case "data": return "#00D1A9"
                            case "success": return "#4CAF50"
                            case "error": return "#FF6B6B"
                            case "custom": return "#4FC3F7"
                            default: return Style.fontPrimaryColor
                            }
                        }
                    }
                }
            }

            // Empty hint
            Label {
                anchors.centerIn: parent
                text: "Press Start Task or Emit to see signals"
                font.pixelSize: Style.resize(12)
                color: "#FFFFFF30"
                visible: logModel.count === 0
            }
        }

        // Clear
        RowLayout {
            Layout.fillWidth: true

            Label {
                text: logModel.count + " events"
                font.pixelSize: Style.resize(10)
                color: Style.fontSecondaryColor
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "Clear Log"
                implicitHeight: Style.resize(30)
                onClicked: logModel.clear()
            }
        }
    }
}
