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

    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role) const override;

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QString lastError() const;

    Q_INVOKABLE void execQuery(const QString &sql,
                               const QString &connectionName);
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
