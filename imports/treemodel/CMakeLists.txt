# =============================================================================
# Modulo QML: treemodel
# =============================================================================
#
# Este modulo provee modelos de datos jerarquicos (arboles) para usar en QML
# con TreeView. Contiene:
#
#   - TreeItem: Nodo generico del arbol. Cada nodo almacena datos por columna,
#     un puntero al padre y una lista de hijos con ownership (unique_ptr).
#
#   - FileSystemTreeModel: Modelo de solo lectura que simula un sistema de
#     archivos (carpetas y archivos con nombre/tamano).
#
#   - OrganizationTreeModel: Modelo interactivo (lectura/escritura) que
#     representa un organigrama empresarial con operaciones CRUD.
#
# Ambos modelos heredan de QAbstractItemModel, que es la clase base de Qt para
# datos jerarquicos. Es mas compleja que QAbstractListModel o QAbstractTableModel
# porque debe gestionar relaciones padre-hijo mediante QModelIndex.
#
# Patron clave: qt_add_library(STATIC) + qt_add_qml_module() registra las
# clases C++ como elementos QML accesibles via `import treemodel`.
# El target de enlace resultante es "treemodelpluginplugin" (Qt agrega "plugin"
# automaticamente al nombre de la biblioteca).
# =============================================================================

qt_add_library(treemodelplugin STATIC)
qt_add_qml_module(treemodelplugin
    URI "treemodel"
    VERSION 1.0
    SOURCES
        treeitem.h
        treeitem.cpp
        filesystemtreemodel.h
        filesystemtreemodel.cpp
        organizationtreemodel.h
        organizationtreemodel.cpp
)
