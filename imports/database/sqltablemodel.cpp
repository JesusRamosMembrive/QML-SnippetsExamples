// =============================================================================
// SqlTableModel - Implementacion del wrapper de QSqlTableModel para QML
// =============================================================================

#include "sqltablemodel.h"
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlField>

// Constructores: ambos configuran OnManualSubmit como estrategia de edicion.
// OnManualSubmit: los cambios NO se escriben a la BD automaticamente.
// El usuario debe llamar save() (submitAll) explicitamente para confirmar.
// Alternativas: OnFieldChange (guarda cada cambio inmediatamente),
//               OnRowChange (guarda al cambiar de fila).
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

// data(): traduce roles personalizados (>= Qt::UserRole) a columnas SQL.
//
// La formula: columna = rol - Qt::UserRole - 1
// Ejemplo: si la tabla tiene columnas [id, name, salary]:
//   Qt::UserRole + 1 → columna 0 (id)
//   Qt::UserRole + 2 → columna 1 (name)
//   Qt::UserRole + 3 → columna 2 (salary)
//
// Para roles estandar (< Qt::UserRole), delegamos a la implementacion base.
QVariant SqlTableModel::data(const QModelIndex &index, int role) const
{
    if (role < Qt::UserRole)
        return QSqlTableModel::data(index, role);

    int col = role - Qt::UserRole - 1;
    QModelIndex modelIndex = this->index(index.row(), col);
    return QSqlTableModel::data(modelIndex, Qt::DisplayRole);
}

// setData(): misma traduccion de rol → columna, pero para escritura.
// Despues de modificar, marca que hay cambios pendientes (hasChanges).
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

// addRecord(): agrega una fila nueva a partir de un mapa {campo: valor}.
// rec.setGenerated("id", false) indica que el campo "id" es auto-incremental
// y no debe incluirse en el INSERT — la BD lo genera automaticamente.
// insertRecord(-1, rec) inserta al final de la tabla.
bool SqlTableModel::addRecord(const QVariantMap &values)
{
    QSqlRecord rec = record();
    for (auto it = values.constBegin(); it != values.constEnd(); ++it)
        rec.setValue(it.key(), it.value());

    // No incluir el id auto-incremental en el INSERT
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

// save(): confirma todos los cambios pendientes a la BD (submitAll).
// revertChanges(): descarta todos los cambios pendientes (revertAll).
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

// setFilterString(): aplica un filtro SQL (clausula WHERE sin la palabra WHERE).
// Ejemplo: "department = 'Engineering'" filtra solo ingenieros.
void SqlTableModel::setFilterString(const QString &filter)
{
    setFilter(filter);
    select();
}

// setSortColumn(): ordena por una columna con direccion ascendente/descendente.
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

// generateRoleNames(): crea el mapeo de roles a partir del esquema de la tabla.
// Lee los nombres de columna de la tabla SQL y asigna a cada uno un rol
// numerico secuencial: Qt::UserRole + 1, Qt::UserRole + 2, etc.
// Esto permite que QML acceda a: model.id, model.name, model.salary, etc.
void SqlTableModel::generateRoleNames()
{
    m_roleNames.clear();
    m_roleNames[Qt::DisplayRole] = "display";
    for (int i = 0; i < record().count(); i++) {
        m_roleNames[Qt::UserRole + i + 1] = record().fieldName(i).toUtf8();
    }
}
