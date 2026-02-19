import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qmlcppbridge
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property string lastSignal: ""

    PropertyBridge { id: props }
    MethodBridge { id: methods }
    SignalBridge {
        id: sigs
        onDataReceived: function(data) { root.lastSignal = data }
        onTaskCompleted: function(result) { root.lastSignal = result }
        onErrorOccurred: function(error) { root.lastSignal = error }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Combined Bridge"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Properties + Methods + Signals working together"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // Section: Q_PROPERTY
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: propCol.implicitHeight + Style.resize(16)
            radius: Style.resize(6)
            color: Style.surfaceColor

            ColumnLayout {
                id: propCol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: Style.resize(8)
                spacing: Style.resize(6)

                Label {
                    text: "Q_PROPERTY"
                    font.pixelSize: Style.resize(11)
                    font.bold: true
                    color: "#4FC3F7"
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(8)

                    TextField {
                        id: nameField
                        Layout.fillWidth: true
                        text: props.userName
                        font.pixelSize: Style.resize(11)
                        placeholderText: "userName"
                        onTextChanged: props.userName = text
                    }

                    Button {
                        text: "-"
                        implicitWidth: Style.resize(30)
                        implicitHeight: Style.resize(28)
                        onClicked: props.decrement()
                    }

                    Label {
                        text: props.counter.toString()
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: Style.mainColor
                        Layout.preferredWidth: Style.resize(30)
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Button {
                        text: "+"
                        implicitWidth: Style.resize(30)
                        implicitHeight: Style.resize(28)
                        onClicked: props.increment()
                    }
                }

                Label {
                    text: props.summary
                    font.pixelSize: Style.resize(10)
                    color: Style.fontSecondaryColor
                }
            }
        }

        // Section: Q_INVOKABLE + Q_ENUM
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: methCol.implicitHeight + Style.resize(16)
            radius: Style.resize(6)
            color: Style.surfaceColor

            ColumnLayout {
                id: methCol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: Style.resize(8)
                spacing: Style.resize(6)

                Label {
                    text: "Q_INVOKABLE + Q_ENUM"
                    font.pixelSize: Style.resize(11)
                    font.bold: true
                    color: "#C084FC"
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(6)

                    TextField {
                        id: methodInput
                        Layout.fillWidth: true
                        text: "hello world"
                        font.pixelSize: Style.resize(11)
                    }

                    Repeater {
                        model: ["UC", "lc", "Tc", "Rev"]

                        Button {
                            required property string modelData
                            required property int index
                            text: modelData
                            implicitWidth: Style.resize(36)
                            implicitHeight: Style.resize(28)
                            onClicked: methodResult.text = methods.transformText(
                                           methodInput.text, index)
                        }
                    }
                }

                Label {
                    id: methodResult
                    text: methods.transformText(methodInput.text, 2)
                    font.pixelSize: Style.resize(11)
                    color: Style.mainColor
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                RowLayout {
                    spacing: Style.resize(8)

                    Label {
                        text: "fib(" + fibInput.value.toFixed(0) + ") = " +
                              methods.fibonacci(fibInput.value)
                        font.pixelSize: Style.resize(11)
                        color: Style.fontPrimaryColor
                    }

                    Slider {
                        id: fibInput
                        Layout.fillWidth: true
                        from: 0; to: 20; value: 10; stepSize: 1
                    }
                }
            }
        }

        // Section: Signals
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.resize(6)
            color: Style.surfaceColor

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                spacing: Style.resize(6)

                Label {
                    text: "SIGNALS"
                    font.pixelSize: Style.resize(11)
                    font.bold: true
                    color: "#FF6B6B"
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(6)

                    Button {
                        text: sigs.running ? "Stop" : "Run"
                        implicitHeight: Style.resize(28)
                        onClicked: sigs.running ? sigs.stopTask() : sigs.startTask()
                    }

                    ProgressBar {
                        Layout.fillWidth: true
                        value: sigs.progress
                    }

                    Label {
                        text: (sigs.progress * 100).toFixed(0) + "%"
                        font.pixelSize: Style.resize(10)
                        color: Style.mainColor
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: Style.resize(4)
                    color: "#1A000000"

                    Label {
                        anchors.fill: parent
                        anchors.margins: Style.resize(6)
                        text: root.lastSignal || "Waiting for signals..."
                        font.pixelSize: Style.resize(11)
                        color: root.lastSignal ? "#00D1A9" : "#FFFFFF30"
                        wrapMode: Text.WordWrap
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }
    }
}
