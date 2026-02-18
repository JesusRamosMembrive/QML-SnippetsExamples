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
    enum Roles {
        FileNameRole = Qt::UserRole + 1,
        IsFolderRole,
        FileSizeRole
    };

    explicit FileSystemTreeModel(QObject *parent = nullptr);
    ~FileSystemTreeModel() override;

    QModelIndex index(int row, int column,
                      const QModelIndex &parent = QModelIndex()) const override;
    QModelIndex parent(const QModelIndex &index) const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index,
                  int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    int totalNodes() const;

private:
    void populateData();
    TreeItem *addFolder(TreeItem *parent, const QString &name);
    TreeItem *addFile(TreeItem *parent, const QString &name,
                      const QString &size);

    std::unique_ptr<TreeItem> m_rootItem;
    int m_totalNodes = 0;
};

#endif // FILESYSTEMTREEMODEL_H
