import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation { duration: 200 }
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
                spacing: Style.resize(30)

                // Header
                Label {
                    text: "Shape Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                GridLayout {
                    columns: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    BezierCurvesCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(340)
                    }

                    ArcsAnglesCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(340)
                    }

                    SvgPathsCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(340)
                    }

                    FillRulesCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(340)
                    }

                    GradientTypesCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(340)
                    }

                    AnimatedShapesCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(340)
                    }
                }

                // ========================================
                // Card 7: Custom Shape Creations
                // ========================================
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(3000)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(15)

                        Label {
                            text: "Custom Shape Creations"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Advanced techniques: gear systems, mathematical curves, scientific visualizations"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        GearTrain { id: gearSection; active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        RoseCurve { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        DnaDoubleHelix { id: dnaSection; active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        Oscilloscope { id: scopeSection; active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        GeometricMandala { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: Style.inactiveColor; opacity: 0.3 }

                        LiquidBlob { id: blobSection; active: root.fullSize }
                    }
                }
            }
        }
    }
}
