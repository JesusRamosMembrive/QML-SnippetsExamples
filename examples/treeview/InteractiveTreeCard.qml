// =============================================================================
// InteractiveTreeCard.qml — Arbol dinamico con operaciones CRUD
// =============================================================================
// Permite agregar nodos hijo, eliminar nodos y editar sus datos en un
// TreeView. Demuestra las operaciones de modificacion estructural de un
// QAbstractItemModel en C++.
//
// Conexion QML <-> C++:
//   - OrganizationTreeModel (C++) expone estas operaciones como Q_INVOKABLEs:
//     - addNode(parentIndex, name, title, dept, email): inserta un hijo
//       bajo el nodo seleccionado. Internamente llama beginInsertRows() y
//       endInsertRows() para que TreeView se entere del cambio.
//     - removeNode(index): elimina el nodo y todos sus hijos. Usa
//       beginRemoveRows() / endRemoveRows().
//     - editNode(index, name, title, dept, email): modifica los datos del
//       nodo y emite dataChanged() para actualizar la vista.
//     - nameAt(index), titleAt(index), etc.: metodos de lectura que extraen
//       datos de un QModelIndex. Necesarios porque desde QML no se puede
//       acceder a data(index, role) directamente con un QModelIndex.
//
// Patrones clave:
//   - ItemSelectionModel.onCurrentChanged: cuando la seleccion cambia, se
//     rellenan los TextFields con los datos del nodo seleccionado usando
//     nameAt(), titleAt(), etc. Esto permite editar y luego guardar con
//     el boton "Edit".
//   - GridLayout con 4 columnas: organiza Label + TextField en pares,
//     creando un formulario compacto de 2 columnas visuales.
//   - Modelo independiente: orgEditModel es una instancia SEPARADA de
//     OrganizationTreeModel, distinta de orgModel que usa OrganizationTreeCard.
//     Esto permite que las operaciones CRUD no afecten la vista de solo lectura.
//   - enabled: editSelModel.hasSelection: los botones de accion solo se
//     activan cuando hay un nodo seleccionado, previniendo errores.
// =============================================================================
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils
import treemodel

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    required property var orgModel

    function deptColor(dept) {
        switch (dept) {
        case "Executive":  return "#E91E63"
        case "Technology": return "#2196F3"
        case "Finance":    return "#FF9800"
        case "Operations": return "#4CAF50"
        default:           return Style.inactiveColor
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Dynamic Tree"
                font.pixelSize: Style.resize(20)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
            }
            Label {
                text: root.orgModel.nodeCount + " nodes"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }
        }

        // Action buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)
            Button {
                text: "Add Child"
                enabled: editSelModel.hasSelection
                onClicked: {
                    root.orgModel.addNode(
                        editSelModel.currentIndex,
                        nameField.text || "New Person",
                        titleField.text || "Employee",
                        deptField.text || "Technology",
                        emailField.text || "new@company.com")
                }
            }
            Button {
                text: "Remove"
                enabled: editSelModel.hasSelection
                onClicked: root.orgModel.removeNode(editSelModel.currentIndex)
            }
            Button {
                text: "Edit"
                enabled: editSelModel.hasSelection
                         && nameField.text.length > 0
                onClicked: {
                    root.orgModel.editNode(
                        editSelModel.currentIndex,
                        nameField.text, titleField.text,
                        deptField.text, emailField.text)
                }
            }
            Item { Layout.fillWidth: true }
        }

        // Input fields
        GridLayout {
            Layout.fillWidth: true
            columns: 4
            columnSpacing: Style.resize(8)
            rowSpacing: Style.resize(4)

            Label {
                text: "Name:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }
            TextField {
                id: nameField
                Layout.fillWidth: true
                placeholderText: "Name"
                font.pixelSize: Style.resize(11)
            }
            Label {
                text: "Title:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }
            TextField {
                id: titleField
                Layout.fillWidth: true
                placeholderText: "Title"
                font.pixelSize: Style.resize(11)
            }
            Label {
                text: "Dept:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }
            TextField {
                id: deptField
                Layout.fillWidth: true
                placeholderText: "Department"
                font.pixelSize: Style.resize(11)
            }
            Label {
                text: "Email:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }
            TextField {
                id: emailField
                Layout.fillWidth: true
                placeholderText: "Email"
                font.pixelSize: Style.resize(11)
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            TreeView {
                id: editTree
                anchors.fill: parent
                model: root.orgModel
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                selectionBehavior: TableView.SelectRows
                selectionMode: TableView.SingleSelection

                selectionModel: ItemSelectionModel {
                    id: editSelModel
                    model: root.orgModel

                    onCurrentChanged: function(current, previous) {
                        if (current.valid) {
                            nameField.text = root.orgModel.nameAt(current)
                            titleField.text = root.orgModel.titleAt(current)
                            deptField.text = root.orgModel.departmentAt(current)
                            emailField.text = root.orgModel.emailAt(current)
                        }
                    }
                }

                delegate: Item {
                    id: editDelegate
                    implicitWidth: editTree.width
                    implicitHeight: Style.resize(32)

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
                        color: editDelegate.selected
                            ? Qt.rgba(0, 0.82, 0.66, 0.15)
                            : (editDelegate.row % 2 === 0
                               ? Style.cardColor : Style.surfaceColor)
                    }

                    RowLayout {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: Style.resize(8)
                                            + editDelegate.depth
                                              * Style.resize(20)
                        anchors.rightMargin: Style.resize(8)
                        spacing: Style.resize(6)

                        // Expand/collapse arrow
                        Label {
                            visible: editDelegate.isTreeNode
                                     && editDelegate.hasChildren
                            text: editDelegate.expanded ? "\u25BC" : "\u25B6"
                            color: Style.mainColor
                            font.pixelSize: Style.resize(10)
                            Layout.preferredWidth: Style.resize(14)
                        }

                        Item {
                            visible: !(editDelegate.isTreeNode
                                       && editDelegate.hasChildren)
                            Layout.preferredWidth: Style.resize(14)
                        }

                        // Name
                        Label {
                            text: model.name
                            color: editDelegate.selected
                                ? Style.mainColor : Style.fontPrimaryColor
                            font.pixelSize: Style.resize(12)
                            font.bold: true
                        }

                        // Title
                        Label {
                            text: model.title
                            color: Style.fontSecondaryColor
                            font.pixelSize: Style.resize(11)
                            Layout.fillWidth: true
                        }

                        // Department badge
                        Rectangle {
                            Layout.preferredWidth: editDeptLabel.implicitWidth
                                                   + Style.resize(12)
                            Layout.preferredHeight: Style.resize(18)
                            radius: Style.resize(4)
                            color: {
                                var c = Qt.color(root.deptColor(model.department))
                                return Qt.rgba(c.r, c.g, c.b, 0.2)
                            }

                            Label {
                                id: editDeptLabel
                                anchors.centerIn: parent
                                text: model.department
                                font.pixelSize: Style.resize(9)
                                color: root.deptColor(model.department)
                            }
                        }
                    }

                    TapHandler {
                        onTapped: {
                            editTree.selectionModel.setCurrentIndex(
                                editTree.index(editDelegate.row, 0),
                                ItemSelectionModel.ClearAndSelect)
                            if (editDelegate.hasChildren)
                                editTree.toggleExpanded(editDelegate.row)
                        }
                    }
                }
            }
        }

        Label {
            text: "Dynamic tree: add child, remove, edit nodes. Uses beginInsertRows/endInsertRows on C++ model."
            font.pixelSize: Style.resize(11)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
