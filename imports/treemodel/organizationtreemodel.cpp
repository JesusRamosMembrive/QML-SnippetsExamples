#include "organizationtreemodel.h"

OrganizationTreeModel::OrganizationTreeModel(QObject *parent)
    : QAbstractItemModel(parent)
    , m_rootItem(std::make_unique<TreeItem>(
          QVariantList{QString(), QString(), QString(), QString()}))
{
    populateData();
}

OrganizationTreeModel::~OrganizationTreeModel() = default;

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

QModelIndex OrganizationTreeModel::parent(const QModelIndex &index) const
{
    if (!index.isValid())
        return {};

    auto *childItem = static_cast<TreeItem *>(index.internalPointer());
    TreeItem *parentItem = childItem->parentItem();

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

Qt::ItemFlags OrganizationTreeModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEnabled | Qt::ItemIsSelectable | Qt::ItemIsEditable;
}

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
