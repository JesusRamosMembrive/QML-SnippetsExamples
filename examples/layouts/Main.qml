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
                    text: "Layouts Examples"
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

                    RowColumnLayoutCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    GridLayoutCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    FlowCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    StackLayoutCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }
                }

                // ════════════════════════════════════════════════════════
                // Card 5: Custom Layout Patterns
                // ════════════════════════════════════════════════════════
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(2400)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        Label {
                            text: "Custom Layout Patterns"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        CollapsibleSidebar { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        DraggableSplitPane { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        MasonryGrid { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        HolyGrailLayout { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        ResponsiveBreakpoints { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        NestedDashboard { }
                    }
                }
            }
        }
    }
}
