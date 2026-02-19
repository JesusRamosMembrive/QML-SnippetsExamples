// ============================================================================
// TableView (C++ Models) - Pagina principal
// ============================================================================
//
// CONCEPTOS CLAVE:
//
// 1. TableView en Qt 6:
//    - A diferencia de Qt 5 (donde TableView era un componente de Controls),
//      en Qt 6 TableView vive en QtQuick y trabaja directamente con modelos
//      tabulares (filas + columnas). Es extremadamente eficiente porque solo
//      crea delegates para las celdas visibles (reciclaje de delegates).
//
// 2. QAbstractTableModel (C++):
//    - Es la clase base para modelos tabulares personalizados en C++.
//    - Requiere implementar: rowCount(), columnCount(), data(), roleNames().
//    - Para celdas editables se sobreescribe setData() y flags().
//    - Al registrar el modelo con QML_ELEMENT, se puede instanciar directamente
//      en QML como cualquier otro tipo.
//
// 3. QSortFilterProxyModel:
//    - Modelo proxy que envuelve al modelo fuente (sourceModel) para agregar
//      ordenamiento y filtrado sin modificar los datos originales.
//    - En QML se asigna sourceModel y luego se controlan filterRole,
//      filterRegularExpression, sortOrder, etc.
//
// 4. Patron de compartir modelos:
//    - EmployeeModel se instancia una sola vez en esta pagina y se pasa
//      como propiedad a las cards hijas (SortFilterTableCard y EditableTableCard).
//    - Esto asegura que todas las vistas reflejen los mismos datos.
//      Cuando EditableTableCard modifica una celda, SortFilterTableCard
//      se actualiza automaticamente gracias al sistema de senales del modelo.
//
// ============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils
import tablemodel

Item {
    id: root

    property bool fullSize: false
    anchors.fill: parent
    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    // --- Modelos C++ compartidos ---
    // EmployeeModel hereda de QAbstractTableModel y expone datos tabulares
    // (nombre, departamento, salario, etc.) a QML mediante roleNames().
    EmployeeModel { id: employeeModel }

    // EmployeeProxyModel hereda de QSortFilterProxyModel.
    // Envuelve al modelo fuente para permitir filtrado y ordenamiento
    // sin alterar los datos originales. sourceModel conecta ambos modelos.
    EmployeeProxyModel {
        id: proxyModel
        sourceModel: employeeModel
    }

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
                    text: "TableView (C++ Models)"
                    font.pixelSize: Style.resize(28)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                Label {
                    text: "Demonstrates Qt 6 TableView with QAbstractTableModel, QSortFilterProxyModel, " +
                          "and editable cells via DelegateChooser. Card 1 uses pure QML; Cards 2-3 share a C++ EmployeeModel."
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                // Card 1: Tabla basica solo con QML (ancho completo).
                // Demuestra que TableView puede funcionar con un modelo
                // ListModel de QML sin necesidad de C++.
                BasicTableCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(450)
                }

                // Fila: Sort/Filter + Editable lado a lado.
                // Ambas cards comparten el mismo EmployeeModel de C++,
                // lo que permite ver en tiempo real como los cambios en una
                // card se reflejan en la otra.
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(20)

                    // Card con filtrado y ordenamiento via QSortFilterProxyModel.
                    // El proxyModel intercepta las peticiones y reordena/filtra
                    // las filas sin tocar el modelo original.
                    SortFilterTableCard {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(520)
                        proxyModel: proxyModel
                        employeeModel: employeeModel
                    }

                    // Card con celdas editables via DelegateChooser.
                    // DelegateChooser permite asignar un delegate diferente
                    // segun la columna (texto, numero, combo, checkbox).
                    EditableTableCard {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(520)
                        employeeModel: employeeModel
                    }
                }

                Item { Layout.preferredHeight: Style.resize(20) }
            }
        }
    }
}
