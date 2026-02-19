// =============================================================================
// OrganizationTreeModel - Modelo jerarquico interactivo (lectura/escritura)
// =============================================================================
//
// Similar a FileSystemTreeModel pero con capacidad de modificacion:
//   - setData(): permite editar campos individuales de un nodo
//   - addNode(): agrega nuevos nodos al arbol (empleados en el organigrama)
//   - removeNode(): elimina nodos y todos sus descendientes
//   - editNode(): actualiza todos los campos de un nodo de una vez
//
// Diferencias clave con FileSystemTreeModel:
//   - Implementa setData() y flags() para habilitar edicion
//   - Usa beginInsertRows/endInsertRows y beginRemoveRows/endRemoveRows
//   - Los metodos Q_INVOKABLE permiten llamarlos desde QML
//
// Sobre beginInsertRows/endInsertRows y beginRemoveRows/endRemoveRows:
//   Son OBLIGATORIOS antes/despues de modificar la estructura del modelo.
//   Sin ellos, las vistas (TreeView, ListView) no se enteran del cambio y:
//     - Pueden mostrar datos obsoletos
//     - Pueden crashear al acceder a indices invalidos
//     - Las animaciones de insercion/remocion no se disparan
//   La secuencia siempre es: begin...() → modificar datos → end...()
//
// Q_ENUM(Roles): registra el enum en el meta-object system de Qt,
//   permitiendo usarlo en QML y en depuracion (toString automatico).
//
// Q_INVOKABLE: hace que el metodo sea invocable desde QML.
//   Sin Q_INVOKABLE, QML no puede llamar a metodos C++ directamente.
// =============================================================================

#ifndef ORGANIZATIONTREEMODEL_H
#define ORGANIZATIONTREEMODEL_H

#include <QAbstractItemModel>
#include <QtQml/qqmlregistration.h>
#include "treeitem.h"

class OrganizationTreeModel : public QAbstractItemModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int nodeCount READ nodeCount NOTIFY nodeCountChanged)

public:
    // Roles personalizados para cada campo del organigrama
    enum Roles {
        NameRole = Qt::UserRole + 1,
        TitleRole,
        DepartmentRole,
        EmailRole
    };
    Q_ENUM(Roles)

    explicit OrganizationTreeModel(QObject *parent = nullptr);
    ~OrganizationTreeModel() override;

    // --- Metodos obligatorios de QAbstractItemModel (igual que FileSystemTreeModel) ---
    QModelIndex index(int row, int column,
                      const QModelIndex &parent = QModelIndex()) const override;
    QModelIndex parent(const QModelIndex &index) const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index,
                  int role = Qt::DisplayRole) const override;

    // --- Metodos adicionales para habilitar edicion ---
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;

    QHash<int, QByteArray> roleNames() const override;

    int nodeCount() const;

    // --- Operaciones CRUD invocables desde QML ---
    Q_INVOKABLE bool addNode(const QModelIndex &parentIndex,
                             const QString &name, const QString &title,
                             const QString &department, const QString &email);
    Q_INVOKABLE bool removeNode(const QModelIndex &index);
    Q_INVOKABLE bool editNode(const QModelIndex &index,
                              const QString &name, const QString &title,
                              const QString &department, const QString &email);

    // Helpers de lectura para acceder a campos individuales desde QML
    Q_INVOKABLE QString nameAt(const QModelIndex &index) const;
    Q_INVOKABLE QString titleAt(const QModelIndex &index) const;
    Q_INVOKABLE QString departmentAt(const QModelIndex &index) const;
    Q_INVOKABLE QString emailAt(const QModelIndex &index) const;

signals:
    void nodeCountChanged();

private:
    void populateData();
    TreeItem *addPerson(TreeItem *parent, const QString &name,
                        const QString &title, const QString &department,
                        const QString &email);
    TreeItem *itemForIndex(const QModelIndex &index) const;
    int countNodes(TreeItem *item) const;

    std::unique_ptr<TreeItem> m_rootItem;
};

#endif // ORGANIZATIONTREEMODEL_H
