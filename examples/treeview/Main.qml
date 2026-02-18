import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils
import treemodel

Item {
    id: root

    property bool fullSize: false
    anchors.fill: parent
    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    FileSystemTreeModel { id: fileModel }
    OrganizationTreeModel { id: orgModel }
    OrganizationTreeModel { id: orgEditModel }

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
                spacing: Style.resize(20)

                Label {
                    text: "TreeView (C++ Models)"
                    font.pixelSize: Style.resize(28)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                Label {
                    text: "Qt 6 TreeView with QAbstractItemModel. File system browser, " +
                          "organization chart with custom roles, and dynamic tree with add/remove/edit."
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                FileSystemTreeCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(480)
                    fileModel: fileModel
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(20)

                    OrganizationTreeCard {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(520)
                        orgModel: orgModel
                    }

                    InteractiveTreeCard {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(520)
                        orgModel: orgEditModel
                    }
                }

                Item { Layout.preferredHeight: Style.resize(20) }
            }
        }
    }
}
