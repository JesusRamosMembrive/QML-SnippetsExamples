import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Step Progress"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        id: stepProgressItem
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(130)

        property int currentStep: 2
        property var stepLabels: ["Order", "Payment", "Processing", "Shipping", "Delivered"]

        Row {
            anchors.centerIn: parent
            spacing: 0

            Repeater {
                model: 5
                delegate: Row {
                    id: stepDelegate
                    required property int index

                    readonly property bool completed:
                        stepDelegate.index < stepProgressItem.currentStep
                    readonly property bool active:
                        stepDelegate.index === stepProgressItem.currentStep

                    // Step circle
                    Column {
                        spacing: Style.resize(6)

                        Rectangle {
                            id: stepCircle
                            width: Style.resize(36)
                            height: Style.resize(36)
                            radius: width / 2
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: stepDelegate.completed ? Style.mainColor
                                 : stepDelegate.active ? Style.mainColor
                                 : Qt.rgba(1, 1, 1, 0.1)
                            border.color: stepDelegate.active ? Style.mainColor : "transparent"
                            border.width: stepDelegate.active ? Style.resize(2) : 0

                            Behavior on color {
                                ColorAnimation { duration: 300 }
                            }

                            Label {
                                anchors.centerIn: parent
                                text: stepDelegate.completed ? "\u2713" : (stepDelegate.index + 1)
                                font.pixelSize: Style.resize(14)
                                font.bold: true
                                color: stepDelegate.completed || stepDelegate.active
                                       ? "#000" : Style.fontSecondaryColor
                            }

                            // Pulse animation for active step
                            Rectangle {
                                anchors.fill: parent
                                radius: parent.radius
                                color: "transparent"
                                border.color: Style.mainColor
                                border.width: Style.resize(2)
                                visible: stepDelegate.active

                                SequentialAnimation on scale {
                                    loops: Animation.Infinite
                                    running: stepDelegate.active
                                    NumberAnimation { from: 1.0; to: 1.4; duration: 800 }
                                    NumberAnimation { from: 1.4; to: 1.0; duration: 800 }
                                }
                                SequentialAnimation on opacity {
                                    loops: Animation.Infinite
                                    running: stepDelegate.active
                                    NumberAnimation { from: 0.6; to: 0.0; duration: 800 }
                                    NumberAnimation { from: 0.0; to: 0.6; duration: 800 }
                                }
                            }
                        }

                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: stepProgressItem.stepLabels[stepDelegate.index]
                            font.pixelSize: Style.resize(10)
                            color: stepDelegate.completed || stepDelegate.active
                                   ? Style.fontPrimaryColor : Style.fontSecondaryColor
                            font.bold: stepDelegate.active
                        }
                    }

                    // Connector line (not after last step)
                    Rectangle {
                        visible: stepDelegate.index < 4
                        y: Style.resize(18) - height / 2
                        width: Style.resize(50)
                        height: Style.resize(3)
                        radius: Style.resize(1)
                        color: stepDelegate.completed ? Style.mainColor
                             : Qt.rgba(1, 1, 1, 0.1)

                        Behavior on color {
                            ColorAnimation { duration: 300 }
                        }
                    }
                }
            }
        }

        // Navigation buttons
        RowLayout {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Style.resize(15)

            Button {
                text: "\u2190 Back"
                flat: true
                enabled: stepProgressItem.currentStep > 0
                onClicked: stepProgressItem.currentStep--
            }

            Button {
                text: "Next \u2192"
                flat: true
                enabled: stepProgressItem.currentStep < 4
                onClicked: stepProgressItem.currentStep++
            }

            Button {
                text: "Reset"
                flat: true
                onClicked: stepProgressItem.currentStep = 0
            }
        }
    }
}
