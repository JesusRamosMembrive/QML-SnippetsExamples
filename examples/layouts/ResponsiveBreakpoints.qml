import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Responsive Breakpoints"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(10)

        Label {
            text: "Width: " + bpSlider.value.toFixed(0) + "px"
            font.pixelSize: Style.resize(12)
            color: Style.fontPrimaryColor
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(30)

            Slider {
                id: bpSlider
                anchors.fill: parent
                from: 150; to: 700; value: 500; stepSize: 10
            }
        }

        Label {
            text: bpSlider.value >= 500 ? "Desktop (4 col)"
                : bpSlider.value >= 350 ? "Tablet (2 col)"
                : "Mobile (1 col)"
            font.pixelSize: Style.resize(12)
            font.bold: true
            color: bpSlider.value >= 500 ? "#00D1A9"
                 : bpSlider.value >= 350 ? "#FF9500"
                 : "#FF3B30"
        }
    }

    Item {
        id: bpSection
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(280)

        readonly property int cols: bpSlider.value >= 500 ? 4
                                  : bpSlider.value >= 350 ? 2 : 1

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
            clip: true

            Item {
                anchors.centerIn: parent
                width: bpSlider.value
                height: parent.height - Style.resize(16)

                // Container outline
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.color: Qt.rgba(1, 1, 1, 0.1)
                    border.width: Style.resize(1)
                    radius: Style.resize(4)
                }

                GridLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(8)
                    columns: bpSection.cols
                    rowSpacing: Style.resize(8)
                    columnSpacing: Style.resize(8)

                    Repeater {
                        model: 8

                        delegate: Rectangle {
                            id: bpCard
                            required property int index

                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(55)
                            radius: Style.resize(8)
                            color: Style.surfaceColor

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: Style.resize(2)

                                Rectangle {
                                    Layout.preferredWidth: Style.resize(24)
                                    Layout.preferredHeight: Style.resize(24)
                                    Layout.alignment: Qt.AlignHCenter
                                    radius: Style.resize(4)
                                    color: [
                                        "#5B8DEF", "#00D1A9", "#FF9500", "#FF3B30",
                                        "#AF52DE", "#34C759", "#FEA601", "#E84393"
                                    ][bpCard.index]

                                    Label {
                                        anchors.centerIn: parent
                                        text: (bpCard.index + 1)
                                        font.pixelSize: Style.resize(10)
                                        font.bold: true
                                        color: "#FFF"
                                    }
                                }

                                Label {
                                    text: "Card " + (bpCard.index + 1)
                                    font.pixelSize: Style.resize(9)
                                    color: Style.fontSecondaryColor
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
