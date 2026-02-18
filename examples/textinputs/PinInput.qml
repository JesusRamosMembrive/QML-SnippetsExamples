import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "PIN / Verification Code"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    Item {
        id: pinContainer
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(70)

        property string pinValue: ""
        property int pinLength: 6
        property bool completed: pinValue.length === pinLength

        RowLayout {
            anchors.centerIn: parent
            spacing: Style.resize(10)

            Repeater {
                model: pinContainer.pinLength

                Rectangle {
                    id: pinBox
                    required property int index

                    width: Style.resize(48)
                    height: Style.resize(56)
                    radius: Style.resize(10)
                    color: Style.surfaceColor
                    border.color: {
                        if (pinContainer.completed) return Style.mainColor
                        if (index === pinContainer.pinValue.length) return Style.mainColor
                        if (index < pinContainer.pinValue.length) return "#4FC3F7"
                        return "#3A3D45"
                    }
                    border.width: index === pinContainer.pinValue.length ? 2 : 1

                    Behavior on border.color { ColorAnimation { duration: 150 } }

                    scale: index === pinContainer.pinValue.length ? 1.05 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150 } }

                    Label {
                        anchors.centerIn: parent
                        text: index < pinContainer.pinValue.length
                              ? pinContainer.pinValue.charAt(index) : ""
                        font.pixelSize: Style.resize(22)
                        font.bold: true
                        color: pinContainer.completed ? Style.mainColor : "white"

                        Behavior on color { ColorAnimation { duration: 200 } }
                    }

                    // Cursor blink
                    Rectangle {
                        anchors.centerIn: parent
                        width: Style.resize(2)
                        height: Style.resize(24)
                        color: Style.mainColor
                        visible: index === pinContainer.pinValue.length
                                 && pinHiddenInput.activeFocus

                        SequentialAnimation on opacity {
                            running: visible
                            loops: Animation.Infinite
                            NumberAnimation { from: 1; to: 0; duration: 500 }
                            NumberAnimation { from: 0; to: 1; duration: 500 }
                        }
                    }
                }
            }

            // Status
            Label {
                text: pinContainer.completed ? "\u2705" : ""
                font.pixelSize: Style.resize(24)
                Layout.leftMargin: Style.resize(10)
            }
        }

        // Hidden input to capture keyboard
        TextInput {
            id: pinHiddenInput
            width: 1; height: 1
            opacity: 0
            maximumLength: pinContainer.pinLength
            validator: RegularExpressionValidator { regularExpression: /[0-9]*/ }
            inputMethodHints: Qt.ImhDigitsOnly
            onTextChanged: pinContainer.pinValue = text
        }

        MouseArea {
            anchors.fill: parent
            onClicked: pinHiddenInput.forceActiveFocus()
        }

        // Reset link
        Label {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: "Reset"
            font.pixelSize: Style.resize(12)
            color: pinResetMa.containsMouse ? Style.mainColor : Style.fontSecondaryColor

            MouseArea {
                id: pinResetMa
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: { pinHiddenInput.text = ""; pinHiddenInput.forceActiveFocus() }
            }
        }
    }
}
