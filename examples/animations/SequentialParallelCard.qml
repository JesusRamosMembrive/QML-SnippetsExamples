import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Sequential & Parallel"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Button {
            text: "Play"
            onClicked: {
                // Reset positions
                seqRect.x = 0
                seqRect.scale = 1.0
                seqRect.color = "#4A90D9"
                parRect.x = 0
                parRect.scale = 1.0
                parRect.color = "#4A90D9"
                seqAnim.restart()
                parAnim.restart()
            }
        }

        // Animation area
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(15)

            // Sequential column
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Style.resize(5)

                Label {
                    text: "Sequential"
                    font.pixelSize: Style.resize(13)
                    font.bold: true
                    color: Style.fontPrimaryColor
                    Layout.alignment: Qt.AlignHCenter
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        anchors.fill: parent
                        color: Style.bgColor
                        radius: Style.resize(4)
                    }

                    Rectangle {
                        id: seqRect
                        x: 0
                        anchors.verticalCenter: parent.verticalCenter
                        width: Style.resize(40)
                        height: Style.resize(40)
                        radius: Style.resize(6)
                        color: "#4A90D9"

                        SequentialAnimation {
                            id: seqAnim

                            // Step 1: Move right
                            NumberAnimation {
                                target: seqRect
                                property: "x"
                                to: seqRect.parent.width - seqRect.width
                                duration: 600
                                easing.type: Easing.InOutQuad
                            }

                            // Step 2: Change color
                            ColorAnimation {
                                target: seqRect
                                property: "color"
                                to: Style.mainColor
                                duration: 400
                            }

                            // Step 3: Scale up
                            NumberAnimation {
                                target: seqRect
                                property: "scale"
                                to: 1.5
                                duration: 400
                                easing.type: Easing.OutBack
                            }
                        }
                    }
                }

                Label {
                    text: "Move → Color → Scale"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Parallel column
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Style.resize(5)

                Label {
                    text: "Parallel"
                    font.pixelSize: Style.resize(13)
                    font.bold: true
                    color: Style.fontPrimaryColor
                    Layout.alignment: Qt.AlignHCenter
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        anchors.fill: parent
                        color: Style.bgColor
                        radius: Style.resize(4)
                    }

                    Rectangle {
                        id: parRect
                        x: 0
                        anchors.verticalCenter: parent.verticalCenter
                        width: Style.resize(40)
                        height: Style.resize(40)
                        radius: Style.resize(6)
                        color: "#4A90D9"

                        ParallelAnimation {
                            id: parAnim

                            NumberAnimation {
                                target: parRect
                                property: "x"
                                to: parRect.parent.width - parRect.width
                                duration: 800
                                easing.type: Easing.InOutQuad
                            }

                            ColorAnimation {
                                target: parRect
                                property: "color"
                                to: Style.mainColor
                                duration: 800
                            }

                            NumberAnimation {
                                target: parRect
                                property: "scale"
                                to: 1.5
                                duration: 800
                                easing.type: Easing.OutBack
                            }
                        }
                    }
                }

                Label {
                    text: "Move + Color + Scale"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        Label {
            text: "Sequential runs animations one after another. Parallel runs them simultaneously"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
