// =============================================================================
// DatabaseManager - Implementacion del gestor de base de datos SQLite
// =============================================================================

#include "databasemanager.h"
#include "sqltablemodel.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QUuid>

// Constructor: genera un nombre de conexion unico con UUID.
// Cada instancia de DatabaseManager tiene su propia conexion a la BD,
// evitando colisiones si se crean multiples instancias en QML.
DatabaseManager::DatabaseManager(QObject *parent)
    : QObject(parent)
    , m_connectionName(QUuid::createUuid().toString())
{
}

// Destructor: cierra la BD automaticamente al destruir el objeto.
// Esto garantiza que no queden conexiones abiertas "huerfanas".
DatabaseManager::~DatabaseManager()
{
    closeDatabase();
}

// openDatabase(): abre una BD SQLite en memoria.
// "QSQLITE" es el driver de Qt para SQLite.
// ":memory:" crea la BD en RAM (rapida, pero se pierde al cerrar).
// Para persistir datos, usar una ruta de archivo real, por ejemplo:
//   db.setDatabaseName(QStandardPaths::writableLocation(...) + "/app.db");
bool DatabaseManager::openDatabase()
{
    if (m_isOpen)
        return true;

    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE", m_connectionName);
    db.setDatabaseName(":memory:");

    if (!db.open()) {
        emit errorOccurred(db.lastError().text());
        return false;
    }

    m_isOpen = true;
    emit isOpenChanged();

    return createSampleData();
}

// closeDatabase(): cierre seguro en dos pasos.
// Paso 1: cerrar la conexion dentro de un scope {} para que el objeto
//   QSqlDatabase local se destruya antes de removeDatabase().
// Paso 2: removeDatabase() elimina la conexion del registro global de Qt.
// Si no hacemos esto en dos pasos, Qt emite un warning:
//   "QSqlDatabasePrivate::removeDatabase: connection '...' is still in use"
void DatabaseManager::closeDatabase()
{
    if (m_isOpen) {
        {
            QSqlDatabase db = QSqlDatabase::database(m_connectionName);
            db.close();
        }
        QSqlDatabase::removeDatabase(m_connectionName);
        m_isOpen = false;
        emit isOpenChanged();
    }
}

// createTableModel(): fabrica un SqlTableModel conectado a la BD y a una tabla.
// El modelo se crea como hijo de este DatabaseManager (parent = this),
// asi Qt lo destruye automaticamente cuando el manager se destruye.
SqlTableModel *DatabaseManager::createTableModel(const QString &tableName)
{
    QSqlDatabase db = QSqlDatabase::database(m_connectionName);
    auto *model = new SqlTableModel(db, this);
    model->setTable(tableName);
    model->select();
    return model;
}

// executeQuery(): ejecuta SQL arbitrario (CREATE, INSERT, UPDATE, DELETE).
// Para consultas SELECT que devuelven datos, usar SqlQueryModel en su lugar.
bool DatabaseManager::executeQuery(const QString &sql)
{
    QSqlDatabase db = QSqlDatabase::database(m_connectionName);
    QSqlQuery q(db);
    if (!q.exec(sql)) {
        emit errorOccurred(q.lastError().text());
        return false;
    }
    return true;
}

bool DatabaseManager::isOpen() const
{
    return m_isOpen;
}

QString DatabaseManager::connectionName() const
{
    return m_connectionName;
}

QSqlDatabase DatabaseManager::database() const
{
    return QSqlDatabase::database(m_connectionName);
}

bool DatabaseManager::createSampleData()
{
    QSqlDatabase db = QSqlDatabase::database(m_connectionName);
    QSqlQuery q(db);

    // Employees table
    if (!q.exec("CREATE TABLE employees ("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "name TEXT NOT NULL, "
                "department TEXT NOT NULL, "
                "salary REAL NOT NULL, "
                "hire_date TEXT NOT NULL, "
                "active INTEGER NOT NULL DEFAULT 1)")) {
        emit errorOccurred(q.lastError().text());
        return false;
    }

    const QStringList inserts = {
        "INSERT INTO employees (name, department, salary, hire_date, active) VALUES "
        "('Ana Garcia', 'Engineering', 75000, '2022-03-15', 1)",
        "INSERT INTO employees (name, department, salary, hire_date, active) VALUES "
        "('Carlos Lopez', 'Marketing', 62000, '2021-07-22', 1)",
        "INSERT INTO employees (name, department, salary, hire_date, active) VALUES "
        "('Maria Rodriguez', 'Engineering', 82000, '2020-01-10', 1)",
        "INSERT INTO employees (name, department, salary, hire_date, active) VALUES "
        "('Pedro Sanchez', 'Design', 58000, '2023-05-01', 1)",
        "INSERT INTO employees (name, department, salary, hire_date, active) VALUES "
        "('Laura Martinez', 'Marketing', 67000, '2022-11-08', 1)",
        "INSERT INTO employees (name, department, salary, hire_date, active) VALUES "
        "('Jose Fernandez', 'Engineering', 90000, '2019-06-30', 1)",
        "INSERT INTO employees (name, department, salary, hire_date, active) VALUES "
        "('Sofia Ruiz', 'Design', 55000, '2023-09-12', 1)",
        "INSERT INTO employees (name, department, salary, hire_date, active) VALUES "
        "('Miguel Torres', 'Management', 95000, '2018-04-20', 1)",
        "INSERT INTO employees (name, department, salary, hire_date, active) VALUES "
        "('Elena Diaz', 'Engineering', 78000, '2021-02-14', 1)",
        "INSERT INTO employees (name, department, salary, hire_date, active) VALUES "
        "('David Moreno', 'Marketing', 60000, '2023-01-05', 0)",
        "INSERT INTO employees (name, department, salary, hire_date, active) VALUES "
        "('Isabel Jimenez', 'Management', 88000, '2019-11-18', 1)",
        "INSERT INTO employees (name, department, salary, hire_date, active) VALUES "
        "('Pablo Navarro', 'Design', 63000, '2022-06-25', 1)"
    };

    for (const QString &sql : inserts) {
        if (!q.exec(sql)) {
            emit errorOccurred(q.lastError().text());
            return false;
        }
    }

    // Products table
    if (!q.exec("CREATE TABLE products ("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "name TEXT NOT NULL, "
                "category TEXT NOT NULL, "
                "price REAL NOT NULL, "
                "stock INTEGER NOT NULL)")) {
        emit errorOccurred(q.lastError().text());
        return false;
    }

    const QStringList productInserts = {
        "INSERT INTO products (name, category, price, stock) VALUES ('Laptop Pro 15', 'Electronics', 1299.99, 45)",
        "INSERT INTO products (name, category, price, stock) VALUES ('Wireless Mouse', 'Electronics', 29.99, 230)",
        "INSERT INTO products (name, category, price, stock) VALUES ('Desk Chair Ergo', 'Furniture', 449.00, 12)",
        "INSERT INTO products (name, category, price, stock) VALUES ('USB-C Hub', 'Electronics', 54.99, 180)",
        "INSERT INTO products (name, category, price, stock) VALUES ('Standing Desk', 'Furniture', 699.00, 8)",
        "INSERT INTO products (name, category, price, stock) VALUES ('Mechanical Keyboard', 'Electronics', 149.99, 95)",
        "INSERT INTO products (name, category, price, stock) VALUES ('Monitor 27\"', 'Electronics', 399.99, 32)",
        "INSERT INTO products (name, category, price, stock) VALUES ('Desk Lamp LED', 'Accessories', 34.99, 150)",
        "INSERT INTO products (name, category, price, stock) VALUES ('Cable Organizer', 'Accessories', 12.99, 400)",
        "INSERT INTO products (name, category, price, stock) VALUES ('Webcam HD', 'Electronics', 79.99, 67)"
    };

    for (const QString &sql : productInserts) {
        if (!q.exec(sql)) {
            emit errorOccurred(q.lastError().text());
            return false;
        }
    }

    return true;
}
