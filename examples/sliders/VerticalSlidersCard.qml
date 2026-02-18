import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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
            text: "Vertical Sliders"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        RowLayout {
            spacing: Style.resize(30)
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Vertical Slider 1
            ColumnLayout {
                spacing: Style.resize(10)

                Slider {
                    id: verticalSlider1
                    from: 0
                    to: 100
                    value: 30
                    orientation: Qt.Vertical
                    Layout.preferredWidth: Style.resize(60)
                    Layout.preferredHeight: Style.resize(150)
                }

                Label {
                    text: verticalSlider1.value.toFixed(0)
                    font.pixelSize: Style.resize(14)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Vertical Slider 2
            ColumnLayout {
                spacing: Style.resize(10)

                Slider {
                    id: verticalSlider2
                    from: 0
                    to: 100
                    value: 60
                    orientation: Qt.Vertical
                    Layout.preferredWidth: Style.resize(60)
                    Layout.preferredHeight: Style.resize(150)
                }

                Label {
                    text: verticalSlider2.value.toFixed(0)
                    font.pixelSize: Style.resize(14)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Vertical Slider 3
            ColumnLayout {
                spacing: Style.resize(10)

                Slider {
                    id: verticalSlider3
                    from: 0
                    to: 100
                    value: 90
                    orientation: Qt.Vertical
                    Layout.preferredWidth: Style.resize(60)
                    Layout.preferredHeight: Style.resize(150)
                }

                Label {
                    text: verticalSlider3.value.toFixed(0)
                    font.pixelSize: Style.resize(14)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            Label {
                text: "Vertical sliders can be created using orientation: Qt.Vertical"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
    }
}
