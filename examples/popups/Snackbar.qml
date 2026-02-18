import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Snackbar with Action"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        id: snackbarSection
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(200)
        clip: true

        property bool snackVisible: false
        property string snackMessage: ""
        property string snackAction: ""
        property int deletedCount: 0

        function showSnack(msg, action) {
            snackMessage = msg
            snackAction = action
            snackVisible = true
            snackTimer.restart()
        }

        Timer {
            id: snackTimer
            interval: 4000
            onTriggered: snackbarSection.snackVisible = false
        }

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
        }

        // Demo content
        ColumnLayout {
            anchors.centerIn: parent
            spacing: Style.resize(12)

            Label {
                text: "Deleted items: " + snackbarSection.deletedCount
                font.pixelSize: Style.resize(14)
                color: Style.fontSecondaryColor
                Layout.alignment: Qt.AlignHCenter
            }

            Row {
                Layout.alignment: Qt.AlignHCenter
                spacing: Style.resize(10)

                Button {
                    text: "Delete Item"
                    onClicked: {
                        snackbarSection.deletedCount++
                        snackbarSection.showSnack(
                            "Item deleted", "UNDO")
                    }
                }

                Button {
                    text: "Archive"
                    flat: true
                    onClicked: {
                        snackbarSection.showSnack(
                            "Conversation archived", "VIEW")
                    }
                }

                Button {
                    text: "Send"
                    flat: true
                    onClicked: {
                        snackbarSection.showSnack(
                            "Message sent to 3 recipients", "")
                    }
                }
            }
        }

        // Snackbar
        Rectangle {
            id: snackbar
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: snackbarSection.snackVisible ? Style.resize(12) : -height
            width: Math.min(parent.width - Style.resize(30), Style.resize(400))
            height: Style.resize(46)
            radius: Style.resize(8)
            color: "#323232"

            Behavior on anchors.bottomMargin {
                NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.resize(16)
                anchors.rightMargin: Style.resize(8)
                spacing: Style.resize(10)

                Label {
                    text: snackbarSection.snackMessage
                    font.pixelSize: Style.resize(13)
                    color: "#E0E0E0"
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                Button {
                    visible: snackbarSection.snackAction !== ""
                    text: snackbarSection.snackAction
                    flat: true
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                    onClicked: {
                        if (snackbarSection.snackAction === "UNDO")
                            snackbarSection.deletedCount = Math.max(0, snackbarSection.deletedCount - 1)
                        snackbarSection.snackVisible = false
                    }
                }
            }
        }
    }
}
