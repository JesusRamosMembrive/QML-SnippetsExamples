import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    // Basic Popup
    Popup {
        id: basicPopup
        parent: Overlay.overlay
        anchors.centerIn: parent
        width: Style.resize(250)
        height: Style.resize(150)
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        modal: false

        background: Rectangle {
            color: Style.cardColor
            radius: Style.resize(8)
            border.color: Style.mainColor
            border.width: 2
        }

        contentItem: ColumnLayout {
            spacing: Style.resize(10)

            Label {
                text: "Basic Popup"
                font.pixelSize: Style.resize(16)
                font.bold: true
                color: Style.mainColor
            }

            Label {
                text: "Click outside or press Esc to close"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Button {
                text: "Close"
                onClicked: basicPopup.close()
                Layout.alignment: Qt.AlignRight
            }
        }

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150 }
            NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 200; easing.type: Easing.OutBack }
        }

        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100 }
            NumberAnimation { property: "scale"; from: 1.0; to: 0.8; duration: 100 }
        }
    }

    // Modal Popup
    Popup {
        id: modalPopup
        anchors.centerIn: parent
        width: Style.resize(300)
        height: Style.resize(200)
        modal: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        parent: Overlay.overlay

        Overlay.modal: Rectangle {
            color: Qt.rgba(0, 0, 0, 0.4)
        }

        background: Rectangle {
            color: Style.cardColor
            radius: Style.resize(12)
        }

        contentItem: ColumnLayout {
            spacing: Style.resize(15)

            Label {
                text: "Modal Popup"
                font.pixelSize: Style.resize(18)
                font.bold: true
                color: Style.mainColor
            }

            Label {
                text: "The background is dimmed.\nInteraction is blocked until this is closed."
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Item { Layout.fillHeight: true }

            Button {
                text: "Got it"
                onClicked: modalPopup.close()
                Layout.alignment: Qt.AlignRight
            }
        }

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150 }
            NumberAnimation { property: "scale"; from: 0.9; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
        }

        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100 }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Popup"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Button {
            text: "Basic Popup"
            Layout.fillWidth: true
            onClicked: basicPopup.open()
        }

        Button {
            text: "Modal Popup"
            Layout.fillWidth: true
            onClicked: modalPopup.open()
        }

        Item { Layout.fillHeight: true }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: infoColumn.implicitHeight + Style.resize(20)
            color: Style.bgColor
            radius: Style.resize(6)

            ColumnLayout {
                id: infoColumn
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                spacing: Style.resize(6)

                Label {
                    text: "Basic vs Modal:"
                    font.pixelSize: Style.resize(13)
                    font.bold: true
                    color: Style.fontSecondaryColor
                }

                Label {
                    text: "• Basic: no overlay, click outside to close"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.fillWidth: true
                }

                Label {
                    text: "• Modal: dims background, blocks interaction"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.fillWidth: true
                }
            }
        }

        Label {
            text: "Popup shows overlay content with enter/exit transitions"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
