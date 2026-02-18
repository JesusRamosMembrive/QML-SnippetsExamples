import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils
import treemodel

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    required property var fileModel

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "File System Tree"
                font.pixelSize: Style.resize(20)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
            }
            Label {
                text: root.fileModel.totalNodes + " items"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(50)
            Button {
                text: "Expand All"
                onClicked: fsTree.expandRecursively(-1, -1)
            }
            Button {
                text: "Collapse All"
                onClicked: fsTree.collapseRecursively(-1)
            }
            Item { Layout.fillWidth: true }
            Label {
                text: "Click to expand/collapse"
                font.pixelSize: Style.resize(11)
                font.italic: true
                color: Style.inactiveColor
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            TreeView {
                id: fsTree
                anchors.fill: parent
                model: root.fileModel
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                selectionBehavior: TableView.SelectRows
                selectionMode: TableView.SingleSelection

                selectionModel: ItemSelectionModel {
                    id: fsSelModel
                    model: root.fileModel
                }

                delegate: Item {
                    id: fsDelegate
                    implicitWidth: fsTree.width
                    implicitHeight: Style.resize(30)

                    required property TreeView treeView
                    required property bool isTreeNode
                    required property bool expanded
                    required property bool hasChildren
                    required property int depth
                    required property int row
                    required property int column
                    required property bool current
                    required property bool selected

                    Rectangle {
                        anchors.fill: parent
                        color: fsDelegate.selected
                            ? Qt.rgba(0, 0.82, 0.66, 0.15)
                            : (fsDelegate.row % 2 === 0
                               ? Style.cardColor : Style.surfaceColor)
                    }

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        x: Style.resize(8) + fsDelegate.depth * Style.resize(20)
                        spacing: Style.resize(6)

                        // Expand/collapse arrow
                        Label {
                            visible: fsDelegate.isTreeNode
                                     && fsDelegate.hasChildren
                            text: fsDelegate.expanded ? "\u25BC" : "\u25B6"
                            color: Style.mainColor
                            font.pixelSize: Style.resize(10)
                            anchors.verticalCenter: parent.verticalCenter
                            width: Style.resize(14)
                        }

                        // Spacer when no arrow
                        Item {
                            visible: !(fsDelegate.isTreeNode
                                       && fsDelegate.hasChildren)
                            width: Style.resize(14)
                            height: 1
                        }

                        // Folder/file icon
                        Label {
                            text: model.isFolder ? "\uD83D\uDCC1" : "\uD83D\uDCC4"
                            font.pixelSize: Style.resize(13)
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        // File name
                        Label {
                            text: model.fileName
                            color: fsDelegate.selected
                                ? Style.mainColor : Style.fontPrimaryColor
                            font.pixelSize: Style.resize(12)
                            font.bold: model.isFolder
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        // File size
                        Label {
                            visible: !model.isFolder
                            text: model.fileSize
                            color: Style.inactiveColor
                            font.pixelSize: Style.resize(11)
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    TapHandler {
                        onTapped: {
                            fsTree.selectionModel.setCurrentIndex(
                                fsTree.index(fsDelegate.row, 0),
                                ItemSelectionModel.ClearAndSelect)
                            if (fsDelegate.hasChildren)
                                fsTree.toggleExpanded(fsDelegate.row)
                        }
                    }
                }
            }
        }

        Label {
            text: "QAbstractItemModel with custom TreeView delegate. Depth-based indentation with expand/collapse."
            font.pixelSize: Style.resize(11)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
