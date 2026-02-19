import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Basic States"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "PropertyChanges on state switch"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        Item {
            id: stateArea
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                id: stateBox
                width: Style.resize(100)
                height: Style.resize(100)
                radius: Style.resize(8)
                color: "#00D1A9"
                anchors.centerIn: parent

                Label {
                    id: stateLabel
                    anchors.centerIn: parent
                    text: "Default"
                    font.pixelSize: Style.resize(14)
                    font.bold: true
                    color: "#FFFFFF"
                }

                states: [
                    State {
                        name: "expanded"
                        PropertyChanges { target: stateBox; width: Style.resize(200); height: Style.resize(60); color: "#FEA601"; radius: Style.resize(30) }
                        PropertyChanges { target: stateLabel; text: "Expanded" }
                    },
                    State {
                        name: "rotated"
                        PropertyChanges { target: stateBox; rotation: 45; color: "#AB47BC"; width: Style.resize(80); height: Style.resize(80) }
                        PropertyChanges { target: stateLabel; text: "Rotated" }
                    },
                    State {
                        name: "small"
                        PropertyChanges { target: stateBox; width: Style.resize(50); height: Style.resize(50); color: "#FF7043"; radius: Style.resize(25) }
                        PropertyChanges { target: stateLabel; text: "Small"; font.pixelSize: Style.resize(10) }
                    }
                ]

                transitions: Transition {
                    NumberAnimation { properties: "width,height,rotation,radius"; duration: 400; easing.type: Easing.InOutQuad }
                    ColorAnimation { duration: 400 }
                }
            }
        }

        // State buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Repeater {
                model: [
                    { label: "Default", st: "" },
                    { label: "Expanded", st: "expanded" },
                    { label: "Rotated", st: "rotated" },
                    { label: "Small", st: "small" }
                ]

                Button {
                    required property var modelData
                    text: modelData.label
                    font.pixelSize: Style.resize(11)
                    highlighted: stateBox.state === modelData.st
                    onClicked: stateBox.state = modelData.st
                    Layout.fillWidth: true
                }
            }
        }

        Label {
            text: "state: \"" + (stateBox.state || "default") + "\""
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
