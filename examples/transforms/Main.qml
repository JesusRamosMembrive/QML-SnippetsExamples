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
                    text: "Transforms & Effects Examples"
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

                    Transforms2DCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    Rotation3DCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    GraphicalEffectsCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    CardFlipCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }
                }

                // ════════════════════════════════════════════════════════
                // Card 5: Custom Transform Creations
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
                            text: "Custom Transform Creations"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Advanced techniques: 3D carousel, parallax depth, spring physics, neon glow, matrix shear, wave grids"
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        Carousel3D { active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        ParallaxDepth { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        ElasticSpring { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        NeonGlow { active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        MatrixShear { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }

                        WaveGrid { active: root.fullSize }
                    }
                }
            }
        }
    }
}
