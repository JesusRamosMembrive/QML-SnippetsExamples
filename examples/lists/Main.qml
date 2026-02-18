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
                    text: "Lists & Delegates Examples"
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

                    ListViewCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    GridViewCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    DynamicListCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }

                    SectionsCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(420)
                    }
                }

                // ════════════════════════════════════════════════════════
                // Card 5: Custom List Patterns
                // ════════════════════════════════════════════════════════
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(2600)
                    color: Style.cardColor
                    radius: Style.resize(8)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(20)
                        spacing: Style.resize(25)

                        Label {
                            text: "Custom List Patterns"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.mainColor
                        }

                        SwipeToActionList { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        ExpandableAccordion { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        ChatBubbles { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        Timeline { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        CardCarousel { }

                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: Style.resize(1); color: Style.bgColor }

                        KanbanBoard { }
                    }
                }
            }
        }
    }
}
