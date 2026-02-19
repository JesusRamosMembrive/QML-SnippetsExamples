// =============================================================================
// SqlQueryModel - Wrapper de QSqlQueryModel con roleNames() para QML
// =============================================================================
//
// QSqlQueryModel (clase base de Qt):
//   Proporciona un modelo de SOLO LECTURA a partir de una consulta SQL
//   arbitraria (SELECT). A diferencia de QSqlTableModel (que se vincula
//   a una tabla), este acepta cualquier query: JOINs, subqueries, GROUP BY,
//   funciones agregadas (SUM, COUNT, AVG), etc.
//
// Mismo problema y solucion que SqlTableModel:
//   Qt expone datos con Qt::DisplayRole + indice de columna → no funciona
//   bien con QML. Este wrapper agrega roleNames() para mapear columnas
//   del resultado SQL a roles con nombre accesibles desde delegates QML.
//
// Diferencia clave con SqlTableModel:
//   - SqlTableModel: lectura/escritura, vinculado a UNA tabla
//   - SqlQueryModel: solo lectura, acepta CUALQUIER consulta SQL
//
// execQuery(): ejecuta una consulta SQL y regenera los roles automaticamente.
//   Cada vez que cambia la consulta, los nombres de columna pueden cambiar,
//   por eso se regeneran los roles despues de cada ejecucion.
// =============================================================================

#ifndef SQLQUERYMODEL_H
#define SQLQUERYMODEL_H

#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QtQml/qqmlregistration.h>

class SqlQueryModel : public QSqlQueryModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int rowCount READ rowCount NOTIFY queryChanged)
    Q_PROPERTY(QString lastError READ lastError NOTIFY queryChanged)

public:
    explicit SqlQueryModel(QObject *parent = nullptr);

    // Mismo patron que SqlTableModel: roleNames() + data() traducen roles
    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role) const override;

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QString lastError() const;

    // Ejecutar consulta SQL arbitraria desde QML
    Q_INVOKABLE void execQuery(const QString &sql,
                               const QString &connectionName);
    // Obtener una fila completa como mapa {columna: valor} — util para dialogos
    Q_INVOKABLE QVariantMap getRow(int row) const;
    Q_INVOKABLE int columnCount() const;
    Q_INVOKABLE QVariant headerName(int column) const;

signals:
    void queryChanged();

private:
    void generateRoleNames();

    QHash<int, QByteArray> m_roleNames;
    QString m_lastError;
};

#endif // SQLQUERYMODEL_H
