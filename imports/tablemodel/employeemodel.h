#ifndef EMPLOYEEMODEL_H
#define EMPLOYEEMODEL_H

#include <QAbstractTableModel>
#include <QtQml/qqmlregistration.h>

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

    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    enum Column { ColId = 0, ColName, ColDepartment, ColSalary, ColActive, ColumnCount };
    Q_ENUM(Column)

    explicit EmployeeModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    int count() const;

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
