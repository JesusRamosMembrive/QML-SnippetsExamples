import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.qmlmodels 1.0
import utils
import tablemodel

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    required property var employeeModel

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Editable Table"
                font.pixelSize: Style.resize(20)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
            }
            Label {
                text: root.employeeModel.count + " employees"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }
        }

        // Add / Remove
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(50)
            Button {
                text: "Add"
                onClicked: root.employeeModel.addEmployee(
                    "New Employee", "Engineering", 50000, true)
            }
            Button {
                text: "Remove"
                enabled: editSelModel.hasSelection
                onClicked: {
                    var indices = editSelModel.selectedIndexes
                    if (indices.length > 0)
                        root.employeeModel.removeEmployee(indices[0].row)
                }
            }
            Item { Layout.fillWidth: true }
            Label {
                text: "Double-click to edit"
                font.pixelSize: Style.resize(11)
                font.italic: true
                color: Style.inactiveColor
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            HorizontalHeaderView {
                id: editHeader
                anchors.top: parent.top
                anchors.left: editTable.left
                anchors.right: editTable.right
                syncView: editTable
                clip: true

                delegate: Rectangle {
                    implicitWidth: Style.resize(120)
                    implicitHeight: Style.resize(34)
                    color: Style.bgColor

                    Label {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(8)
                        verticalAlignment: Text.AlignVCenter
                        text: model.display
                        color: Style.mainColor
                        font.pixelSize: Style.resize(12)
                        font.bold: true
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: "#3A3D45"
                    }
                }
            }

            TableView {
                id: editTable
                anchors.top: editHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                model: root.employeeModel
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                selectionBehavior: TableView.SelectRows
                selectionMode: TableView.SingleSelection
                editTriggers: TableView.DoubleTapped | TableView.EditKeyPressed

                selectionModel: ItemSelectionModel {
                    id: editSelModel
                    model: root.employeeModel
                }

                columnWidthProvider: function(col) {
                    var widths = [60, 180, 150, 120, 80]
                    return Style.resize(widths[col] || 120)
                }

                delegate: DelegateChooser {
                    // Column 0: Id (read-only)
                    DelegateChoice {
                        column: 0
                        delegate: Rectangle {
                            required property bool selected
                            implicitWidth: Style.resize(50)
                            implicitHeight: Style.resize(32)
                            color: selected ? Qt.rgba(0, 0.82, 0.66, 0.15)
                                 : (row % 2 === 0 ? Style.cardColor : Style.surfaceColor)
                            Label {
                                anchors.fill: parent
                                anchors.leftMargin: Style.resize(8)
                                verticalAlignment: Text.AlignVCenter
                                text: model.display
                                color: Style.fontSecondaryColor
                                font.pixelSize: Style.resize(12)
                            }
                        }
                    }

                    // Column 1: Name (editable text)
                    DelegateChoice {
                        column: 1
                        delegate: Rectangle {
                            required property bool selected
                            required property bool editing
                            implicitWidth: Style.resize(140)
                            implicitHeight: Style.resize(32)
                            color: selected ? Qt.rgba(0, 0.82, 0.66, 0.15)
                                 : (row % 2 === 0 ? Style.cardColor : Style.surfaceColor)

                            Label {
                                visible: !parent.editing
                                anchors.fill: parent
                                anchors.leftMargin: Style.resize(8)
                                verticalAlignment: Text.AlignVCenter
                                text: model.display
                                color: Style.fontPrimaryColor
                                font.pixelSize: Style.resize(12)
                            }

                            TableView.editDelegate: TextField {
                                anchors.fill: parent
                                text: model.display
                                Component.onCompleted: selectAll()
                                onAccepted: {
                                    model.display = text
                                    TableView.commit()
                                }
                            }
                        }
                    }

                    // Column 2: Department (editable text)
                    DelegateChoice {
                        column: 2
                        delegate: Rectangle {
                            required property bool selected
                            required property bool editing
                            implicitWidth: Style.resize(110)
                            implicitHeight: Style.resize(32)
                            color: selected ? Qt.rgba(0, 0.82, 0.66, 0.15)
                                 : (row % 2 === 0 ? Style.cardColor : Style.surfaceColor)

                            Label {
                                visible: !parent.editing
                                anchors.fill: parent
                                anchors.leftMargin: Style.resize(8)
                                verticalAlignment: Text.AlignVCenter
                                text: model.display
                                color: Style.fontPrimaryColor
                                font.pixelSize: Style.resize(12)
                            }

                            TableView.editDelegate: TextField {
                                anchors.fill: parent
                                text: model.display
                                Component.onCompleted: selectAll()
                                onAccepted: {
                                    model.display = text
                                    TableView.commit()
                                }
                            }
                        }
                    }

                    // Column 3: Salary (editable number)
                    DelegateChoice {
                        column: 3
                        delegate: Rectangle {
                            required property bool selected
                            required property bool editing
                            implicitWidth: Style.resize(90)
                            implicitHeight: Style.resize(32)
                            color: selected ? Qt.rgba(0, 0.82, 0.66, 0.15)
                                 : (row % 2 === 0 ? Style.cardColor : Style.surfaceColor)

                            Label {
                                visible: !parent.editing
                                anchors.fill: parent
                                anchors.leftMargin: Style.resize(8)
                                verticalAlignment: Text.AlignVCenter
                                text: "$" + Number(model.display).toLocaleString()
                                color: Style.fontPrimaryColor
                                font.pixelSize: Style.resize(12)
                            }

                            TableView.editDelegate: TextField {
                                anchors.fill: parent
                                text: model.display
                                validator: DoubleValidator { bottom: 0 }
                                Component.onCompleted: selectAll()
                                onAccepted: {
                                    model.display = parseFloat(text)
                                    TableView.commit()
                                }
                            }
                        }
                    }

                    // Column 4: Active (checkbox toggle)
                    DelegateChoice {
                        column: 4
                        delegate: Rectangle {
                            required property bool selected
                            implicitWidth: Style.resize(60)
                            implicitHeight: Style.resize(32)
                            color: selected ? Qt.rgba(0, 0.82, 0.66, 0.15)
                                 : (row % 2 === 0 ? Style.cardColor : Style.surfaceColor)

                            CheckBox {
                                anchors.centerIn: parent
                                checked: model.display === true
                                onToggled: model.display = checked
                            }
                        }
                    }
                }
            }
        }

        Label {
            text: "DelegateChooser per column. Double-click text cells, toggle checkboxes. Calls setData() on C++ model."
            font.pixelSize: Style.resize(11)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
