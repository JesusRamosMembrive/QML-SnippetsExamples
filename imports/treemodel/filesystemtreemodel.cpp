// =============================================================================
// FileSystemTreeModel - Implementacion del modelo jerarquico de archivos
// =============================================================================
//
// Este archivo implementa los metodos obligatorios de QAbstractItemModel.
// La logica central se basa en navegar el arbol de TreeItems usando
// createIndex() e internalPointer().
// =============================================================================

#include "filesystemtreemodel.h"

// Constructor: crea el nodo raiz invisible y puebla datos de ejemplo.
// El nodo raiz nunca se muestra en la vista — es el "contenedor" del nivel 0.
FileSystemTreeModel::FileSystemTreeModel(QObject *parent)
    : QAbstractItemModel(parent)
    , m_rootItem(std::make_unique<TreeItem>(QVariantList{QString("root"), false, QString()}))
{
    populateData();
}

FileSystemTreeModel::~FileSystemTreeModel() = default;

// index(): dado un padre + fila + columna, devuelve el QModelIndex del hijo.
//
// Flujo:
//   1. Si el padre es invalido (QModelIndex vacio), usamos el nodo raiz
//   2. Extraemos el TreeItem del padre con internalPointer()
//   3. Obtenemos el hijo en la fila solicitada
//   4. Creamos un QModelIndex con createIndex(row, column, puntero_al_hijo)
//
// createIndex() almacena el puntero al TreeItem DENTRO del QModelIndex.
// Esto permite que cualquier metodo posterior recupere el TreeItem directamente
// con index.internalPointer(), sin tener que buscar en todo el arbol.
QModelIndex FileSystemTreeModel::index(int row, int column,
                                        const QModelIndex &parent) const
{
    if (!hasIndex(row, column, parent))
        return {};

    TreeItem *parentItem = parent.isValid()
        ? static_cast<TreeItem *>(parent.internalPointer())
        : m_rootItem.get();

    TreeItem *childItem = parentItem->child(row);
    if (childItem)
        return createIndex(row, column, childItem);
    return {};
}

// parent(): dado el indice de un nodo, devuelve el indice de su padre.
//
// REGLA CRITICA: si el padre es el nodo raiz (o no existe), DEBEMOS retornar
// QModelIndex{} (indice vacio/invalido). Asi es como Qt sabe que un elemento
// esta en el nivel superior del arbol. Si retornamos un indice valido para
// el nodo raiz, Qt entra en recursion infinita o muestra datos incorrectos.
QModelIndex FileSystemTreeModel::parent(const QModelIndex &index) const
{
    if (!index.isValid())
        return {};

    auto *childItem = static_cast<TreeItem *>(index.internalPointer());
    TreeItem *parentItem = childItem->parentItem();

    // Si el padre es nullptr o es el nodo raiz → retornar indice invalido
    if (!parentItem || parentItem == m_rootItem.get())
        return {};

    return createIndex(parentItem->row(), 0, parentItem);
}

// rowCount(): cuantos hijos tiene el nodo indicado por 'parent'.
// Si parent es invalido → contar hijos del nodo raiz (elementos del nivel 0).
int FileSystemTreeModel::rowCount(const QModelIndex &parent) const
{
    if (parent.column() > 0)
        return 0;

    const TreeItem *parentItem = parent.isValid()
        ? static_cast<const TreeItem *>(parent.internalPointer())
        : m_rootItem.get();

    return parentItem->childCount();
}

int FileSystemTreeModel::columnCount(const QModelIndex &) const
{
    return 1;
}

// data(): devuelve el dato segun el rol solicitado.
// Extraemos el TreeItem del indice y consultamos la columna correspondiente.
// Cada rol mapea a una columna del TreeItem: 0=nombre, 1=esCarptea, 2=tamano.
QVariant FileSystemTreeModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return {};

    const auto *item = static_cast<const TreeItem *>(index.internalPointer());

    switch (role) {
    case Qt::DisplayRole:
    case FileNameRole:
        return item->data(0);
    case IsFolderRole:
        return item->data(1);
    case FileSizeRole:
        return item->data(2);
    default:
        return {};
    }
}

// roleNames(): mapea los enteros de rol a nombres de cadena para QML.
// Sin esto, QML no podria hacer `model.fileName` — solo veria `model.display`.
// Este patron es OBLIGATORIO para cualquier modelo que quiera exponer datos
// con nombres personalizados a delegates de QML.
QHash<int, QByteArray> FileSystemTreeModel::roleNames() const
{
    QHash<int, QByteArray> roles = QAbstractItemModel::roleNames();
    roles[FileNameRole] = "fileName";
    roles[IsFolderRole] = "isFolder";
    roles[FileSizeRole] = "fileSize";
    return roles;
}

int FileSystemTreeModel::totalNodes() const
{
    return m_totalNodes;
}

// Helpers para construir el arbol: crean TreeItems y los agregan como hijos.
// Guardan una copia del puntero raw antes de hacer std::move() porque despues
// del move, el unique_ptr original queda vacio (nullptr).
TreeItem *FileSystemTreeModel::addFolder(TreeItem *parent, const QString &name)
{
    auto item = std::make_unique<TreeItem>(
        QVariantList{name, true, QString()}, parent);
    TreeItem *ptr = item.get();
    parent->appendChild(std::move(item));
    m_totalNodes++;
    return ptr;
}

TreeItem *FileSystemTreeModel::addFile(TreeItem *parent, const QString &name,
                                        const QString &size)
{
    auto item = std::make_unique<TreeItem>(
        QVariantList{name, false, size}, parent);
    TreeItem *ptr = item.get();
    parent->appendChild(std::move(item));
    m_totalNodes++;
    return ptr;
}

void FileSystemTreeModel::populateData()
{
    TreeItem *root = m_rootItem.get();

    // QML-SnippetsExamples/
    auto *project = addFolder(root, "QML-SnippetsExamples");

    // examples/
    auto *examples = addFolder(project, "examples");

    auto *buttons = addFolder(examples, "buttons");
    addFile(buttons, "Main.qml", "2.1 KB");
    addFile(buttons, "CMakeLists.txt", "0.3 KB");

    auto *sliders = addFolder(examples, "sliders");
    addFile(sliders, "Main.qml", "3.4 KB");
    addFile(sliders, "CMakeLists.txt", "0.3 KB");

    auto *tableview = addFolder(examples, "tableview");
    addFile(tableview, "Main.qml", "1.8 KB");
    addFile(tableview, "BasicTableCard.qml", "2.5 KB");
    addFile(tableview, "SortFilterTableCard.qml", "3.2 KB");
    addFile(tableview, "EditableTableCard.qml", "4.1 KB");

    auto *treeview = addFolder(examples, "treeview");
    addFile(treeview, "Main.qml", "1.9 KB");
    addFile(treeview, "FileSystemTreeCard.qml", "3.5 KB");
    addFile(treeview, "OrganizationTreeCard.qml", "3.8 KB");
    addFile(treeview, "InteractiveTreeCard.qml", "4.2 KB");

    auto *animations = addFolder(examples, "animations");
    addFile(animations, "Main.qml", "5.2 KB");

    auto *lists = addFolder(examples, "lists");
    addFile(lists, "Main.qml", "4.8 KB");

    // imports/
    auto *imports = addFolder(project, "imports");

    auto *utils = addFolder(imports, "utils");
    addFile(utils, "Style.qml", "1.5 KB");

    auto *controls = addFolder(imports, "controls");
    addFile(controls, "BaseCard.qml", "0.4 KB");
    addFile(controls, "Separator.qml", "0.2 KB");

    auto *treemodel = addFolder(imports, "treemodel");
    addFile(treemodel, "treeitem.h", "0.8 KB");
    addFile(treemodel, "treeitem.cpp", "1.2 KB");
    addFile(treemodel, "filesystemtreemodel.h", "1.0 KB");
    addFile(treemodel, "filesystemtreemodel.cpp", "2.5 KB");
    addFile(treemodel, "organizationtreemodel.h", "1.3 KB");
    addFile(treemodel, "organizationtreemodel.cpp", "3.0 KB");

    // mainui/
    auto *mainui = addFolder(project, "mainui");

    auto *home = addFolder(mainui, "home");
    addFile(home, "Dashboard.qml", "5.2 KB");
    addFile(home, "HomePage.qml", "2.8 KB");

    auto *mainmenu = addFolder(mainui, "mainmenu");
    addFile(mainmenu, "MainMenuList.qml", "1.5 KB");

    // styles/
    auto *styles = addFolder(project, "styles");
    auto *styledir = addFolder(styles, "qmlsnippetsstyle");
    addFile(styledir, "Button.qml", "1.8 KB");
    addFile(styledir, "Slider.qml", "2.1 KB");
    addFile(styledir, "Label.qml", "0.5 KB");

    // root files
    addFile(project, "CMakeLists.txt", "1.2 KB");
    addFile(project, "README.md", "3.5 KB");
    addFile(project, "CLAUDE.md", "4.8 KB");
}
