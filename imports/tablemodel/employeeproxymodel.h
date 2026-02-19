// ============================================================================
// employeeproxymodel.h - Proxy para filtrar y ordenar el modelo de empleados
// ============================================================================
//
// QSortFilterProxyModel:
//   Envuelve OTRO modelo (el "source model") para agregar filtrado y
//   ordenamiento SIN MODIFICAR los datos originales. El proxy mantiene
//   un mapeo interno entre indices del source y indices filtrados/ordenados.
//
//   Ventajas:
//   - El modelo fuente no sabe que existe un proxy (desacoplado)
//   - Puedes tener multiples proxies sobre el mismo modelo fuente
//   - Los cambios en el source se propagan automaticamente al proxy
//   - Se puede apilar: Proxy1 -> Proxy2 -> SourceModel
//
// filterAcceptsRow():
//   Decide si una fila del modelo fuente debe ser VISIBLE o no.
//   Retorna true para mostrar la fila, false para ocultarla.
//   Se re-evalua automaticamente cuando:
//   - Cambia el texto de filtro (llamamos invalidateFilter())
//   - Cambian los datos del modelo fuente
//
// lessThan():
//   Compara dos filas para determinar el orden de clasificacion.
//   El proxy NO mueve datos en el modelo fuente — solo reordena su
//   mapeo interno de indices. sort() usa lessThan() internamente.
//
// Q_OBJECT + QML_ELEMENT:
//   Registra el proxy como tipo disponible en QML.
//   En QML:
//     EmployeeProxyModel {
//         sourceModel: employeeModel
//         filterText: searchField.text
//     }
// ============================================================================

#ifndef EMPLOYEEPROXYMODEL_H
#define EMPLOYEEPROXYMODEL_H

#include <QSortFilterProxyModel>
#include <QtQml/qqmlregistration.h>

class EmployeeProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    QML_ELEMENT

    // Propiedades expuestas a QML para binding reactivo.
    // filterText tiene WRITE, lo que permite que QML lo modifique:
    //   proxyModel.filterText = searchField.text
    Q_PROPERTY(int sortColumn READ sortColumn NOTIFY sortColumnChanged)
    Q_PROPERTY(Qt::SortOrder currentSortOrder READ currentSortOrder NOTIFY sortOrderChanged)
    Q_PROPERTY(QString filterText READ filterText WRITE setFilterText NOTIFY filterTextChanged)

public:
    explicit EmployeeProxyModel(QObject *parent = nullptr);

    int sortColumn() const;
    Qt::SortOrder currentSortOrder() const;
    QString filterText() const;
    void setFilterText(const QString &text);

    // toggleSort() se invoca desde QML cuando el usuario hace clic en
    // una cabecera de columna. Alterna entre ascendente y descendente.
    Q_INVOKABLE void toggleSort(int column);

signals:
    void sortColumnChanged();
    void sortOrderChanged();
    void filterTextChanged();

protected:
    // ─── Metodos sobreescritos del proxy ────────────────────────────
    // filterAcceptsRow: retorna true/false para mostrar/ocultar una fila.
    // lessThan: compara dos filas para ordenar (usado por sort()).
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;
    bool lessThan(const QModelIndex &left, const QModelIndex &right) const override;

private:
    int m_sortColumn = -1;
    Qt::SortOrder m_sortOrder = Qt::AscendingOrder;
    QString m_filterText;
};

#endif // EMPLOYEEPROXYMODEL_H
