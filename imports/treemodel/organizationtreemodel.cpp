// =============================================================================
// OrganizationTreeModel - Implementacion del modelo jerarquico interactivo
// =============================================================================
//
// Implementa los mismos metodos base que FileSystemTreeModel (index, parent,
// rowCount, data) con el mismo patron de internalPointer(), mas metodos
// de escritura (setData, addNode, removeNode, editNode).
// =============================================================================

#include "organizationtreemodel.h"

// Constructor: crea nodo raiz invisible con 4 columnas vacias (name, title,
// department, email) y puebla el organigrama de ejemplo.
OrganizationTreeModel::OrganizationTreeModel(QObject *parent)
    : QAbstractItemModel(parent)
    , m_rootItem(std::make_unique<TreeItem>(
          QVariantList{QString(), QString(), QString(), QString()}))
{
    populateData();
}

OrganizationTreeModel::~OrganizationTreeModel() = default;

// index(): misma logica que FileSystemTreeModel — usa internalPointer() para
// obtener el TreeItem padre, busca el hijo y crea un indice con createIndex().
QModelIndex OrganizationTreeModel::index(int row, int column,
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

// parent(): DEBE retornar QModelIndex{} para elementos del nivel raiz.
// Sin esta regla, Qt no puede determinar donde termina el arbol.
QModelIndex OrganizationTreeModel::parent(const QModelIndex &index) const
{
    if (!index.isValid())
        return {};

    auto *childItem = static_cast<TreeItem *>(index.internalPointer());
    TreeItem *parentItem = childItem->parentItem();

    // Regla critica: nodo raiz o nullptr → indice invalido
    if (!parentItem || parentItem == m_rootItem.get())
        return {};

    return createIndex(parentItem->row(), 0, parentItem);
}

int OrganizationTreeModel::rowCount(const QModelIndex &parent) const
{
    if (parent.column() > 0)
        return 0;

    const TreeItem *parentItem = parent.isValid()
        ? static_cast<const TreeItem *>(parent.internalPointer())
        : m_rootItem.get();

    return parentItem->childCount();
}

int OrganizationTreeModel::columnCount(const QModelIndex &) const
{
    return 1;
}

// data(): mapea cada rol a una columna del TreeItem.
// Qt::DisplayRole se mapea al nombre para que funcione con vistas genericas.
QVariant OrganizationTreeModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return {};

    const auto *item = static_cast<const TreeItem *>(index.internalPointer());

    switch (role) {
    case Qt::DisplayRole:
    case NameRole:
        return item->data(0);
    case TitleRole:
        return item->data(1);
    case DepartmentRole:
        return item->data(2);
    case EmailRole:
        return item->data(3);
    default:
        return {};
    }
}

// setData(): modifica un campo individual del nodo.
// Despues de modificar, emite dataChanged() para notificar a las vistas.
// dataChanged(indice, indice, {roles}) indica QUE cambio y DONDE, para que
// las vistas solo actualicen el delegate afectado (no toda la vista).
bool OrganizationTreeModel::setData(const QModelIndex &index,
                                     const QVariant &value, int role)
{
    if (!index.isValid())
        return false;

    auto *item = static_cast<TreeItem *>(index.internalPointer());
    bool changed = false;

    switch (role) {
    case Qt::EditRole:
    case NameRole:
        changed = item->setData(0, value);
        break;
    case TitleRole:
        changed = item->setData(1, value);
        break;
    case DepartmentRole:
        changed = item->setData(2, value);
        break;
    case EmailRole:
        changed = item->setData(3, value);
        break;
    default:
        return false;
    }

    if (changed)
        emit dataChanged(index, index, {role});
    return changed;
}

// flags(): indica que cada nodo es seleccionable y editable.
// Sin ItemIsEditable, setData() nunca seria llamado por las vistas.
Qt::ItemFlags OrganizationTreeModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEnabled | Qt::ItemIsSelectable | Qt::ItemIsEditable;
}

// roleNames(): mapea roles a nombres para QML.
// En QML se usa asi: Text { text: model.name } o model.department, etc.
QHash<int, QByteArray> OrganizationTreeModel::roleNames() const
{
    QHash<int, QByteArray> roles = QAbstractItemModel::roleNames();
    roles[NameRole] = "name";
    roles[TitleRole] = "title";
    roles[DepartmentRole] = "department";
    roles[EmailRole] = "email";
    return roles;
}

int OrganizationTreeModel::nodeCount() const
{
    return countNodes(m_rootItem.get());
}

// addNode(): agrega un nuevo nodo al arbol.
//
// SECUENCIA OBLIGATORIA:
//   1. beginInsertRows(padre, fila_inicio, fila_fin)  ← notifica a las vistas
//   2. Modificar los datos internos (agregar el TreeItem)
//   3. endInsertRows()                                 ← confirma el cambio
//
// Sin begin/endInsertRows, las vistas no se enteran del nuevo nodo y pueden
// crashear o mostrar datos corruptos. Esta es una regla FUNDAMENTAL de
// QAbstractItemModel que se aplica a CUALQUIER modelo (listas, tablas, arboles).
bool OrganizationTreeModel::addNode(const QModelIndex &parentIndex,
                                     const QString &name, const QString &title,
                                     const QString &department, const QString &email)
{
    TreeItem *parentItem = itemForIndex(parentIndex);
    if (!parentItem)
        parentItem = m_rootItem.get();

    int row = parentItem->childCount();
    beginInsertRows(parentIndex, row, row);
    addPerson(parentItem, name, title, department, email);
    endInsertRows();

    emit nodeCountChanged();
    return true;
}

// removeNode(): elimina un nodo y todos sus descendientes.
// Misma secuencia obligatoria: beginRemoveRows → eliminar → endRemoveRows.
bool OrganizationTreeModel::removeNode(const QModelIndex &index)
{
    if (!index.isValid())
        return false;

    auto *item = static_cast<TreeItem *>(index.internalPointer());
    TreeItem *parentItem = item->parentItem();

    if (!parentItem)
        return false;

    QModelIndex parentIndex = parent(index);
    int row = item->row();

    beginRemoveRows(parentIndex, row, row);
    parentItem->removeChildren(row, 1);
    endRemoveRows();

    emit nodeCountChanged();
    return true;
}

// editNode(): actualiza todos los campos de un nodo de una vez.
// Emite dataChanged() con todos los roles afectados para que las vistas
// refresquen todos los campos del delegate, no solo uno.
bool OrganizationTreeModel::editNode(const QModelIndex &index,
                                      const QString &name, const QString &title,
                                      const QString &department, const QString &email)
{
    if (!index.isValid())
        return false;

    auto *item = static_cast<TreeItem *>(index.internalPointer());
    item->setData(0, name);
    item->setData(1, title);
    item->setData(2, department);
    item->setData(3, email);

    emit dataChanged(index, index,
                     {Qt::DisplayRole, NameRole, TitleRole,
                      DepartmentRole, EmailRole});
    return true;
}

QString OrganizationTreeModel::nameAt(const QModelIndex &index) const
{
    if (!index.isValid()) return {};
    return static_cast<TreeItem *>(index.internalPointer())->data(0).toString();
}

QString OrganizationTreeModel::titleAt(const QModelIndex &index) const
{
    if (!index.isValid()) return {};
    return static_cast<TreeItem *>(index.internalPointer())->data(1).toString();
}

QString OrganizationTreeModel::departmentAt(const QModelIndex &index) const
{
    if (!index.isValid()) return {};
    return static_cast<TreeItem *>(index.internalPointer())->data(2).toString();
}

QString OrganizationTreeModel::emailAt(const QModelIndex &index) const
{
    if (!index.isValid()) return {};
    return static_cast<TreeItem *>(index.internalPointer())->data(3).toString();
}

TreeItem *OrganizationTreeModel::addPerson(TreeItem *parent,
                                            const QString &name,
                                            const QString &title,
                                            const QString &department,
                                            const QString &email)
{
    auto item = std::make_unique<TreeItem>(
        QVariantList{name, title, department, email}, parent);
    TreeItem *ptr = item.get();
    parent->appendChild(std::move(item));
    return ptr;
}

TreeItem *OrganizationTreeModel::itemForIndex(const QModelIndex &index) const
{
    if (!index.isValid())
        return m_rootItem.get();
    return static_cast<TreeItem *>(index.internalPointer());
}

int OrganizationTreeModel::countNodes(TreeItem *item) const
{
    int count = 0;
    for (int i = 0; i < item->childCount(); ++i) {
        count++;
        count += countNodes(item->child(i));
    }
    return count;
}

void OrganizationTreeModel::populateData()
{
    TreeItem *root = m_rootItem.get();

    // CEO
    auto *ceo = addPerson(root, "Alice Johnson", "CEO",
                          "Executive", "alice@company.com");

    // CTO branch
    auto *cto = addPerson(ceo, "Bob Smith", "CTO",
                          "Technology", "bob@company.com");
    auto *leadDev = addPerson(cto, "Carol Williams", "Lead Developer",
                              "Technology", "carol@company.com");
    addPerson(leadDev, "Dave Brown", "Developer",
              "Technology", "dave@company.com");
    addPerson(leadDev, "Eve Davis", "Developer",
              "Technology", "eve@company.com");
    auto *devopsLead = addPerson(cto, "Frank Miller", "DevOps Lead",
                                 "Technology", "frank@company.com");
    addPerson(devopsLead, "Grace Wilson", "SRE",
              "Technology", "grace@company.com");

    // CFO branch
    auto *cfo = addPerson(ceo, "Henry Taylor", "CFO",
                          "Finance", "henry@company.com");
    addPerson(cfo, "Ivy Anderson", "Accountant",
              "Finance", "ivy@company.com");
    addPerson(cfo, "Jack Thomas", "Analyst",
              "Finance", "jack@company.com");

    // COO branch
    auto *coo = addPerson(ceo, "Karen Martinez", "COO",
                          "Operations", "karen@company.com");
    addPerson(coo, "Leo Robinson", "HR Manager",
              "Operations", "leo@company.com");
    addPerson(coo, "Mia Clark", "Office Manager",
              "Operations", "mia@company.com");
}
