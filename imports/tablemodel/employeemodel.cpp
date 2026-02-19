// ============================================================================
// employeemodel.cpp - Implementacion del modelo de tabla de empleados
// ============================================================================
//
// Este archivo implementa los metodos obligatorios de QAbstractTableModel.
//
// CONCEPTOS CLAVE:
//
// data() — El corazon del modelo:
//   Recibe un QModelIndex (fila + columna) y un role (tipo de dato pedido).
//   Devuelve el valor como QVariant (tipo generico que envuelve int, string, etc.).
//   El role indica QUE tipo de informacion se pide:
//     - Qt::DisplayRole: valor para mostrar (el mas comun)
//     - Qt::EditRole:    valor para edicion (puede ser igual a DisplayRole)
//     - Roles custom (Qt::UserRole + N): para datos adicionales
//
// roleNames() — El puente entre C++ y QML:
//   QML no conoce los numeros de role. Necesita nombres de string.
//   roleNames() devuelve un QHash que mapea: numero de role -> nombre string.
//   Ejemplo: { Qt::DisplayRole -> "display", Qt::EditRole -> "edit" }
//   En QML, model.display accede al Qt::DisplayRole de la celda.
//
// begin/endInsertRows() y begin/endRemoveRows():
//   OBLIGATORIO llamar ANTES y DESPUES de modificar los datos internos.
//   Qt usa estas llamadas para notificar a las vistas (TableView, ListView)
//   que deben actualizar su contenido. Sin ellas, la vista no se entera
//   de los cambios y se desincroniza del modelo.
//
// dataChanged():
//   Signal que se emite cuando el valor de una celda existente cambia.
//   Las vistas la reciben y actualizan solo esa celda (eficiente).
// ============================================================================

#include "employeemodel.h"

EmployeeModel::EmployeeModel(QObject *parent)
    : QAbstractTableModel(parent)
{
    populateSampleData();
}

// Llena el modelo con datos de ejemplo para que la tabla no este vacia.
// Usa beginInsertRows/endInsertRows para notificar correctamente.
void EmployeeModel::populateSampleData()
{
    const QStringList names = {
        "Alice Johnson", "Bob Smith", "Carol White", "David Brown",
        "Eva Martinez", "Frank Wilson", "Grace Lee", "Henry Taylor",
        "Irene Davis", "Jack Anderson", "Karen Thomas", "Leo Garcia",
        "Maria Lopez", "Nathan Clark", "Olivia Moore"
    };
    const QStringList departments = {
        "Engineering", "Design", "Marketing", "Sales", "HR",
        "Engineering", "Engineering", "Design", "Marketing", "Sales",
        "HR", "Engineering", "Design", "Marketing", "Engineering"
    };
    const QList<double> salaries = {
        95000, 72000, 68000, 81000, 65000,
        105000, 88000, 74000, 71000, 78000,
        62000, 112000, 69000, 73000, 98000
    };
    const QList<bool> actives = {
        true, true, false, true, true,
        true, false, true, true, false,
        true, true, true, false, true
    };

    // beginInsertRows(): notifica a las vistas que se van a insertar filas.
    // Parametros: parent (QModelIndex() = raiz), fila inicio, fila fin.
    // DEBE llamarse ANTES de modificar m_employees.
    beginInsertRows(QModelIndex(), 0, names.size() - 1);
    for (int i = 0; i < names.size(); ++i) {
        m_employees.append({m_nextId++, names[i], departments[i],
                           salaries[i], actives[i]});
    }
    // endInsertRows(): confirma que la insercion termino.
    // Las vistas actualizan su contenido al recibir esta notificacion.
    endInsertRows();
    emit countChanged();
}

// ─── rowCount / columnCount ─────────────────────────────────────────
// Para modelos de tabla plana (sin jerarquia), parent.isValid() es false
// en la raiz. Si parent es valido, significa que alguien pide hijos de
// una celda, lo cual no aplica en tablas planas -> devolvemos 0.

int EmployeeModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_employees.size();
}

int EmployeeModel::columnCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : ColumnCount;
}

// ─── data() — Devuelve el valor de una celda ────────────────────────
// Parametros:
//   index: QModelIndex con fila (index.row()) y columna (index.column())
//   role:  que tipo de dato se pide (DisplayRole, EditRole, etc.)
//
// Qt::DisplayRole: el rol por defecto que las vistas usan para mostrar texto.
// Qt::EditRole: el valor para edicion (aqui lo tratamos igual que DisplayRole).
//
// QVariant: tipo generico de Qt que puede contener int, QString, double, bool, etc.
// data() devuelve QVariant porque cada celda puede tener un tipo diferente.

QVariant EmployeeModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_employees.size())
        return {};

    const auto &emp = m_employees[index.row()];

    if (role == Qt::DisplayRole || role == Qt::EditRole) {
        switch (index.column()) {
        case ColId:         return emp.id;
        case ColName:       return emp.name;
        case ColDepartment: return emp.department;
        case ColSalary:     return emp.salary;
        case ColActive:     return emp.active;
        }
    }

    return {};
}

// ─── setData() — Modifica el valor de una celda ─────────────────────
// Se llama cuando QML (o una vista) quiere editar una celda.
// Solo acepta Qt::EditRole (rol de edicion).
// Despues de modificar, emite dataChanged() para que las vistas se actualicen.
// Devuelve true si la edicion fue exitosa, false si no.

bool EmployeeModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid() || role != Qt::EditRole || index.row() >= m_employees.size())
        return false;

    auto &emp = m_employees[index.row()];

    switch (index.column()) {
    case ColName:
        emp.name = value.toString();
        break;
    case ColDepartment:
        emp.department = value.toString();
        break;
    case ColSalary:
        emp.salary = value.toDouble();
        break;
    case ColActive:
        emp.active = value.toBool();
        break;
    default:
        return false;
    }

    // dataChanged() notifica a las vistas que esta celda cambio.
    // Parametros: esquina superior izq, esquina inferior der, roles afectados.
    // Aqui solo cambio una celda, asi que ambas esquinas son el mismo index.
    emit dataChanged(index, index, {role});
    return true;
}

// ─── flags() — Indica que celdas son editables ─────────────────────
// Qt::ItemIsEditable habilita la edicion para una celda.
// Aqui todas las columnas son editables EXCEPTO ColId (el ID es auto-generado).
// Sin este flag, setData() nunca se llama para esa celda.

Qt::ItemFlags EmployeeModel::flags(const QModelIndex &index) const
{
    auto f = QAbstractTableModel::flags(index);
    if (index.isValid() && index.column() != ColId)
        f |= Qt::ItemIsEditable;
    return f;
}

// ─── headerData() — Nombres de columnas ─────────────────────────────
// Devuelve el texto de cabecera para cada columna.
// Solo respondemos a Qt::DisplayRole y orientacion Horizontal.

QVariant EmployeeModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role != Qt::DisplayRole || orientation != Qt::Horizontal)
        return {};

    switch (section) {
    case ColId:         return QStringLiteral("Id");
    case ColName:       return QStringLiteral("Name");
    case ColDepartment: return QStringLiteral("Department");
    case ColSalary:     return QStringLiteral("Salary");
    case ColActive:     return QStringLiteral("Active");
    }
    return {};
}

// ─── roleNames() — PUENTE CRITICO entre C++ y QML ──────────────────
// QML accede a los datos del modelo usando nombres de string, no numeros.
// Este metodo devuelve el mapeo: numero de role -> nombre string.
//
// Aqui mapeamos:
//   Qt::DisplayRole (valor 0) -> "display"  -> en QML: model.display
//   Qt::EditRole    (valor 2) -> "edit"      -> en QML: model.edit
//
// En TableView, QML usa model.display para mostrar el valor de cada celda.
// Si este metodo no existiera o devolviera un hash vacio, QML no podria
// acceder a NINGUN dato del modelo.
//
// Nota: tambien se pueden definir roles personalizados:
//   enum Roles { NameRole = Qt::UserRole + 1, SalaryRole, ... };
//   y mapearlos: { NameRole -> "name", SalaryRole -> "salary" }
//   Esto permite acceder por nombre de campo: model.name, model.salary

QHash<int, QByteArray> EmployeeModel::roleNames() const
{
    return {
        {Qt::DisplayRole, "display"},
        {Qt::EditRole, "edit"}
    };
}

int EmployeeModel::count() const
{
    return m_employees.size();
}

// ─── addEmployee() — Agregar un empleado ────────────────────────────
// Invocable desde QML via Q_INVOKABLE.
// beginInsertRows/endInsertRows notifica a TODAS las vistas conectadas
// (incluyendo proxies) que se inserto una fila nueva.

void EmployeeModel::addEmployee(const QString &name, const QString &department,
                                 double salary, bool active)
{
    int row = m_employees.size();
    beginInsertRows(QModelIndex(), row, row);
    m_employees.append({m_nextId++, name, department, salary, active});
    endInsertRows();
    emit countChanged();
}

// ─── removeEmployee() — Eliminar un empleado ────────────────────────
// Mismo patron: beginRemoveRows/endRemoveRows envuelve la eliminacion.

void EmployeeModel::removeEmployee(int row)
{
    if (row < 0 || row >= m_employees.size())
        return;

    beginRemoveRows(QModelIndex(), row, row);
    m_employees.removeAt(row);
    endRemoveRows();
    emit countChanged();
}
