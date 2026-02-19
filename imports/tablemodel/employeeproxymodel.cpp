// ============================================================================
// employeeproxymodel.cpp - Implementacion del proxy de filtrado y ordenamiento
// ============================================================================
//
// Este proxy envuelve el EmployeeModel y proporciona:
//   1. FILTRADO: busqueda por texto en columnas Name y Department
//   2. ORDENAMIENTO: por cualquier columna, ascendente/descendente
//
// El modelo fuente (EmployeeModel) NO se modifica. El proxy mantiene
// un mapeo interno: "fila visible N del proxy" -> "fila M del source".
//
// setDynamicSortFilter(true):
//   Cuando el source model cambia (agrega/elimina/edita filas),
//   el proxy re-evalua automaticamente filterAcceptsRow() y reordena.
//   Sin esto, tendrias que llamar invalidateFilter() manualmente
//   despues de cada cambio en el source.
// ============================================================================

#include "employeeproxymodel.h"

EmployeeProxyModel::EmployeeProxyModel(QObject *parent)
    : QSortFilterProxyModel(parent)
{
    // Activar filtro dinamico: el proxy se re-evalua cuando el source cambia.
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

// setFilterText() se llama desde QML cuando el usuario escribe en el campo
// de busqueda. invalidateFilter() fuerza al proxy a re-evaluar
// filterAcceptsRow() para TODAS las filas, mostrando/ocultando filas
// segun el nuevo texto.
void EmployeeProxyModel::setFilterText(const QString &text)
{
    if (m_filterText == text)
        return;
    m_filterText = text;
    // invalidateFilter(): le dice al proxy "tu filtro cambio, re-evalua todo".
    // Internamente llama filterAcceptsRow() para cada fila del source.
    invalidateFilter();
    emit filterTextChanged();
}

// toggleSort(): se invoca desde QML al hacer clic en una cabecera.
// Si se hace clic en la misma columna, alterna el orden.
// Si es otra columna, ordena ascendente por defecto.
//
// sort() aplica el ordenamiento usando lessThan() para comparar filas.
// El proxy NO mueve datos en el source — solo reordena su mapeo interno.
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

// ============================================================================
// filterAcceptsRow() — Decide si una fila es visible
// ============================================================================
// Se llama para cada fila del modelo fuente. Retorna:
//   true  -> la fila se muestra en el proxy (pasa el filtro)
//   false -> la fila se oculta
//
// Aqui filtramos buscando el texto en las columnas Name (1) y Department (2).
// La busqueda es case-insensitive (Qt::CaseInsensitive).
//
// sourceModel(): devuelve un puntero al modelo fuente (EmployeeModel).
// Accedemos a sus datos via data() con indices del SOURCE, no del proxy.

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

// ============================================================================
// lessThan() — Compara dos filas para ordenar
// ============================================================================
// sort() usa este metodo internamente para determinar el orden.
// Recibe dos QModelIndex del SOURCE model (no del proxy).
//
// Comparamos segun el tipo real del dato:
//   - Int: comparacion numerica (para columna Id)
//   - Double: comparacion numerica (para columna Salary)
//   - Bool: false < true (para columna Active)
//   - QString: comparacion locale-aware (para Name, Department)
//
// El proxy no mueve datos en el source. Solo reordena su tabla de mapeo:
//   proxyRow 0 -> sourceRow 5
//   proxyRow 1 -> sourceRow 2
//   proxyRow 2 -> sourceRow 8
//   ...

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
