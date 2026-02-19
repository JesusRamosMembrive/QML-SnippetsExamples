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
        spacing: Style.resize(20)

        Label {
            text: "Basic RangeSliders"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Horizontal RangeSlider
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            Label {
                text: "Horizontal: " + basicRange.first.value.toFixed(0) + " — " + basicRange.second.value.toFixed(0)
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                RangeSlider {
                    id: basicRange
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 100
                    first.value: 20
                    second.value: 80
                }
            }
        }

        // Stepped RangeSlider
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            Label {
                text: "Stepped (step: 10): " + steppedRange.first.value.toFixed(0) + " — " + steppedRange.second.value.toFixed(0)
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                RangeSlider {
                    id: steppedRange
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 100
                    stepSize: 10
                    first.value: 30
                    second.value: 70
                    snapMode: RangeSlider.SnapAlways
                }
            }
        }

        // Disabled RangeSlider
        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: root.width - 10
            spacing: Style.resize(8)

            Label {
                text: "Disabled RangeSlider"
                font.pixelSize: Style.resize(14)
                color: "#999"
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)

                RangeSlider {
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(10)
                    anchors.rightMargin: Style.resize(10)
                    from: 0
                    to: 100
                    first.value: 25
                    second.value: 75
                    enabled: false
                }
            }
        }
    }
}
