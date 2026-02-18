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
        spacing: Style.resize(8)

        property int originMode: 0 // 0=Center, 1=TopLeft, 2=BottomRight

        Label {
            text: "2D Transforms"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Rotation slider
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Rotation: " + rotSlider.value.toFixed(0) + "\u00B0"; font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(100) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: rotSlider; anchors.fill: parent; from: 0; to: 360; value: 0; stepSize: 1 }
            }
        }

        // Scale slider
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Scale: " + scaleSlider.value.toFixed(2); font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(100) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: scaleSlider; anchors.fill: parent; from: 0.3; to: 2.0; value: 1.0; stepSize: 0.05 }
            }
        }

        // Origin buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Label { text: "Origin:"; font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor }

            Button {
                text: "Center"
                highlighted: parent.parent.originMode === 0
                onClicked: parent.parent.originMode = 0
            }
            Button {
                text: "TopLeft"
                highlighted: parent.parent.originMode === 1
                onClicked: parent.parent.originMode = 1
            }
            Button {
                text: "BottomRight"
                highlighted: parent.parent.originMode === 2
                onClicked: parent.parent.originMode = 2
            }
        }

        // Preview area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: Style.bgColor
                radius: Style.resize(6)
            }

            Rectangle {
                id: transformRect
                anchors.centerIn: parent
                width: Style.resize(80)
                height: Style.resize(80)
                radius: Style.resize(8)
                color: Style.mainColor

                property int originMode: transformRect.parent.parent.originMode

                rotation: rotSlider.value
                scale: scaleSlider.value
                transformOrigin: {
                    if (originMode === 1) return Item.TopLeft
                    if (originMode === 2) return Item.BottomRight
                    return Item.Center
                }

                Label {
                    anchors.centerIn: parent
                    text: "QML"
                    font.pixelSize: Style.resize(20)
                    font.bold: true
                    color: "white"
                }

                // Origin dot
                Rectangle {
                    width: Style.resize(8)
                    height: Style.resize(8)
                    radius: width / 2
                    color: "#FF5900"
                    x: {
                        if (transformRect.originMode === 1) return -width/2
                        if (transformRect.originMode === 2) return transformRect.width - width/2
                        return transformRect.width/2 - width/2
                    }
                    y: {
                        if (transformRect.originMode === 1) return -height/2
                        if (transformRect.originMode === 2) return transformRect.height - height/2
                        return transformRect.height/2 - height/2
                    }
                }
            }
        }

        Label {
            text: "rotation, scale, and transformOrigin control 2D transforms"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
