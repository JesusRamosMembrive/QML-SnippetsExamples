#include "sqlquerymodel.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlField>

SqlQueryModel::SqlQueryModel(QObject *parent)
    : QSqlQueryModel(parent)
{
}

QHash<int, QByteArray> SqlQueryModel::roleNames() const
{
    return m_roleNames;
}

QVariant SqlQueryModel::data(const QModelIndex &index, int role) const
{
    if (role < Qt::UserRole)
        return QSqlQueryModel::data(index, role);

    int col = role - Qt::UserRole - 1;
    QModelIndex modelIndex = this->index(index.row(), col);
    return QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
}

int SqlQueryModel::rowCount(const QModelIndex &parent) const
{
    return QSqlQueryModel::rowCount(parent);
}

QString SqlQueryModel::lastError() const
{
    return m_lastError;
}

void SqlQueryModel::execQuery(const QString &sql,
                              const QString &connectionName)
{
    QSqlDatabase db = QSqlDatabase::database(connectionName);
    QSqlQuery query(db);

    if (!query.exec(sql)) {
        m_lastError = query.lastError().text();
        emit queryChanged();
        return;
    }

    m_lastError.clear();
    setQuery(std::move(query));
    generateRoleNames();
    emit queryChanged();
}

QVariantMap SqlQueryModel::getRow(int row) const
{
    QVariantMap map;
    QSqlRecord rec = record(row);
    for (int i = 0; i < rec.count(); i++)
        map[rec.fieldName(i)] = rec.value(i);
    return map;
}

int SqlQueryModel::columnCount() const
{
    return QSqlQueryModel::columnCount();
}

QVariant SqlQueryModel::headerName(int column) const
{
    return headerData(column, Qt::Horizontal, Qt::DisplayRole);
}

void SqlQueryModel::generateRoleNames()
{
    m_roleNames.clear();
    m_roleNames[Qt::DisplayRole] = "display";
    for (int i = 0; i < record().count(); i++) {
        m_roleNames[Qt::UserRole + i + 1] = record().fieldName(i).toUtf8();
    }
}
