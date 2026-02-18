#ifndef EMPLOYEEPROXYMODEL_H
#define EMPLOYEEPROXYMODEL_H

#include <QSortFilterProxyModel>
#include <QtQml/qqmlregistration.h>

class EmployeeProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int sortColumn READ sortColumn NOTIFY sortColumnChanged)
    Q_PROPERTY(Qt::SortOrder currentSortOrder READ currentSortOrder NOTIFY sortOrderChanged)
    Q_PROPERTY(QString filterText READ filterText WRITE setFilterText NOTIFY filterTextChanged)

public:
    explicit EmployeeProxyModel(QObject *parent = nullptr);

    int sortColumn() const;
    Qt::SortOrder currentSortOrder() const;
    QString filterText() const;
    void setFilterText(const QString &text);

    Q_INVOKABLE void toggleSort(int column);

signals:
    void sortColumnChanged();
    void sortOrderChanged();
    void filterTextChanged();

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;
    bool lessThan(const QModelIndex &left, const QModelIndex &right) const override;

private:
    int m_sortColumn = -1;
    Qt::SortOrder m_sortOrder = Qt::AscendingOrder;
    QString m_filterText;
};

#endif // EMPLOYEEPROXYMODEL_H
