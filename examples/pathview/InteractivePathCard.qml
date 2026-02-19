import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property int itemCount: 6
    property real pathHeight: 0.4

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Configurable Path"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            PathView {
                id: configView
                anchors.fill: parent
                model: root.itemCount
                preferredHighlightBegin: 0.5
                preferredHighlightEnd: 0.5
                highlightRangeMode: PathView.StrictlyEnforceRange

                delegate: Rectangle {
                    required property int index
                    width: Style.resize(50)
                    height: Style.resize(50)
                    radius: Style.resize(25)
                    color: Qt.hsla(index / root.itemCount, 0.7, 0.5, 1.0)
                    scale: PathView.isCurrentItem ? 1.3 : 0.8
                    opacity: PathView.isCurrentItem ? 1.0 : 0.6

                    Behavior on scale { NumberAnimation { duration: 200 } }
                    Behavior on opacity { NumberAnimation { duration: 200 } }

                    Label {
                        anchors.centerIn: parent
                        text: (index + 1).toString()
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: "#FFFFFF"
                    }
                }

                path: Path {
                    startX: Style.resize(20)
                    startY: configView.height / 2
                    PathQuad {
                        x: configView.width - Style.resize(20)
                        y: configView.height / 2
                        controlX: configView.width / 2
                        controlY: configView.height * (1.0 - root.pathHeight)
                    }
                }

                pathItemCount: Math.min(root.itemCount, 7)
            }
        }

        // Controls
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            RowLayout {
                Layout.fillWidth: true
                Label { text: "Items: " + root.itemCount; font.pixelSize: Style.resize(13); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(70) }
                Slider {
                    Layout.fillWidth: true
                    from: 3; to: 12; value: root.itemCount; stepSize: 1
                    onValueChanged: root.itemCount = value
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Label { text: "Curve: " + (root.pathHeight * 100).toFixed(0) + "%"; font.pixelSize: Style.resize(13); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(70) }
                Slider {
                    Layout.fillWidth: true
                    from: 0.0; to: 1.0; value: root.pathHeight
                    onValueChanged: root.pathHeight = value
                }
            }
        }
    }
}
