import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

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
                    text: "Canvas & Shapes Examples"
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

                    Canvas2DCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    ShapePathsCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    GradientsPieCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    DrawingPadCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                } // End of GridLayout

                // ========================================
                // Card 5: Custom Canvas Creations
                // ========================================
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
                            text: "Custom Canvas Creations"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Advanced Canvas techniques: real-time rendering, mathematical curves, simulations"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        AnalogClock { active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        SpirographGenerator { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        AudioVisualizer { active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        RadarSweep { active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        FractalTree { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        Kaleidoscope { active: root.fullSize }
                    }
                }
            }
        }
    }
}
