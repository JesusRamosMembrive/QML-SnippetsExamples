#include "employeemodel.h"

EmployeeModel::EmployeeModel(QObject *parent)
    : QAbstractTableModel(parent)
{
    populateSampleData();
}

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

    beginInsertRows(QModelIndex(), 0, names.size() - 1);
    for (int i = 0; i < names.size(); ++i) {
        m_employees.append({m_nextId++, names[i], departments[i],
                           salaries[i], actives[i]});
    }
    endInsertRows();
    emit countChanged();
}

int EmployeeModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_employees.size();
}

int EmployeeModel::columnCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : ColumnCount;
}

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

    emit dataChanged(index, index, {role});
    return true;
}

Qt::ItemFlags EmployeeModel::flags(const QModelIndex &index) const
{
    auto f = QAbstractTableModel::flags(index);
    if (index.isValid() && index.column() != ColId)
        f |= Qt::ItemIsEditable;
    return f;
}

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

void EmployeeModel::addEmployee(const QString &name, const QString &department,
                                 double salary, bool active)
{
    int row = m_employees.size();
    beginInsertRows(QModelIndex(), row, row);
    m_employees.append({m_nextId++, name, department, salary, active});
    endInsertRows();
    emit countChanged();
}

void EmployeeModel::removeEmployee(int row)
{
    if (row < 0 || row >= m_employees.size())
        return;

    beginRemoveRows(QModelIndex(), row, row);
    m_employees.removeAt(row);
    endRemoveRows();
    emit countChanged();
}
