import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qmlcppbridge
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    PropertyBridge { id: bridge }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Q_PROPERTY Binding"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Two-way binding between C++ properties and QML"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // Counter
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "counter:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }

            Button {
                text: "-"
                implicitWidth: Style.resize(34)
                implicitHeight: Style.resize(30)
                onClicked: bridge.decrement()
            }

            Label {
                text: bridge.counter.toString()
                font.pixelSize: Style.resize(16)
                font.bold: true
                color: Style.mainColor
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: Style.resize(40)
            }

            Button {
                text: "+"
                implicitWidth: Style.resize(34)
                implicitHeight: Style.resize(30)
                onClicked: bridge.increment()
            }
        }

        // Username
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "userName:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }

            TextField {
                Layout.fillWidth: true
                text: bridge.userName
                font.pixelSize: Style.resize(12)
                onTextChanged: bridge.userName = text
            }
        }

        // Temperature
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "temperature:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }

            Slider {
                Layout.fillWidth: true
                from: -10; to: 45; value: bridge.temperature
                onMoved: bridge.temperature = value
            }

            Label {
                text: bridge.temperature.toFixed(1) + " C"
                font.pixelSize: Style.resize(11)
                color: Style.mainColor
                Layout.preferredWidth: Style.resize(50)
            }
        }

        // Active
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "active:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }

            Switch {
                checked: bridge.active
                onCheckedChanged: bridge.active = checked
            }

            Label {
                text: bridge.active ? "ON" : "OFF"
                font.pixelSize: Style.resize(12)
                color: bridge.active ? "#00D1A9" : "#FF6B6B"
            }
        }

        // Tags
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "tags:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }

            Flow {
                Layout.fillWidth: true
                spacing: Style.resize(4)

                Repeater {
                    model: bridge.tags

                    Rectangle {
                        required property string modelData
                        required property int index
                        width: tagText.implicitWidth + Style.resize(20)
                        height: Style.resize(24)
                        radius: Style.resize(12)
                        color: Style.surfaceColor

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: Style.resize(4)

                            Label {
                                id: tagText
                                text: modelData
                                font.pixelSize: Style.resize(10)
                                color: Style.mainColor
                            }

                            Label {
                                text: "x"
                                font.pixelSize: Style.resize(10)
                                color: "#FF6B6B"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: bridge.removeTag(index)
                                }
                            }
                        }
                    }
                }
            }
        }

        // Add tag
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Item { Layout.preferredWidth: Style.resize(80) }

            TextField {
                id: tagInput
                Layout.fillWidth: true
                placeholderText: "New tag..."
                font.pixelSize: Style.resize(11)
                onAccepted: {
                    bridge.addTag(text)
                    text = ""
                }
            }

            Button {
                text: "Add"
                implicitHeight: Style.resize(30)
                onClicked: {
                    bridge.addTag(tagInput.text)
                    tagInput.text = ""
                }
            }
        }

        // Summary (read-only computed property)
        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(30)
            radius: Style.resize(4)
            color: Style.surfaceColor

            Label {
                anchors.centerIn: parent
                text: "summary: " + bridge.summary
                font.pixelSize: Style.resize(11)
                color: Style.fontPrimaryColor
            }
        }
    }
}
