pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils
import database

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property var tableModel: null
    required property DatabaseManager dbManager

    property var columnWidths: [
        Style.resize(50),
        Style.resize(140),
        Style.resize(110),
        Style.resize(90),
        Style.resize(100),
        Style.resize(60)
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "CRUD Table (QSqlTableModel)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Editable employees table — OnManualSubmit strategy (batch save/revert)"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
        }

        // Toolbar: Filter + Actions
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Label {
                text: "Department:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: deptFilter
                Layout.preferredWidth: Style.resize(150)
                model: ["All", "Engineering", "Marketing", "Design", "Management"]
                onCurrentTextChanged: {
                    if (!root.tableModel) return
                    if (currentText === "All")
                        root.tableModel.setFilterString("")
                    else
                        root.tableModel.setFilterString("department = '" + currentText + "'")
                }
            }

            Item { Layout.fillWidth: true }

            Label {
                text: (root.tableModel ? root.tableModel.rowCount : 0) + " rows"
                font.pixelSize: Style.resize(12)
                color: Style.inactiveColor
            }

            Rectangle {
                Layout.preferredWidth: Style.resize(8)
                Layout.preferredHeight: Style.resize(8)
                radius: width / 2
                color: (root.tableModel && root.tableModel.hasChanges) ? "#FF9800" : "#4CAF50"
                ToolTip.visible: changeMa.containsMouse
                ToolTip.text: (root.tableModel && root.tableModel.hasChanges) ? "Unsaved changes" : "All saved"

                MouseArea {
                    id: changeMa
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }
        }

        // Table area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            // Header
            Row {
                id: headerRow
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: Style.resize(32)

                Repeater {
                    model: ["ID", "Name", "Department", "Salary", "Hire Date", "Active"]

                    Rectangle {
                        required property string modelData
                        required property int index
                        width: root.columnWidths[index]
                        height: parent.height
                        color: Style.bgColor

                        Label {
                            anchors.fill: parent
                            anchors.leftMargin: Style.resize(8)
                            verticalAlignment: Text.AlignVCenter
                            text: modelData
                            color: Style.mainColor
                            font.pixelSize: Style.resize(11)
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
            }

            // Table rows
            ListView {
                id: tableList
                anchors.top: headerRow.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                model: root.tableModel
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                currentIndex: -1

                delegate: Rectangle {
                    id: rowDelegate
                    width: tableList.width
                    height: Style.resize(30)
                    color: tableList.currentIndex === index
                           ? Qt.rgba(0, 0.82, 0.66, 0.15)
                           : (index % 2 === 0 ? Style.cardColor : Style.surfaceColor)

                    required property int index
                    required property var model

                    Row {
                        anchors.fill: parent

                        // ID
                        Label {
                            width: root.columnWidths[0]
                            height: parent.height
                            leftPadding: Style.resize(8)
                            verticalAlignment: Text.AlignVCenter
                            text: model.id !== undefined ? model.id : ""
                            color: Style.inactiveColor
                            font.pixelSize: Style.resize(11)
                        }

                        // Name
                        Label {
                            width: root.columnWidths[1]
                            height: parent.height
                            leftPadding: Style.resize(8)
                            verticalAlignment: Text.AlignVCenter
                            text: model.name !== undefined ? model.name : ""
                            color: Style.fontPrimaryColor
                            font.pixelSize: Style.resize(11)
                            elide: Text.ElideRight
                        }

                        // Department
                        Rectangle {
                            width: root.columnWidths[2]
                            height: parent.height
                            color: "transparent"

                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: Style.resize(8)
                                width: deptLabel.implicitWidth + Style.resize(12)
                                height: Style.resize(20)
                                radius: Style.resize(3)
                                color: {
                                    var dept = model.department || ""
                                    if (dept === "Engineering") return Qt.rgba(0.13, 0.59, 0.95, 0.2)
                                    if (dept === "Marketing") return Qt.rgba(1, 0.6, 0, 0.2)
                                    if (dept === "Design") return Qt.rgba(0.61, 0.15, 0.69, 0.2)
                                    if (dept === "Management") return Qt.rgba(0.3, 0.69, 0.31, 0.2)
                                    return Qt.rgba(1, 1, 1, 0.1)
                                }

                                Label {
                                    id: deptLabel
                                    anchors.centerIn: parent
                                    text: model.department !== undefined ? model.department : ""
                                    font.pixelSize: Style.resize(10)
                                    color: {
                                        var dept = model.department || ""
                                        if (dept === "Engineering") return "#2196F3"
                                        if (dept === "Marketing") return "#FF9800"
                                        if (dept === "Design") return "#9C27B0"
                                        if (dept === "Management") return "#4CAF50"
                                        return Style.fontSecondaryColor
                                    }
                                }
                            }
                        }

                        // Salary
                        Label {
                            width: root.columnWidths[3]
                            height: parent.height
                            leftPadding: Style.resize(8)
                            verticalAlignment: Text.AlignVCenter
                            text: model.salary !== undefined ? "$" + Number(model.salary).toLocaleString(Qt.locale("en_US"), 'f', 0) : ""
                            color: Style.fontPrimaryColor
                            font.pixelSize: Style.resize(11)
                        }

                        // Hire Date
                        Label {
                            width: root.columnWidths[4]
                            height: parent.height
                            leftPadding: Style.resize(8)
                            verticalAlignment: Text.AlignVCenter
                            text: model.hire_date !== undefined ? model.hire_date : ""
                            color: Style.fontSecondaryColor
                            font.pixelSize: Style.resize(11)
                        }

                        // Active
                        Rectangle {
                            width: root.columnWidths[5]
                            height: parent.height
                            color: "transparent"

                            Rectangle {
                                anchors.centerIn: parent
                                width: Style.resize(8)
                                height: Style.resize(8)
                                radius: width / 2
                                color: (model.active !== undefined && model.active == 1) ? "#4CAF50" : "#F44336"
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: tableList.currentIndex = rowDelegate.index
                    }
                }
            }
        }

        // Action buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: "Add"
                onClicked: addDialog.open()
            }

            Button {
                text: "Delete"
                enabled: root.tableModel && tableList.currentIndex >= 0
                onClicked: {
                    root.tableModel.deleteRecord(tableList.currentIndex)
                    tableList.currentIndex = -1
                }
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "Revert"
                enabled: root.tableModel && root.tableModel.hasChanges
                onClicked: {
                    root.tableModel.revertChanges()
                    tableList.currentIndex = -1
                }
            }

            Button {
                text: "Save"
                enabled: root.tableModel && root.tableModel.hasChanges
                onClicked: root.tableModel.save()
            }
        }

        // Footer
        Label {
            text: "QSqlTableModel with OnManualSubmit. Save commits, Revert discards."
            font.pixelSize: Style.resize(11)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }

    // Add record dialog
    Popup {
        id: addDialog
        anchors.centerIn: parent
        width: Style.resize(340)
        height: Style.resize(280)
        modal: true

        background: Rectangle {
            color: Style.cardColor
            radius: Style.resize(8)
            border.color: "#3A3D45"
            border.width: 1
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Style.resize(16)
            spacing: Style.resize(10)

            Label {
                text: "Add Employee"
                font.pixelSize: Style.resize(16)
                font.bold: true
                color: Style.mainColor
            }

            GridLayout {
                columns: 2
                columnSpacing: Style.resize(10)
                rowSpacing: Style.resize(6)
                Layout.fillWidth: true

                Label {
                    text: "Name:"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }
                TextField {
                    id: nameField
                    Layout.fillWidth: true
                    placeholderText: "Employee name"
                }

                Label {
                    text: "Department:"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }
                ComboBox {
                    id: deptField
                    Layout.fillWidth: true
                    model: ["Engineering", "Marketing", "Design", "Management"]
                }

                Label {
                    text: "Salary:"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }
                TextField {
                    id: salaryField
                    Layout.fillWidth: true
                    placeholderText: "75000"
                    validator: DoubleValidator { bottom: 0 }
                }

                Label {
                    text: "Hire Date:"
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                }
                TextField {
                    id: hireDateField
                    Layout.fillWidth: true
                    placeholderText: "2024-01-15"
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Item { Layout.fillWidth: true }

                Button {
                    text: "Cancel"
                    onClicked: addDialog.close()
                }

                Button {
                    text: "Add"
                    enabled: root.tableModel && nameField.text.length > 0 && salaryField.text.length > 0
                    onClicked: {
                        root.tableModel.addRecord({
                            "name": nameField.text,
                            "department": deptField.currentText,
                            "salary": parseFloat(salaryField.text),
                            "hire_date": hireDateField.text || "2024-01-01",
                            "active": 1
                        })
                        nameField.text = ""
                        salaryField.text = ""
                        hireDateField.text = ""
                        addDialog.close()
                    }
                }
            }
        }
    }
}
