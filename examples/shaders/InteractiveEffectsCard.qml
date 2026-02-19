import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property bool enableBlur: false
    property bool enableGlow: false
    property bool enableShadow: false

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(12)

        Label {
            text: "Effect Combiner"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Base source
            Item {
                id: comboSource
                anchors.centerIn: parent
                width: Style.resize(140)
                height: Style.resize(140)
                visible: false

                Rectangle {
                    anchors.fill: parent
                    radius: Style.resize(20)
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#00D1A9" }
                        GradientStop { position: 1.0; color: "#4FC3F7" }
                    }

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(4)

                        Label {
                            text: "\u2726"
                            font.pixelSize: Style.resize(40)
                            color: "#FFFFFF"
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Label {
                            text: "Effects"
                            font.pixelSize: Style.resize(14)
                            font.bold: true
                            color: "#FFFFFF"
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }

            // DropShadow layer (bottom)
            DropShadow {
                id: shadowLayer
                anchors.fill: comboSource
                source: comboSource
                radius: root.enableShadow ? 16 : 0
                samples: 33
                color: "#80000000"
                horizontalOffset: Style.resize(8)
                verticalOffset: Style.resize(8)
                visible: false

                Behavior on radius { NumberAnimation { duration: 300 } }
            }

            // Blur layer
            GaussianBlur {
                id: blurLayer
                anchors.fill: shadowLayer
                source: shadowLayer
                radius: root.enableBlur ? blurAmount.value : 0
                samples: Math.round(radius) * 2 + 1
                visible: false

                Behavior on radius { NumberAnimation { duration: 300 } }
            }

            // Glow layer (top)
            Glow {
                anchors.fill: blurLayer
                source: blurLayer
                radius: root.enableGlow ? 12 : 0
                samples: 25
                color: "#00D1A9"
                spread: 0.2

                Behavior on radius { NumberAnimation { duration: 300 } }
            }
        }

        // Toggle controls
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            RowLayout {
                Layout.fillWidth: true
                spacing: Style.resize(15)

                Switch {
                    id: blurSwitch
                    text: "Blur"
                    font.pixelSize: Style.resize(12)
                    checked: root.enableBlur
                    onToggled: root.enableBlur = checked
                }
                Switch {
                    text: "Glow"
                    font.pixelSize: Style.resize(12)
                    checked: root.enableGlow
                    onToggled: root.enableGlow = checked
                }
                Switch {
                    text: "Shadow"
                    font.pixelSize: Style.resize(12)
                    checked: root.enableShadow
                    onToggled: root.enableShadow = checked
                }
            }

            RowLayout {
                Layout.fillWidth: true
                visible: root.enableBlur
                Label {
                    text: "Blur: " + blurAmount.value.toFixed(0)
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.preferredWidth: Style.resize(60)
                }
                Slider {
                    id: blurAmount
                    Layout.fillWidth: true
                    from: 0; to: 16; value: 8
                }
            }
        }

        // Active effects label
        Label {
            property var active: {
                var list = []
                if (root.enableBlur) list.push("Blur")
                if (root.enableGlow) list.push("Glow")
                if (root.enableShadow) list.push("Shadow")
                return list
            }
            text: active.length > 0 ? active.join(" + ") : "No effects active"
            font.pixelSize: Style.resize(12)
            color: active.length > 0 ? Style.mainColor : Style.inactiveColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
