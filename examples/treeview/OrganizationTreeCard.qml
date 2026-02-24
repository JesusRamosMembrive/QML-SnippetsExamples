// =============================================================================
// OrganizationTreeCard.qml — Organigrama empresarial con roles personalizados
// =============================================================================
// Muestra un arbol de organizacion (CEO -> directores -> empleados) usando
// TreeView con roles personalizados definidos en C++: name, title, department.
// Cada nodo muestra nombre en negrita, cargo en gris y un badge de departamento
// con color asignado.
//
// Conexion QML <-> C++:
//   - OrganizationTreeModel (C++): hereda de QAbstractItemModel. Ademas de
//     los metodos estandar (index, parent, rowCount, data), implementa:
//     - roleNames(): mapea roles numericos a strings QML:
//       Qt::UserRole + 1 -> "name", +2 -> "title", +3 -> "department", etc.
//     - nodeCount (Q_PROPERTY): conteo total de nodos en el arbol.
//   - En el delegate, se accede a los roles como model.name, model.title,
//     model.department — nombres definidos en roleNames().
//
// Patrones clave:
//   - Funcion deptColor(dept): asigna un color fijo a cada departamento
//     usando switch/case. Se usa tanto para el texto del badge como para
//     su fondo (con opacidad reducida via Qt.rgba()).
//   - Badge de departamento: un Rectangle cuyo ancho depende del texto
//     interno (implicitWidth + padding). El color de fondo se calcula
//     convirtiendo el color del departamento a Qt.color() y reduciendo
//     su opacidad a 0.2.
//   - RowLayout con indentacion: anchors.leftMargin incluye depth * 20px
//     para la indentacion jerarquica. El nombre, titulo y badge se
//     distribuyen horizontalmente con Layout.fillWidth en el titulo.
//   - Modelo de solo lectura: a diferencia de InteractiveTreeCard, este
//     organigrama no permite agregar ni eliminar nodos. Son dos instancias
//     separadas del mismo tipo de modelo (OrganizationTreeModel).
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
                text: "Organization Chart"
                font.pixelSize: Style.resize(20)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
            }
            Label {
                text: root.orgModel.nodeCount + " members"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(50)
            Button {
                text: "Expand All"
                onClicked: orgTree.expandRecursively(-1, -1)
            }
            Button {
                text: "Collapse All"
                onClicked: orgTree.collapseRecursively(-1)
            }
            Item { Layout.fillWidth: true }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            TreeView {
                id: orgTree
                anchors.fill: parent
                model: root.orgModel
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                selectionBehavior: TableView.SelectRows
                selectionMode: TableView.SingleSelection

                selectionModel: ItemSelectionModel {
                    id: orgSelModel
                    model: root.orgModel
                }

                delegate: Item {
                    id: orgDelegate
                    implicitWidth: orgTree.width
                    implicitHeight: Style.resize(36)

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
                        color: orgDelegate.selected
                            ? Qt.rgba(0, 0.82, 0.66, 0.15)
                            : (orgDelegate.row % 2 === 0
                               ? Style.cardColor : Style.surfaceColor)
                    }

                    RowLayout {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: Style.resize(8)
                                            + orgDelegate.depth * Style.resize(20)
                        anchors.rightMargin: Style.resize(8)
                        spacing: Style.resize(6)

                        // Expand/collapse arrow
                        Label {
                            visible: orgDelegate.isTreeNode
                                     && orgDelegate.hasChildren
                            text: orgDelegate.expanded ? "\u25BC" : "\u25B6"
                            color: Style.mainColor
                            font.pixelSize: Style.resize(10)
                            Layout.preferredWidth: Style.resize(14)
                        }

                        Item {
                            visible: !(orgDelegate.isTreeNode
                                       && orgDelegate.hasChildren)
                            Layout.preferredWidth: Style.resize(14)
                        }

                        // Name
                        Label {
                            text: model.name
                            color: orgDelegate.selected
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
                            Layout.preferredWidth: deptLabel.implicitWidth
                                                   + Style.resize(12)
                            Layout.preferredHeight: Style.resize(20)
                            radius: Style.resize(4)
                            color: {
                                var c = Qt.color(root.deptColor(model.department))
                                return Qt.rgba(c.r, c.g, c.b, 0.2)
                            }

                            Label {
                                id: deptLabel
                                anchors.centerIn: parent
                                text: model.department
                                font.pixelSize: Style.resize(9)
                                color: root.deptColor(model.department)
                            }
                        }
                    }

                    TapHandler {
                        onTapped: {
                            orgTree.selectionModel.setCurrentIndex(
                                orgTree.index(orgDelegate.row, 0),
                                ItemSelectionModel.ClearAndSelect)
                            if (orgDelegate.hasChildren)
                                orgTree.toggleExpanded(orgDelegate.row)
                        }
                    }
                }
            }
        }

        Label {
            text: "Custom roles (name, title, department, email) exposed via roleNames(). Department color-coded badges."
            font.pixelSize: Style.resize(11)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
