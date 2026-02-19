import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
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
            text: "Gaussian Blur"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Source scene
            Item {
                id: blurSource
                anchors.fill: parent
                visible: false

                Rectangle {
                    anchors.fill: parent
                    color: Style.surfaceColor
                    radius: Style.resize(8)

                    Grid {
                        anchors.centerIn: parent
                        columns: 3
                        spacing: Style.resize(10)

                        Repeater {
                            model: [
                                { icon: "\u2605", clr: "#00D1A9" },
                                { icon: "\u2665", clr: "#FF7043" },
                                { icon: "\u266B", clr: "#FEA601" },
                                { icon: "\u2600", clr: "#4FC3F7" },
                                { icon: "\u25C6", clr: "#AB47BC" },
                                { icon: "\u2708", clr: "#EC407A" },
                                { icon: "\u2699", clr: "#66BB6A" },
                                { icon: "\u26A1", clr: "#F7DF1E" },
                                { icon: "\u263A", clr: "#00599C" }
                            ]

                            Rectangle {
                                required property var modelData
                                width: Style.resize(55)
                                height: Style.resize(55)
                                radius: Style.resize(8)
                                color: modelData.clr

                                Label {
                                    anchors.centerIn: parent
                                    text: parent.modelData.icon
                                    font.pixelSize: Style.resize(24)
                                    color: "#FFFFFF"
                                }
                            }
                        }
                    }
                }
            }

            GaussianBlur {
                anchors.fill: blurSource
                source: blurSource
                radius: blurSlider.value
                samples: Math.round(blurSlider.value) * 2 + 1
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Radius: " + blurSlider.value.toFixed(1)
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }
            Slider {
                id: blurSlider
                Layout.fillWidth: true
                from: 0; to: 16; value: 0
            }
        }
    }
}
