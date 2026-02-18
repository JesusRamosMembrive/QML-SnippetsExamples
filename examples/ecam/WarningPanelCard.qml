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
            text: "Warning Panel"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Master buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            // Master WARNING
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(50)
                color: warningModel.count > 0 ? "#F44336" : "#5a1a1a"
                radius: Style.resize(4)
                border.color: "#F44336"
                border.width: 2

                SequentialAnimation on opacity {
                    running: warningModel.count > 0
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.5; duration: 400 }
                    NumberAnimation { to: 1.0; duration: 400 }
                }

                Label {
                    anchors.centerIn: parent
                    text: "MASTER\nWARNING"
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: warningModel.clear()
                }
            }

            // Master CAUTION
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(50)
                color: cautionModel.count > 0 ? "#FF9800" : "#4a3a0a"
                radius: Style.resize(4)
                border.color: "#FF9800"
                border.width: 2

                SequentialAnimation on opacity {
                    running: cautionModel.count > 0
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.6; duration: 500 }
                    NumberAnimation { to: 1.0; duration: 500 }
                }

                Label {
                    anchors.centerIn: parent
                    text: "MASTER\nCAUTION"
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: cautionModel.clear()
                }
            }
        }

        ListModel { id: warningModel }
        ListModel { id: cautionModel }

        // Message list
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#1a1a1a"
            radius: Style.resize(4)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                spacing: Style.resize(2)

                // Warnings section
                Repeater {
                    model: warningModel
                    Label {
                        required property var model
                        text: "\u26A0 " + model.msg
                        font.pixelSize: Style.resize(13)
                        font.bold: true
                        color: "#F44336"
                        Layout.fillWidth: true
                    }
                }

                // Cautions section
                Repeater {
                    model: cautionModel
                    Label {
                        required property var model
                        text: "\u25B3 " + model.msg
                        font.pixelSize: Style.resize(13)
                        color: "#FF9800"
                        Layout.fillWidth: true
                    }
                }

                // Status messages
                Label {
                    text: "\u2022 SLATS RETRACTED"
                    font.pixelSize: Style.resize(12)
                    color: "#4CAF50"
                    Layout.fillWidth: true
                }
                Label {
                    text: "\u2022 AUTO BRK: MED"
                    font.pixelSize: Style.resize(12)
                    color: "#4CAF50"
                    Layout.fillWidth: true
                }

                Item { Layout.fillHeight: true }
            }
        }

        // Add warning/caution buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: "+ Warning"
                onClicked: {
                    var warnings = ["ENG 1 FIRE", "ENG 2 FAIL", "CABIN PRESS", "HYD G SYS LO PR", "ELEC GEN 1 FAULT"];
                    warningModel.append({ msg: warnings[warningModel.count % warnings.length] });
                }
            }
            Button {
                text: "+ Caution"
                onClicked: {
                    var cautions = ["FUEL L TK LO LVL", "BLEED 1 FAULT", "AIR PACK 1 OFF", "APU FAULT", "F/CTL ALTN LAW"];
                    cautionModel.append({ msg: cautions[cautionModel.count % cautions.length] });
                }
            }
            Item { Layout.fillWidth: true }
            Button {
                text: "Clear All"
                onClicked: {
                    warningModel.clear();
                    cautionModel.clear();
                }
            }
        }

        Label {
            text: "Master WARNING (red) / CAUTION (amber) with blinking. Click master buttons or Clear to dismiss."
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
