#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QtQml/qqmlregistration.h>
#include "sqltablemodel.h"

class DatabaseManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(bool isOpen READ isOpen NOTIFY isOpenChanged)
    Q_PROPERTY(QString connectionName READ connectionName CONSTANT)

public:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager() override;

    Q_INVOKABLE bool openDatabase();
    Q_INVOKABLE void closeDatabase();
    Q_INVOKABLE bool executeQuery(const QString &sql);
    Q_INVOKABLE SqlTableModel *createTableModel(const QString &tableName);

    bool isOpen() const;
    QString connectionName() const;
    QSqlDatabase database() const;

signals:
    void isOpenChanged();
    void errorOccurred(const QString &error);

private:
    bool createSampleData();

    QString m_connectionName;
    bool m_isOpen = false;
};

#endif // DATABASEMANAGER_H
