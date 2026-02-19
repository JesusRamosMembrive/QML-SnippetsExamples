// =============================================================================
// FileSystemTreeModel - Modelo jerarquico de sistema de archivos (solo lectura)
// =============================================================================
//
// Hereda de QAbstractItemModel, que es la clase base de Qt para modelos
// jerarquicos (arboles). Es mas compleja que QAbstractListModel/TableModel
// porque debe manejar relaciones padre-hijo a traves de QModelIndex.
//
// QAbstractItemModel requiere implementar 5 metodos virtuales puros:
//   index()       — dado un padre + fila + columna, devuelve el indice del hijo
//   parent()      — dado un indice, devuelve el indice de su padre
//   rowCount()    — cuantos hijos tiene un nodo
//   columnCount() — cuantas columnas tiene el modelo
//   data()        — devuelve el dato para un indice y rol dados
//
// Concepto clave: createIndex(row, column, pointer)
//   Crea un QModelIndex que almacena internamente un puntero al TreeItem.
//   Asi es como el sistema de modelos de Qt navega el arbol — cada indice
//   lleva consigo un puntero a su nodo. Se recupera con internalPointer().
//
// roleNames() para acceso desde QML:
//   QML no puede acceder a columnas por indice numerico como C++.
//   roleNames() mapea enteros de rol a nombres de cadena ("fileName",
//   "isFolder", "fileSize") que los delegates de QML usan directamente:
//     Text { text: model.fileName }
//
// QML_ELEMENT: registra la clase para uso directo en QML como
//   FileSystemTreeModel { } dentro del import "treemodel".
// =============================================================================

#ifndef FILESYSTEMTREEMODEL_H
#define FILESYSTEMTREEMODEL_H

#include <QAbstractItemModel>
#include <QtQml/qqmlregistration.h>
#include "treeitem.h"

class FileSystemTreeModel : public QAbstractItemModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int totalNodes READ totalNodes CONSTANT)

public:
    // Roles personalizados: empiezan en Qt::UserRole + 1 para no colisionar
    // con los roles internos de Qt (DisplayRole, EditRole, etc.)
    enum Roles {
        FileNameRole = Qt::UserRole + 1,
        IsFolderRole,
        FileSizeRole
    };

    explicit FileSystemTreeModel(QObject *parent = nullptr);
    ~FileSystemTreeModel() override;

    // --- Los 5 metodos obligatorios de QAbstractItemModel ---
    QModelIndex index(int row, int column,
                      const QModelIndex &parent = QModelIndex()) const override;
    QModelIndex parent(const QModelIndex &index) const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index,
                  int role = Qt::DisplayRole) const override;

    // Mapeo de roles a nombres accesibles desde QML
    QHash<int, QByteArray> roleNames() const override;

    int totalNodes() const;

private:
    void populateData();
    TreeItem *addFolder(TreeItem *parent, const QString &name);
    TreeItem *addFile(TreeItem *parent, const QString &name,
                      const QString &size);

    // Nodo raiz invisible — nunca se muestra, pero es el padre de todos
    std::unique_ptr<TreeItem> m_rootItem;
    int m_totalNodes = 0;
};

#endif // FILESYSTEMTREEMODEL_H
