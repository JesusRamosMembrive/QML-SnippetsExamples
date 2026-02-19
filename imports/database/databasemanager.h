// =============================================================================
// DatabaseManager - Gestor del ciclo de vida de la base de datos SQLite
// =============================================================================
//
// Gestiona la conexion a SQLite: abrir, ejecutar consultas, crear modelos
// y cerrar. Funciona como punto de entrada unico para todas las operaciones
// de base de datos desde QML.
//
// QSqlDatabase: la abstraccion de Qt para bases de datos relacionales.
//   Soporta multiples backends: SQLite, MySQL, PostgreSQL, ODBC, etc.
//   Se identifica cada conexion con un nombre unico (connectionName).
//   QSqlDatabase::addDatabase("QSQLITE", nombre) crea la conexion.
//   QSqlDatabase::database(nombre) recupera una conexion existente.
//
// En este ejemplo usamos ":memory:" como ruta de base de datos, lo que crea
// una BD SQLite en RAM (se pierde al cerrar la app). Para persistencia real,
// se usaria QStandardPaths::writableLocation() para obtener una ruta en disco
// donde la BD sobrevive entre ejecuciones.
//
// connectionName con UUID: cada DatabaseManager genera un nombre de conexion
//   unico con QUuid para evitar conflictos si hay multiples instancias.
//
// Patron de cierre seguro:
//   1. Cerrar la conexion (db.close()) dentro de un scope limitado
//   2. Fuera del scope, QSqlDatabase::removeDatabase() elimina la conexion
//   Esto evita warnings de "connection still in use" de Qt.
// =============================================================================

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

    // Metodos Q_INVOKABLE: invocables directamente desde QML
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

    // Nombre unico de conexion (UUID) para evitar conflictos entre instancias
    QString m_connectionName;
    bool m_isOpen = false;
};

#endif // DATABASEMANAGER_H
