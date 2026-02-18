import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Floating Action Button"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        id: fabSection
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(280)
        clip: true

        property bool fabOpen: false
        property string lastAction: ""

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
        }

        Label {
            anchors.centerIn: parent
            text: fabSection.lastAction || "Tap the + button"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        // Dim overlay
        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.3)
            opacity: fabSection.fabOpen ? 1 : 0
            visible: opacity > 0

            Behavior on opacity { NumberAnimation { duration: 200 } }

            MouseArea {
                anchors.fill: parent
                onClicked: fabSection.fabOpen = false
            }
        }

        // FAB menu items
        Repeater {
            model: [
                { label: "Camera", icon: "📷", clr: "#FF3B30", offset: 180 },
                { label: "Photo", icon: "🖼", clr: "#FF9500", offset: 130 },
                { label: "File", icon: "📁", clr: "#5B8DEF", offset: 80 }
            ]

            delegate: Item {
                id: fabMenuItem
                required property var modelData
                required property int index

                anchors.right: parent.right
                anchors.rightMargin: Style.resize(20)
                anchors.bottom: parent.bottom
                anchors.bottomMargin: fabSection.fabOpen
                    ? Style.resize(fabMenuItem.modelData.offset)
                    : Style.resize(20)
                width: fabMenuRow.implicitWidth
                height: Style.resize(42)
                opacity: fabSection.fabOpen ? 1 : 0
                scale: fabSection.fabOpen ? 1 : 0.5

                Behavior on anchors.bottomMargin {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutBack
                    }
                }
                Behavior on opacity { NumberAnimation { duration: 150 } }
                Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }

                Row {
                    id: fabMenuRow
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Style.resize(10)

                    // Label chip
                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        width: fabMenuLabel.implicitWidth + Style.resize(16)
                        height: Style.resize(28)
                        radius: Style.resize(6)
                        color: Style.cardColor

                        Label {
                            id: fabMenuLabel
                            anchors.centerIn: parent
                            text: fabMenuItem.modelData.label
                            font.pixelSize: Style.resize(12)
                            color: Style.fontPrimaryColor
                        }
                    }

                    // Circle button
                    Rectangle {
                        width: Style.resize(42)
                        height: Style.resize(42)
                        radius: width / 2
                        color: fabMenuItem.modelData.clr

                        Label {
                            anchors.centerIn: parent
                            text: fabMenuItem.modelData.icon
                            font.pixelSize: Style.resize(18)
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                fabSection.lastAction = fabMenuItem.modelData.label + " selected"
                                fabSection.fabOpen = false
                            }
                        }
                    }
                }
            }
        }

        // Main FAB button
        Rectangle {
            id: fabButton
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: Style.resize(20)
            width: Style.resize(52)
            height: Style.resize(52)
            radius: width / 2
            color: Style.mainColor

            rotation: fabSection.fabOpen ? 45 : 0
            Behavior on rotation {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }

            Label {
                anchors.centerIn: parent
                text: "+"
                font.pixelSize: Style.resize(28)
                font.bold: true
                color: "#000"
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: fabSection.fabOpen = !fabSection.fabOpen
            }
        }
    }
}
