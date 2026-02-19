import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property int effectIndex: 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Glow & Shadow"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Effect selector
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Repeater {
                model: ["Glow", "DropShadow", "InnerShadow"]

                Button {
                    required property string modelData
                    required property int index
                    text: modelData
                    font.pixelSize: Style.resize(11)
                    highlighted: root.effectIndex === index
                    onClicked: root.effectIndex = index
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Source shape
            Rectangle {
                id: shadowSource
                anchors.centerIn: parent
                width: Style.resize(120)
                height: Style.resize(120)
                radius: Style.resize(16)
                color: "#00D1A9"
                visible: false

                Label {
                    anchors.centerIn: parent
                    text: "\u2605"
                    font.pixelSize: Style.resize(48)
                    color: "#FFFFFF"
                }
            }

            // Glow effect
            Glow {
                anchors.fill: shadowSource
                source: shadowSource
                radius: glowRadius.value
                samples: Math.round(glowRadius.value) * 2 + 1
                color: "#00D1A9"
                spread: 0.3
                visible: root.effectIndex === 0
            }

            // DropShadow effect
            DropShadow {
                anchors.fill: shadowSource
                source: shadowSource
                radius: glowRadius.value
                samples: Math.round(glowRadius.value) * 2 + 1
                color: "#80000000"
                horizontalOffset: Style.resize(6)
                verticalOffset: Style.resize(6)
                visible: root.effectIndex === 1
            }

            // InnerShadow effect
            InnerShadow {
                anchors.fill: shadowSource
                source: shadowSource
                radius: glowRadius.value
                samples: Math.round(glowRadius.value) * 2 + 1
                color: "#80000000"
                horizontalOffset: Style.resize(4)
                verticalOffset: Style.resize(4)
                visible: root.effectIndex === 2
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Radius: " + glowRadius.value.toFixed(0)
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }
            Slider {
                id: glowRadius
                Layout.fillWidth: true
                from: 0; to: 16; value: 10
            }
        }
    }
}
