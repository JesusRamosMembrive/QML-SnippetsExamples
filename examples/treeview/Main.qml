// ============================================================================
// TreeView (C++ Models) - Pagina principal
// ============================================================================
//
// CONCEPTOS CLAVE:
//
// 1. TreeView en Qt 6:
//    - TreeView es un componente de QtQuick que muestra datos jerarquicos
//      (padre-hijo) con soporte nativo para expandir/contraer nodos.
//    - Internamente usa un modelo plano (TreeModelAdaptor) que aplana la
//      jerarquia para renderizar, pero expone propiedades como "depth",
//      "hasChildren", "expanded" en cada delegate.
//
// 2. QAbstractItemModel para arboles:
//    - Es la clase base mas general para modelos en Qt. Para arboles se
//      implementan: index(), parent(), rowCount(), columnCount(), data().
//    - index() usa createIndex(row, col, puntero) donde el puntero apunta
//      al nodo interno del arbol.
//    - parent() debe devolver QModelIndex{} (invalido) para items de nivel raiz.
//    - IMPORTANTE: QVector<std::unique_ptr<T>> NO compila en Qt porque
//      QVector requiere tipos copiables. Usar std::vector<std::unique_ptr<T>>.
//
// 3. Modelos separados para vistas independientes:
//    - orgModel y orgEditModel son dos instancias distintas del mismo tipo
//      (OrganizationTreeModel). Esto permite que InteractiveTreeCard modifique
//      su arbol (agregar/eliminar nodos) sin afectar la vista de solo lectura.
//    - En contraste, si ambas cards compartieran el mismo modelo (como en
//      TableView), los cambios se reflejarian en ambas.
//
// 4. Roles personalizados (custom roles):
//    - roleNames() en C++ mapea enteros (Qt::UserRole + N) a strings QML.
//    - En QML se acceden como model.roleName dentro del delegate.
//    - Para arboles de organizacion: name, title, department, etc.
//
// ============================================================================

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

    // --- Modelos C++ de arbol ---
    // Cada modelo hereda de QAbstractItemModel e implementa la jerarquia
    // padre-hijo necesaria para TreeView.

    // Modelo de sistema de archivos: simula carpetas y archivos con
    // iconos y tamanos. Demuestra jerarquia profunda (carpetas anidadas).
    FileSystemTreeModel { id: fileModel }

    // Modelo de organizacion (solo lectura): organigrama empresarial
    // con roles personalizados (nombre, cargo, departamento).
    OrganizationTreeModel { id: orgModel }

    // Modelo de organizacion (editable): instancia separada para que las
    // operaciones de agregar/eliminar nodos no afecten a orgModel.
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

                // Card 1: Explorador de archivos (ancho completo).
                // Muestra una jerarquia de carpetas/archivos con iconos,
                // tamanos y la capacidad de expandir/contraer nodos.
                FileSystemTreeCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(480)
                    fileModel: fileModel
                }

                // Fila: Organigrama (lectura) + Arbol interactivo (CRUD)
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(20)

                    // Card de solo lectura: muestra el organigrama con
                    // roles personalizados y estilos segun el nivel de profundidad.
                    OrganizationTreeCard {
                        Layout.fillWidth: true
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(520)
                        orgModel: orgModel
                    }

                    // Card interactiva: permite agregar hijos, eliminar nodos
                    // y editar nombres. Demuestra beginInsertRows()/endInsertRows()
                    // y beginRemoveRows()/endRemoveRows() del modelo C++.
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
