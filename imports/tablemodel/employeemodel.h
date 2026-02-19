// ============================================================================
// employeemodel.h - Modelo de tabla para datos de empleados
// ============================================================================
//
// QAbstractTableModel:
//   Clase base de Qt para exponer datos tabulares (filas x columnas).
//   Es la base para cualquier tabla en QML (TableView) o widgets (QTableView).
//
//   Metodos OBLIGATORIOS a sobreescribir:
//     - rowCount()    : cuantas filas tiene la tabla
//     - columnCount() : cuantas columnas tiene la tabla
//     - data()        : devuelve el valor de una celda especifica
//     - roleNames()   : mapea IDs numericos a nombres de string para QML
//
//   Metodos OPCIONALES (para edicion):
//     - setData()     : modifica el valor de una celda
//     - flags()       : indica que celdas son editables
//     - headerData()  : nombres de columnas para cabeceras
//
// roleNames() — CRITICO PARA QML:
//   QML accede a los datos del modelo por NOMBRE, no por numero.
//   Por ejemplo: model.display, model.name, model.salary
//   roleNames() crea este mapeo: { 0: "display", 256: "name", 257: "salary" }
//   Sin roleNames(), QML NO PUEDE acceder a los datos del modelo.
//
// Q_OBJECT + QML_ELEMENT:
//   Q_OBJECT habilita el meta-object system (signals, slots, propiedades).
//   QML_ELEMENT registra la clase automaticamente en el modulo QML.
//
// Q_INVOKABLE:
//   Permite que QML llame a addEmployee() y removeEmployee() directamente.
// ============================================================================

#ifndef EMPLOYEEMODEL_H
#define EMPLOYEEMODEL_H

#include <QAbstractTableModel>
#include <QtQml/qqmlregistration.h>

// Estructura simple que representa un empleado.
// Se almacena en un QList<Employee> como datos internos del modelo.
struct Employee {
    int id;
    QString name;
    QString department;
    double salary;
    bool active;
};

class EmployeeModel : public QAbstractTableModel
{
    Q_OBJECT
    QML_ELEMENT

    // Propiedad count expuesta a QML para saber cuantos empleados hay.
    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    // ─── Enum de columnas ───────────────────────────────────────────
    // Define las columnas de la tabla como constantes con nombre.
    // Q_ENUM las registra en el meta-object system para usar desde QML:
    //   EmployeeModel.ColName, EmployeeModel.ColSalary, etc.
    // ColumnCount es un truco comun: siempre vale el numero total de columnas.
    enum Column { ColId = 0, ColName, ColDepartment, ColSalary, ColActive, ColumnCount };
    Q_ENUM(Column)

    explicit EmployeeModel(QObject *parent = nullptr);

    // ─── Metodos OBLIGATORIOS de QAbstractTableModel ────────────────
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    // ─── Metodos para edicion (OPCIONALES) ──────────────────────────
    // setData(): modifica una celda. Debe emitir dataChanged() al final.
    // flags(): devuelve Qt::ItemIsEditable para celdas editables.
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;

    // headerData(): nombres de columnas para cabeceras de tabla.
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

    // roleNames(): CRITICO. Mapea roles (int) a nombres (string) para QML.
    QHash<int, QByteArray> roleNames() const override;

    int count() const;

    // Metodos invocables desde QML para agregar/eliminar empleados.
    Q_INVOKABLE void addEmployee(const QString &name, const QString &department,
                                  double salary, bool active);
    Q_INVOKABLE void removeEmployee(int row);

signals:
    void countChanged();

private:
    void populateSampleData();
    QList<Employee> m_employees;
    int m_nextId = 1;
};

#endif // EMPLOYEEMODEL_H
