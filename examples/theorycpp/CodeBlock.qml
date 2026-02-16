import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils 1.0

Rectangle {
    id: root

    property string title: ""
    property string code: ""
    property string result: ""
    property bool expanded: false

    radius: Style.resize(8)
    color: "#1E1E2E"
    implicitHeight: blockColumn.implicitHeight

    ColumnLayout {
        id: blockColumn
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 0

        // Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(40)
            color: "#2D2D3D"
            radius: root.expanded ? 0 : Style.resize(8)

            // Top corners always rounded
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: Style.resize(8)
                color: parent.color
                radius: Style.resize(8)
            }

            // Bottom corners flat when expanded
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: Style.resize(8)
                color: parent.color
                radius: root.expanded ? 0 : Style.resize(8)
                visible: !root.expanded
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Style.resize(12)
                anchors.rightMargin: Style.resize(12)

                Label {
                    text: root.expanded ? "\u25BC" : "\u25B6"
                    font.pixelSize: Style.resize(10)
                    color: Style.mainColor
                }

                Label {
                    text: root.title
                    font.pixelSize: Style.resize(13)
                    font.bold: true
                    color: "#E0E0E0"
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.expanded = !root.expanded
            }
        }

        // Code content
        Rectangle {
            Layout.fillWidth: true
            color: "#1E1E2E"
            visible: root.expanded
            implicitHeight: codeEdit.implicitHeight + Style.resize(24)

            TextEdit {
                id: codeEdit
                anchors.fill: parent
                anchors.margins: Style.resize(12)
                text: root.code
                textFormat: TextEdit.MarkdownText
                readOnly: true
                wrapMode: TextEdit.WordWrap
                font.family: "Consolas"
                font.pixelSize: Style.resize(12)
                color: "#D4D4D4"
                selectByMouse: true
                selectedTextColor: "white"
                selectionColor: Style.mainColor
            }
        }

        // Result section
        Rectangle {
            Layout.fillWidth: true
            color: "#252535"
            visible: root.expanded && root.result !== ""
            implicitHeight: resultColumn.implicitHeight + Style.resize(16)
            radius: Style.resize(8)

            // Only bottom corners rounded
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: Style.resize(8)
                color: parent.color
            }

            ColumnLayout {
                id: resultColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: Style.resize(12)
                spacing: Style.resize(4)

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#3D3D4D"
                }

                Label {
                    text: "Resultado:"
                    font.pixelSize: Style.resize(11)
                    font.bold: true
                    color: Style.mainColor
                }

                TextEdit {
                    Layout.fillWidth: true
                    text: root.result
                    readOnly: true
                    wrapMode: TextEdit.WordWrap
                    font.family: "Consolas"
                    font.pixelSize: Style.resize(12)
                    color: "#A0D0A0"
                    selectByMouse: true
                }
            }
        }
    }
}
