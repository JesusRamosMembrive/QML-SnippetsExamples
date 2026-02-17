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
        spacing: Style.resize(15)

        Label {
            text: "States & Transitions"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Current: " + morphRect.state
            font.pixelSize: Style.resize(14)
            font.bold: true
            color: Style.fontPrimaryColor
        }

        // Morph area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: Style.bgColor
                radius: Style.resize(8)
            }

            Rectangle {
                id: morphRect
                anchors.centerIn: parent
                width: Style.resize(100)
                height: Style.resize(100)
                radius: 0
                color: "#4A90D9"
                state: "square"

                states: [
                    State {
                        name: "square"
                        PropertyChanges {
                            target: morphRect
                            width: Style.resize(100)
                            height: Style.resize(100)
                            radius: 0
                            color: "#4A90D9"
                        }
                    },
                    State {
                        name: "circle"
                        PropertyChanges {
                            target: morphRect
                            width: Style.resize(100)
                            height: Style.resize(100)
                            radius: Style.resize(50)
                            color: "#00D1A9"
                        }
                    },
                    State {
                        name: "wide"
                        PropertyChanges {
                            target: morphRect
                            width: Style.resize(200)
                            height: Style.resize(80)
                            radius: Style.resize(10)
                            color: "#FEA601"
                        }
                    }
                ]

                transitions: [
                    Transition {
                        NumberAnimation {
                            properties: "width,height,radius"
                            duration: 500
                            easing.type: Easing.OutBounce
                        }
                        ColorAnimation {
                            duration: 500
                        }
                    }
                ]
            }
        }

        // State buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)
            Layout.alignment: Qt.AlignHCenter

            Button {
                text: "Square"
                onClicked: morphRect.state = "square"
                highlighted: morphRect.state === "square"
            }

            Button {
                text: "Circle"
                onClicked: morphRect.state = "circle"
                highlighted: morphRect.state === "circle"
            }

            Button {
                text: "Wide"
                onClicked: morphRect.state = "wide"
                highlighted: morphRect.state === "wide"
            }
        }

        Label {
            text: "States define property sets. Transitions animate between them automatically"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
