import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Bar Series"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Button {
            text: "Randomize"
            onClicked: {
                for (let i = 0; i < 6; i++)
                    barSet.replace(i, Math.random() * 80 + 10)
            }
        }

        // Graph area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.fill: parent
                color: "#1a1a2e"
                radius: Style.resize(6)
            }

            GraphsView {
                anchors.fill: parent
                anchors.margins: Style.resize(8)

                theme: GraphsTheme {
                    backgroundVisible: false
                    plotAreaBackgroundColor: "transparent"
                }

                axisX: BarCategoryAxis {
                    categories: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                    lineVisible: false
                    gridVisible: false
                }

                axisY: ValueAxis {
                    min: 0
                    max: 100
                    tickInterval: 25
                    lineVisible: false
                    subGridVisible: false
                }

                BarSeries {
                    BarSet {
                        id: barSet
                        label: "Activity"
                        values: [65, 45, 80, 55, 70, 90]
                        color: Style.mainColor
                        borderColor: Qt.darker(Style.mainColor, 1.2)
                        borderWidth: 1
                    }
                }
            }
        }

        Label {
            text: "BarSeries with BarCategoryAxis. Click Randomize to update values"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
