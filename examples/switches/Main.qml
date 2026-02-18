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

                Label {
                    text: "Switch, CheckBox & RadioButton Examples"
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

                    BasicSwitchCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                    }

                    CheckBoxCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                    }

                    RadioButtonCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                    }

                    SmartHomeCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(320)
                    }
                }

                // Card 5: Custom Styled Switches
                Rectangle {
                    Layout.fillWidth: true
                    color: Style.cardColor
                    radius: Style.resize(8)
                    implicitHeight: customSwitchesCol.implicitHeight + Style.resize(40)

                    ColumnLayout {
                        id: customSwitchesCol
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        Label {
                            text: "Custom Styled Switches"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        Label {
                            text: "Hand-crafted toggles built from scratch with Rectangle, MouseArea, and animations"
                            font.pixelSize: Style.resize(13)
                            color: Style.fontSecondaryColor
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        IconToggles {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        ColoredTrackSwitches {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        PillToggles {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        DayNightSwitch {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        LargeKnobToggles {}
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.inactiveColor; opacity: 0.3 }
                        SegmentedToggle {}
                    }
                }
            }
        }
    }
}
