#include "employeeproxymodel.h"

EmployeeProxyModel::EmployeeProxyModel(QObject *parent)
    : QSortFilterProxyModel(parent)
{
    setDynamicSortFilter(true);
}

int EmployeeProxyModel::sortColumn() const
{
    return m_sortColumn;
}

Qt::SortOrder EmployeeProxyModel::currentSortOrder() const
{
    return m_sortOrder;
}

QString EmployeeProxyModel::filterText() const
{
    return m_filterText;
}

void EmployeeProxyModel::setFilterText(const QString &text)
{
    if (m_filterText == text)
        return;
    m_filterText = text;
    invalidateFilter();
    emit filterTextChanged();
}

void EmployeeProxyModel::toggleSort(int column)
{
    if (m_sortColumn == column) {
        m_sortOrder = (m_sortOrder == Qt::AscendingOrder)
                          ? Qt::DescendingOrder
                          : Qt::AscendingOrder;
    } else {
        m_sortColumn = column;
        m_sortOrder = Qt::AscendingOrder;
    }

    sort(m_sortColumn, m_sortOrder);
    emit sortColumnChanged();
    emit sortOrderChanged();
}

bool EmployeeProxyModel::filterAcceptsRow(int sourceRow,
                                           const QModelIndex &sourceParent) const
{
    if (m_filterText.isEmpty())
        return true;

    auto model = sourceModel();
    // Check Name (column 1) and Department (column 2)
    QString name = model->data(model->index(sourceRow, 1, sourceParent)).toString();
    QString dept = model->data(model->index(sourceRow, 2, sourceParent)).toString();

    return name.contains(m_filterText, Qt::CaseInsensitive)
        || dept.contains(m_filterText, Qt::CaseInsensitive);
}

bool EmployeeProxyModel::lessThan(const QModelIndex &left,
                                   const QModelIndex &right) const
{
    QVariant leftData = sourceModel()->data(left);
    QVariant rightData = sourceModel()->data(right);

    // Compare based on actual type
    if (leftData.typeId() == QMetaType::Int)
        return leftData.toInt() < rightData.toInt();
    if (leftData.typeId() == QMetaType::Double)
        return leftData.toDouble() < rightData.toDouble();
    if (leftData.typeId() == QMetaType::Bool)
        return !leftData.toBool() && rightData.toBool();

    return QString::localeAwareCompare(leftData.toString(), rightData.toString()) < 0;
}
