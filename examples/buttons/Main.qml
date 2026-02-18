import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils 1.0
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
                    text: "Button Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                GridLayout {
                    columns: 2
                    rows: 3
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    StandardButtonsCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(180)
                    }

                    IconButtonsCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(180)
                    }

                    ButtonStatesCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(240)
                    }

                    CustomStyledCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(240)
                    }

                    SpecializedButtonsCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(200)
                    }

                    ToolButtonMenuCard {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(200)
                    }
                }
            }
        }
    }
}
