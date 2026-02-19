// =============================================================================
// SortFilterTableCard.qml — Tabla con ordenamiento y filtrado via C++ Proxy
// =============================================================================
// Demuestra el uso de QSortFilterProxyModel para agregar ordenamiento por
// columna y filtrado por texto a un TableView sin modificar el modelo original.
//
// Conexion QML <-> C++:
//   - EmployeeProxyModel (C++): hereda de QSortFilterProxyModel. Envuelve
//     al EmployeeModel como sourceModel y expone:
//     - filterText (Q_PROPERTY): texto de filtrado. Al cambiar, el proxy
//       re-evalua filterAcceptsRow() y oculta las filas que no coinciden.
//     - toggleSort(column) (Q_INVOKABLE): alterna entre ascendente y
//       descendente para la columna dada. Internamente llama a sort().
//     - sortColumn / currentSortOrder (Q_PROPERTYs): informan a QML cual
//       columna esta ordenada y en que direccion, para mostrar la flecha.
//   - El proxyModel se instancia en Main.qml y se pasa como required property.
//     Esto permite que multiples cards compartan el mismo modelo fuente.
//
// Patrones clave:
//   - TapHandler en header delegate: al tocar una cabecera, llama a
//     toggleSort(model.index). El indicador de flecha se actualiza via
//     binding a sortColumn y currentSortOrder.
//   - Formateo condicional por columna: column === 4 muestra "Yes"/"No"
//     con color verde/rojo; column === 3 formatea como moneda. Se usa
//     el numero de columna porque TableView expone "column" en el delegate.
//   - Modelo compartido: proxyModel envuelve al mismo employeeModel que
//     usa EditableTableCard. Cambios en una card se reflejan en la otra
//     gracias al sistema de senales de Qt.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils
import tablemodel

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    required property var proxyModel
    required property var employeeModel

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Sort & Filter (C++ Proxy)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Filter
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)
            Label {
                text: "Filter:"
                color: Style.fontPrimaryColor
                font.pixelSize: Style.resize(13)
            }
            TextField {
                id: filterField
                Layout.fillWidth: true
                placeholderText: "Search name or department..."
                onTextChanged: root.proxyModel.filterText = text
            }
        }

        // Sort info
        RowLayout {
            Layout.fillWidth: true
            Label {
                text: root.proxyModel.sortColumn >= 0
                    ? "Sorted by column " + root.proxyModel.sortColumn +
                      (root.proxyModel.currentSortOrder === Qt.AscendingOrder ? " ▲" : " ▼")
                    : "Click a header to sort"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
                Layout.fillWidth: true
            }
            Label {
                text: sortTable.rows + " rows"
                font.pixelSize: Style.resize(11)
                color: Style.inactiveColor
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            HorizontalHeaderView {
                id: sortHeader
                anchors.top: parent.top
                anchors.left: sortTable.left
                anchors.right: sortTable.right
                syncView: sortTable
                clip: true

                delegate: Rectangle {
                    implicitWidth: Style.resize(120)
                    implicitHeight: Style.resize(34)
                    color: Style.bgColor

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(8)
                        anchors.rightMargin: Style.resize(8)
                        spacing: Style.resize(4)

                        Label {
                            text: model.display
                            color: Style.mainColor
                            font.pixelSize: Style.resize(12)
                            font.bold: true
                            Layout.fillWidth: true
                        }
                        Label {
                            visible: root.proxyModel.sortColumn === model.index
                            text: root.proxyModel.currentSortOrder === Qt.AscendingOrder ? "▲" : "▼"
                            color: Style.mainColor
                            font.pixelSize: Style.resize(10)
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: "#3A3D45"
                    }

                    TapHandler {
                        onTapped: root.proxyModel.toggleSort(model.index)
                    }
                }
            }

            TableView {
                id: sortTable
                anchors.top: sortHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                model: root.proxyModel
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                selectionBehavior: TableView.SelectRows

                selectionModel: ItemSelectionModel {
                    model: root.proxyModel
                }

                columnWidthProvider: function(col) {
                    var widths = [60, 180, 150, 120, 80]
                    return Style.resize(widths[col] || 120)
                }

                delegate: Rectangle {
                    required property bool selected
                    required property bool current
                    implicitWidth: Style.resize(100)
                    implicitHeight: Style.resize(32)
                    color: selected ? Qt.rgba(0, 0.82, 0.66, 0.15)
                         : (row % 2 === 0 ? Style.cardColor : Style.surfaceColor)

                    Label {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(8)
                        verticalAlignment: Text.AlignVCenter
                        text: {
                            if (column === 4) return model.display ? "Yes" : "No"
                            if (column === 3) return "$" + Number(model.display).toLocaleString()
                            return model.display
                        }
                        color: {
                            if (column === 4) return model.display ? "#4CAF50" : "#F44336"
                            return selected ? Style.mainColor : Style.fontPrimaryColor
                        }
                        font.pixelSize: Style.resize(12)
                        font.bold: column === 4
                    }
                }
            }
        }

        Label {
            text: "QSortFilterProxyModel wraps EmployeeModel. Click headers to sort, type to filter."
            font.pixelSize: Style.resize(11)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
