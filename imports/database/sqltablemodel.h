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

    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role) const override;
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    bool hasChanges() const;

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
    void generateRoleNames();

    QHash<int, QByteArray> m_roleNames;
    bool m_hasChanges = false;
};

#endif // SQLTABLEMODEL_H
