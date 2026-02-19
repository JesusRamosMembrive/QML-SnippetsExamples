import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import asynccpp
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    AsyncTask { id: task }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Progress Reporting"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "QPromise::setProgressValue from background thread"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Steps:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }

            Slider {
                id: stepSlider
                Layout.fillWidth: true
                from: 3; to: 10; value: 6; stepSize: 1
            }

            Label {
                text: stepSlider.value.toFixed(0)
                font.pixelSize: Style.resize(12)
                color: Style.mainColor
                Layout.preferredWidth: Style.resize(25)
            }
        }

        Button {
            text: "Start Task"
            Layout.fillWidth: true
            implicitHeight: Style.resize(38)
            enabled: !task.running
            onClicked: task.runSteps(stepSlider.value)
        }

        ProgressBar {
            Layout.fillWidth: true
            value: task.progress
        }

        Label {
            text: (task.progress * 100).toFixed(0) + "%"
            font.pixelSize: Style.resize(22)
            font.bold: true
            color: Style.mainColor
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.resize(6)
            color: Style.surfaceColor

            Label {
                anchors.centerIn: parent
                width: parent.width - Style.resize(20)
                text: task.status || "Press Start to begin"
                font.pixelSize: Style.resize(14)
                color: {
                    if (task.status === "Completed") return "#4CAF50"
                    if (task.status === "Cancelled") return "#FF6B6B"
                    if (task.running) return Style.mainColor
                    return "#FFFFFF30"
                }
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
