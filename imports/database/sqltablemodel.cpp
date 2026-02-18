#include "sqltablemodel.h"
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlField>

SqlTableModel::SqlTableModel(QObject *parent)
    : QSqlTableModel(parent)
{
    setEditStrategy(QSqlTableModel::OnManualSubmit);
}

SqlTableModel::SqlTableModel(const QSqlDatabase &db, QObject *parent)
    : QSqlTableModel(parent, db)
{
    setEditStrategy(QSqlTableModel::OnManualSubmit);
}

QHash<int, QByteArray> SqlTableModel::roleNames() const
{
    return m_roleNames;
}

QVariant SqlTableModel::data(const QModelIndex &index, int role) const
{
    if (role < Qt::UserRole)
        return QSqlTableModel::data(index, role);

    int col = role - Qt::UserRole - 1;
    QModelIndex modelIndex = this->index(index.row(), col);
    return QSqlTableModel::data(modelIndex, Qt::DisplayRole);
}

bool SqlTableModel::setData(const QModelIndex &index,
                             const QVariant &value, int role)
{
    if (role < Qt::UserRole)
        return QSqlTableModel::setData(index, value, role);

    int col = role - Qt::UserRole - 1;
    QModelIndex modelIndex = this->index(index.row(), col);
    bool ok = QSqlTableModel::setData(modelIndex, value, Qt::EditRole);
    if (ok) {
        m_hasChanges = true;
        emit hasChangesChanged();
    }
    return ok;
}

bool SqlTableModel::hasChanges() const
{
    return m_hasChanges;
}

void SqlTableModel::setup(const QString &connectionName,
                           const QString &tableName)
{
    Q_UNUSED(connectionName)
    setTable(tableName);
    select();
    generateRoleNames();
}

void SqlTableModel::refresh()
{
    select();
    generateRoleNames();
}

bool SqlTableModel::addRecord(const QVariantMap &values)
{
    QSqlRecord rec = record();
    for (auto it = values.constBegin(); it != values.constEnd(); ++it)
        rec.setValue(it.key(), it.value());

    // Don't set the auto-increment id
    rec.setGenerated("id", false);

    bool ok = insertRecord(-1, rec);
    if (ok) {
        m_hasChanges = true;
        emit hasChangesChanged();
    }
    return ok;
}

bool SqlTableModel::deleteRecord(int row)
{
    bool ok = removeRow(row);
    if (ok) {
        m_hasChanges = true;
        emit hasChangesChanged();
    }
    return ok;
}

bool SqlTableModel::updateField(int row, const QString &fieldName,
                                 const QVariant &value)
{
    int col = fieldIndex(fieldName);
    if (col < 0) return false;

    QModelIndex idx = index(row, col);
    bool ok = QSqlTableModel::setData(idx, value, Qt::EditRole);
    if (ok) {
        m_hasChanges = true;
        emit hasChangesChanged();
    }
    return ok;
}

bool SqlTableModel::save()
{
    bool ok = submitAll();
    if (ok) {
        m_hasChanges = false;
        emit hasChangesChanged();
    }
    return ok;
}

void SqlTableModel::revertChanges()
{
    revertAll();
    m_hasChanges = false;
    emit hasChangesChanged();
}

void SqlTableModel::setFilterString(const QString &filter)
{
    setFilter(filter);
    select();
}

void SqlTableModel::setSortColumn(int column, bool ascending)
{
    setSort(column, ascending ? Qt::AscendingOrder : Qt::DescendingOrder);
    select();
}

QVariant SqlTableModel::headerName(int column) const
{
    return headerData(column, Qt::Horizontal, Qt::DisplayRole);
}

int SqlTableModel::columnCount() const
{
    return QSqlTableModel::columnCount();
}

void SqlTableModel::generateRoleNames()
{
    m_roleNames.clear();
    m_roleNames[Qt::DisplayRole] = "display";
    for (int i = 0; i < record().count(); i++) {
        m_roleNames[Qt::UserRole + i + 1] = record().fieldName(i).toUtf8();
    }
}
