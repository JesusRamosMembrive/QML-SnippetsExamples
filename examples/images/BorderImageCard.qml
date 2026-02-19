import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property int borderSize: 20

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "BorderImage (9-patch)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Corners stay fixed, edges stretch"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Show three sizes side by side
            Row {
                anchors.centerIn: parent
                spacing: Style.resize(15)

                Repeater {
                    model: [
                        { w: 60, h: 60, lbl: "Original" },
                        { w: 140, h: 80, lbl: "Wide" },
                        { w: 80, h: 130, lbl: "Tall" }
                    ]

                    ColumnLayout {
                        required property var modelData
                        spacing: Style.resize(4)

                        BorderImage {
                            source: "qrc:/assets/images/ninepatch.png"
                            width: Style.resize(modelData.w)
                            height: Style.resize(modelData.h)
                            border.left: root.borderSize
                            border.right: root.borderSize
                            border.top: root.borderSize
                            border.bottom: root.borderSize
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: modelData.lbl
                            font.pixelSize: Style.resize(11)
                            color: Style.fontSecondaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Border: " + root.borderSize + "px"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }
            Slider {
                Layout.fillWidth: true
                from: 5; to: 28; value: root.borderSize; stepSize: 1
                onValueChanged: root.borderSize = value
            }
        }
    }
}
