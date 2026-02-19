// =============================================================================
// SqlTableModel - Wrapper de QSqlTableModel con roleNames() para QML
// =============================================================================
//
// QSqlTableModel (clase base de Qt):
//   Proporciona un modelo lectura/escritura respaldado por UNA tabla SQL.
//   Los cambios pueden ser auto-confirmados o por lotes (OnManualSubmit).
//   Soporta filtrado (WHERE), ordenamiento (ORDER BY), y edicion (INSERT,
//   UPDATE, DELETE) a traves de la API del modelo.
//
// Problema con QML:
//   QSqlTableModel expone datos con Qt::DisplayRole + indice de columna.
//   En C++: model->data(model->index(0, 2)) → devuelve columna 2 de fila 0.
//   Pero en QML, los delegates esperan roles con nombre:
//     Text { text: model.salary }     // Esto necesita roleNames()
//     Text { text: model.display }    // Solo da la columna 0
//
// Solucion: este wrapper sobreescribe roleNames() para mapear cada columna
//   SQL a un rol con nombre. Columna "name" → rol "name", columna "salary"
//   → rol "salary", etc. Asi QML puede acceder a cualquier columna por nombre.
//
// Estrategia de edicion: OnManualSubmit
//   Los cambios se acumulan en un buffer interno. No se escriben a la BD
//   hasta llamar save() (submitAll). revertChanges() descarta todo.
//   Esto permite al usuario revisar cambios antes de confirmarlos.
// =============================================================================

#ifndef SQLTABLEMODEL_H
#define SQLTABLEMODEL_H

#include <QSqlTableModel>
#include <QSqlRecord>
#include <QtQml/qqmlregistration.h>

class SqlTableModel : public QSqlTableModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(bool hasChanges READ hasChanges NOTIFY hasChangesChanged)

public:
    explicit SqlTableModel(QObject *parent = nullptr);
    explicit SqlTableModel(const QSqlDatabase &db, QObject *parent = nullptr);

    // Sobreescrituras clave: roleNames() para QML, data/setData para traducir roles
    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role) const override;
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    bool hasChanges() const;

    // Operaciones CRUD invocables desde QML
    Q_INVOKABLE void setup(const QString &connectionName,
                           const QString &tableName);
    Q_INVOKABLE void refresh();
    Q_INVOKABLE bool addRecord(const QVariantMap &values);
    Q_INVOKABLE bool deleteRecord(int row);
    Q_INVOKABLE bool updateField(int row, const QString &fieldName,
                                 const QVariant &value);
    Q_INVOKABLE bool save();
    Q_INVOKABLE void revertChanges();
    Q_INVOKABLE void setFilterString(const QString &filter);
    Q_INVOKABLE void setSortColumn(int column, bool ascending);

    Q_INVOKABLE QVariant headerName(int column) const;
    Q_INVOKABLE int columnCount() const;

signals:
    void hasChangesChanged();

private:
    // Genera el mapa de roles a partir de los nombres de columna de la tabla SQL
    void generateRoleNames();

    QHash<int, QByteArray> m_roleNames;
    bool m_hasChanges = false;
};

#endif // SQLTABLEMODEL_H
