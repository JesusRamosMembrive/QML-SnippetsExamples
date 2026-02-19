import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property color overlayColor: "#00D1A9"
    property real desatAmount: 0.0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Color Effects"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Source scene
            Item {
                id: colorSource
                anchors.fill: parent
                visible: false

                Rectangle {
                    anchors.fill: parent
                    color: Style.surfaceColor
                    radius: Style.resize(8)

                    Row {
                        anchors.centerIn: parent
                        spacing: Style.resize(10)

                        Repeater {
                            model: [
                                { icon: "\u2605", clr: "#FF7043" },
                                { icon: "\u2665", clr: "#4FC3F7" },
                                { icon: "\u266B", clr: "#66BB6A" },
                                { icon: "\u2600", clr: "#FEA601" }
                            ]

                            Rectangle {
                                required property var modelData
                                width: Style.resize(60)
                                height: Style.resize(80)
                                radius: Style.resize(8)
                                color: modelData.clr

                                Label {
                                    anchors.centerIn: parent
                                    text: parent.modelData.icon
                                    font.pixelSize: Style.resize(28)
                                    color: "#FFFFFF"
                                }
                            }
                        }
                    }
                }
            }

            // Apply ColorOverlay + Desaturate
            Desaturate {
                id: desatEffect
                anchors.fill: colorSource
                source: colorSource
                desaturation: root.desatAmount
                visible: false
            }

            ColorOverlay {
                anchors.fill: desatEffect
                source: desatEffect
                color: Qt.rgba(root.overlayColor.r, root.overlayColor.g, root.overlayColor.b, overlaySlider.value)
            }
        }

        // Color picker
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Overlay:"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.preferredWidth: Style.resize(60)
                }
                Repeater {
                    model: ["#00D1A9", "#FF7043", "#AB47BC", "#FEA601", "#4FC3F7", "#FFFFFF"]

                    Rectangle {
                        required property string modelData
                        width: Style.resize(22)
                        height: Style.resize(22)
                        radius: Style.resize(11)
                        color: modelData
                        border.color: root.overlayColor === modelData ? "#FFFFFF" : "transparent"
                        border.width: Style.resize(2)

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.overlayColor = parent.modelData
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Opacity: " + overlaySlider.value.toFixed(2)
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.preferredWidth: Style.resize(90)
                }
                Slider {
                    id: overlaySlider
                    Layout.fillWidth: true
                    from: 0.0; to: 0.8; value: 0.0
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: "Desaturate: " + root.desatAmount.toFixed(2)
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.preferredWidth: Style.resize(90)
                }
                Slider {
                    Layout.fillWidth: true
                    from: 0.0; to: 1.0; value: 0.0
                    onValueChanged: root.desatAmount = value
                }
            }
        }
    }
}
