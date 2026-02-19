// =============================================================================
// SqlQueryModel - Implementacion del wrapper de QSqlQueryModel para QML
// =============================================================================

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

// data(): traduce roles personalizados a columnas del resultado SQL.
// Misma formula que SqlTableModel: columna = rol - Qt::UserRole - 1.
// Para roles estandar, delega a la implementacion base de QSqlQueryModel.
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

// execQuery(): ejecuta una consulta SQL y reconfigura el modelo.
// Flujo:
//   1. Obtener la conexion por nombre
//   2. Ejecutar la consulta con QSqlQuery
//   3. Si falla, guardar el error y notificar
//   4. Si tiene exito, pasar el query al modelo base con setQuery()
//   5. Regenerar roleNames() (los nombres de columna pueden haber cambiado)
//   6. Emitir queryChanged() para que QML actualice bindings
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

// getRow(): devuelve una fila completa como QVariantMap {nombreColumna: valor}.
// Util para mostrar datos en dialogos de detalle o formularios de edicion
// donde se necesitan todos los campos de una vez.
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

// generateRoleNames(): mismo patron que SqlTableModel.
// Lee los nombres de columna del resultado SQL y crea roles numericos:
//   Qt::UserRole + 1 → primera columna del SELECT
//   Qt::UserRole + 2 → segunda columna, etc.
// Ejemplo: "SELECT name, SUM(salary) as total FROM employees GROUP BY name"
//   genera roles: "name" y "total" accesibles desde QML.
void SqlQueryModel::generateRoleNames()
{
    m_roleNames.clear();
    m_roleNames[Qt::DisplayRole] = "display";
    for (int i = 0; i < record().count(); i++) {
        m_roleNames[Qt::UserRole + i + 1] = record().fieldName(i).toUtf8();
    }
}
