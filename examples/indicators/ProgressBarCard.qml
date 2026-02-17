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
        spacing: Style.resize(15)

        Label {
            text: "ProgressBar"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Determinate ProgressBar
        Label {
            text: "Determinate: " + (progressSlider.value * 100).toFixed(0) + "%"
            font.pixelSize: Style.resize(13)
            color: Style.fontPrimaryColor
        }

        ProgressBar {
            id: determinateBar
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(8)
            from: 0
            to: 1
            value: progressSlider.value
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(40)

            Slider {
                id: progressSlider
                anchors.fill: parent
                anchors.leftMargin: Style.resize(10)
                anchors.rightMargin: Style.resize(10)
                from: 0
                to: 1
                value: 0.65
                stepSize: 0.01
            }
        }

        Rectangle {
            Layout.fillWidth: true
            color: Style.bgColor
        }

        // Indeterminate ProgressBar
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Label {
                text: "Indeterminate:"
                font.pixelSize: Style.resize(13)
                color: Style.fontPrimaryColor
                Layout.fillWidth: true
            }

            Switch {
                id: indeterminateSwitch
                text: indeterminateSwitch.checked ? "ON" : "OFF"
                checked: true
            }
        }

        ProgressBar {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(8)
            indeterminate: indeterminateSwitch.checked
        }

        Item { Layout.fillHeight: true }

        Label {
            text: "ProgressBar shows task completion. Indeterminate mode indicates unknown duration"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
