import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                // Header
                Label {
                    text: "Graphs Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    VibrationSensorCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        active: root.fullSize
                    }

                    ScrollingWaveformCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        active: root.fullSize
                    }

                    BarSeriesCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    MultiSeriesCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                        active: root.fullSize
                    }
                }

                // ════════════════════════════════════════════════════════
                // Card 5: Custom Graph Creations
                // ════════════════════════════════════════════════════════
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(2800)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(15)

                        Label {
                            text: "Custom Graph Creations"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Canvas-based charts: system monitor, radar, candlestick, donut, scatter, heatmap"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        SystemMonitor { active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        RadarChart { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        CandlestickChart { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        DonutChart { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        ScatterPlot { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        HeatmapChart { }
                    }
                }
            }
        }
    }
}
