// =============================================================================
// EditableTableCard.qml — Tabla editable con DelegateChooser por columna
// =============================================================================
// Demuestra como hacer un TableView con celdas editables en Qt 6 usando
// DelegateChooser para asignar un delegate diferente segun la columna.
//
// Conexion QML <-> C++:
//   - EmployeeModel (C++): hereda de QAbstractTableModel. Para soportar
//     edicion, implementa:
//     - setData(index, value, role): modifica el dato y emite dataChanged().
//     - flags(): retorna Qt::ItemIsEditable para las columnas editables.
//   - addEmployee() / removeEmployee(): Q_INVOKABLEs que llaman a
//     beginInsertRows()/endInsertRows() y beginRemoveRows()/endRemoveRows()
//     respectivamente, para que TableView se entere de los cambios.
//
// Patrones clave:
//   - DelegateChooser (Qt.labs.qmlmodels): selecciona un delegate segun
//     la columna. Cada DelegateChoice especifica column: N y un delegate
//     personalizado. Esto permite:
//       Col 0 (ID): solo lectura
//       Col 1-2 (Name, Dept): TextField editable
//       Col 3 (Salary): TextField con DoubleValidator
//       Col 4 (Active): CheckBox toggle
//   - TableView.editDelegate: delegate especial que aparece solo cuando
//     la celda entra en modo edicion. Se activa con doble-click
//     (editTriggers: DoubleTapped | EditKeyPressed).
//   - TableView.commit(): metodo que se llama en onAccepted del TextField.
//     Esto guarda el valor editado y cierra el modo edicion.
//   - model.display = value: asignacion que internamente llama a setData()
//     del modelo C++, completando el ciclo QML -> C++ -> señal -> QML.
//   - Modelo compartido: el mismo employeeModel se usa en SortFilterTableCard.
//     Editar una celda aqui actualiza la otra card automaticamente.
// =============================================================================
pragma ComponentBehavior: Bound
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
                    id: editHeaderCell
                    required property var display
                    implicitWidth: Style.resize(120)
                    implicitHeight: Style.resize(34)
                    color: Style.bgColor

                    Label {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(8)
                        verticalAlignment: Text.AlignVCenter
                        text: editHeaderCell.display
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
                            id: idCell
                            required property bool selected
                            required property int row
                            required property var display
                            implicitWidth: Style.resize(50)
                            implicitHeight: Style.resize(32)
                            color: idCell.selected ? Qt.rgba(0, 0.82, 0.66, 0.15)
                                 : (idCell.row % 2 === 0 ? Style.cardColor : Style.surfaceColor)
                            Label {
                                anchors.fill: parent
                                anchors.leftMargin: Style.resize(8)
                                verticalAlignment: Text.AlignVCenter
                                text: idCell.display
                                color: Style.fontSecondaryColor
                                font.pixelSize: Style.resize(12)
                            }
                        }
                    }

                    // Column 1: Name (editable text)
                    DelegateChoice {
                        column: 1
                        delegate: Rectangle {
                            id: nameCell
                            required property bool selected
                            required property bool editing
                            required property int row
                            required property var display
                            implicitWidth: Style.resize(140)
                            implicitHeight: Style.resize(32)
                            color: nameCell.selected ? Qt.rgba(0, 0.82, 0.66, 0.15)
                                 : (nameCell.row % 2 === 0 ? Style.cardColor : Style.surfaceColor)

                            Label {
                                visible: !nameCell.editing
                                anchors.fill: parent
                                anchors.leftMargin: Style.resize(8)
                                verticalAlignment: Text.AlignVCenter
                                text: nameCell.display
                                color: Style.fontPrimaryColor
                                font.pixelSize: Style.resize(12)
                            }

                            TableView.editDelegate: TextField {
                                anchors.fill: parent
                                required property var edit
                                text: nameCell.display
                                Component.onCompleted: selectAll()
                                onAccepted: {
                                    edit = text
                                    TableView.commit()
                                }
                            }
                        }
                    }

                    // Column 2: Department (editable text)
                    DelegateChoice {
                        column: 2
                        delegate: Rectangle {
                            id: departmentCell
                            required property bool selected
                            required property bool editing
                            required property int row
                            required property var display
                            implicitWidth: Style.resize(110)
                            implicitHeight: Style.resize(32)
                            color: departmentCell.selected ? Qt.rgba(0, 0.82, 0.66, 0.15)
                                 : (departmentCell.row % 2 === 0 ? Style.cardColor : Style.surfaceColor)

                            Label {
                                visible: !departmentCell.editing
                                anchors.fill: parent
                                anchors.leftMargin: Style.resize(8)
                                verticalAlignment: Text.AlignVCenter
                                text: departmentCell.display
                                color: Style.fontPrimaryColor
                                font.pixelSize: Style.resize(12)
                            }

                            TableView.editDelegate: TextField {
                                anchors.fill: parent
                                required property var edit
                                text: departmentCell.display
                                Component.onCompleted: selectAll()
                                onAccepted: {
                                    edit = text
                                    TableView.commit()
                                }
                            }
                        }
                    }

                    // Column 3: Salary (editable number)
                    DelegateChoice {
                        column: 3
                        delegate: Rectangle {
                            id: salaryCell
                            required property bool selected
                            required property bool editing
                            required property int row
                            required property var display
                            implicitWidth: Style.resize(90)
                            implicitHeight: Style.resize(32)
                            color: salaryCell.selected ? Qt.rgba(0, 0.82, 0.66, 0.15)
                                 : (salaryCell.row % 2 === 0 ? Style.cardColor : Style.surfaceColor)

                            Label {
                                visible: !salaryCell.editing
                                anchors.fill: parent
                                anchors.leftMargin: Style.resize(8)
                                verticalAlignment: Text.AlignVCenter
                                text: "$" + Number(salaryCell.display).toLocaleString()
                                color: Style.fontPrimaryColor
                                font.pixelSize: Style.resize(12)
                            }

                            TableView.editDelegate: TextField {
                                anchors.fill: parent
                                required property var edit
                                text: salaryCell.display
                                validator: DoubleValidator { bottom: 0 }
                                Component.onCompleted: selectAll()
                                onAccepted: {
                                    edit = parseFloat(text)
                                    TableView.commit()
                                }
                            }
                        }
                    }

                    // Column 4: Active (checkbox toggle)
                    DelegateChoice {
                        column: 4
                        delegate: Rectangle {
                            id: activeCell
                            required property bool selected
                            required property int row
                            required property var display
                            required property var edit
                            implicitWidth: Style.resize(60)
                            implicitHeight: Style.resize(32)
                            color: activeCell.selected ? Qt.rgba(0, 0.82, 0.66, 0.15)
                                 : (activeCell.row % 2 === 0 ? Style.cardColor : Style.surfaceColor)

                            CheckBox {
                                anchors.centerIn: parent
                                checked: activeCell.display === true
                                onToggled: activeCell.edit = checked
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
