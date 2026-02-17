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
                    text: "Animations Examples"
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

                    EasingCurvesCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    SequentialParallelCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    BehaviorSpringCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                    StatesTransitionsCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(380)
                    }

                } // End of GridLayout

                // ════════════════════════════════════════════════════════
                // Card 5: Custom Complex Animations
                // ════════════════════════════════════════════════════════
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(3800)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(15)

                            Label {
                                text: "Custom Complex Animations"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                                Layout.fillWidth: true
                            }

                            Button {
                                text: "\u25B6 Start All"
                                flat: true
                                onClicked: {
                                    particleSection.sectionActive = true
                                    orbitSection.sectionActive = true
                                    waveSection.sectionActive = true
                                    lissajousSection.sectionActive = true
                                    cradleSection.sectionActive = true
                                    breathSection.sectionActive = true
                                    matrixSection.sectionActive = true
                                }
                            }

                            Button {
                                text: "\u25A0 Stop All"
                                flat: true
                                onClicked: {
                                    particleSection.sectionActive = false
                                    orbitSection.sectionActive = false
                                    waveSection.sectionActive = false
                                    lissajousSection.sectionActive = false
                                    cradleSection.sectionActive = false
                                    breathSection.sectionActive = false
                                    matrixSection.sectionActive = false
                                }
                            }
                        }

                        ParticleFountain { id: particleSection; active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        OrbitalSystem { id: orbitSection; active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        SineWaveBars { id: waveSection; active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        LissajousCurve { id: lissajousSection; active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        NewtonsCradle { id: cradleSection; active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        FlipCards3D { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        StaggeredList { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        BreathingCircles { id: breathSection; active: root.fullSize }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        MatrixRain { id: matrixSection; active: root.fullSize }
                    }
                }
            }
        }
    }
}
