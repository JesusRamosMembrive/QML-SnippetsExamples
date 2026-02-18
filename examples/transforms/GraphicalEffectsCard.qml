import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "GraphicalEffects"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // DropShadow
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Shadow: " + shadowSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(80) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: shadowSlider; anchors.fill: parent; from: 0; to: 30; value: 12; stepSize: 1 }
            }
        }

        // Blur
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Blur: " + blurSlider.value.toFixed(0); font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(80) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: blurSlider; anchors.fill: parent; from: 0; to: 20; value: 0; stepSize: 1 }
            }
        }

        // Hue
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Hue: " + hueSlider.value.toFixed(2); font.pixelSize: Style.resize(12); color: Style.fontSecondaryColor; Layout.preferredWidth: Style.resize(80) }
            Item {
                Layout.fillWidth: true; Layout.preferredHeight: Style.resize(28)
                Slider { id: hueSlider; anchors.fill: parent; from: 0; to: 1.0; value: 0; stepSize: 0.01 }
            }
        }

        // Effects preview
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(15)

            // DropShadow
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Style.resize(6)

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        anchors.fill: parent
                        color: Style.bgColor
                        radius: Style.resize(4)
                    }

                    Rectangle {
                        id: shadowSource
                        anchors.centerIn: parent
                        width: Style.resize(60)
                        height: Style.resize(60)
                        radius: Style.resize(8)
                        color: Style.mainColor
                        visible: false

                        Label {
                            anchors.centerIn: parent
                            text: "A"
                            font.pixelSize: Style.resize(24)
                            font.bold: true
                            color: "white"
                        }
                    }

                    DropShadow {
                        anchors.fill: shadowSource
                        source: shadowSource
                        horizontalOffset: Style.resize(3)
                        verticalOffset: Style.resize(3)
                        radius: shadowSlider.value
                        samples: 25
                        color: Qt.rgba(0, 0, 0, 0.4)
                    }
                }

                Label {
                    text: "DropShadow"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // GaussianBlur
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Style.resize(6)

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        anchors.fill: parent
                        color: Style.bgColor
                        radius: Style.resize(4)
                    }

                    Rectangle {
                        id: blurSource
                        anchors.centerIn: parent
                        width: Style.resize(60)
                        height: Style.resize(60)
                        radius: Style.resize(8)
                        color: "#4A90D9"
                        visible: false

                        Label {
                            anchors.centerIn: parent
                            text: "B"
                            font.pixelSize: Style.resize(24)
                            font.bold: true
                            color: "white"
                        }
                    }

                    GaussianBlur {
                        anchors.fill: blurSource
                        source: blurSource
                        radius: blurSlider.value
                        samples: blurSlider.value * 2 + 1
                    }
                }

                Label {
                    text: "GaussianBlur"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Colorize
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Style.resize(6)

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        anchors.fill: parent
                        color: Style.bgColor
                        radius: Style.resize(4)
                    }

                    Rectangle {
                        id: colorizeSource
                        anchors.centerIn: parent
                        width: Style.resize(60)
                        height: Style.resize(60)
                        radius: Style.resize(8)
                        color: "#FEA601"
                        visible: false

                        Label {
                            anchors.centerIn: parent
                            text: "C"
                            font.pixelSize: Style.resize(24)
                            font.bold: true
                            color: "white"
                        }
                    }

                    Colorize {
                        anchors.fill: colorizeSource
                        source: colorizeSource
                        hue: hueSlider.value
                        saturation: 0.8
                        lightness: 0.0
                    }
                }

                Label {
                    text: "Colorize"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        Label {
            text: "Qt5Compat.GraphicalEffects: shadow, blur, and color manipulation"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
