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
    enum Roles {
        NameRole = Qt::UserRole + 1,
        TitleRole,
        DepartmentRole,
        EmailRole
    };
    Q_ENUM(Roles)

    explicit OrganizationTreeModel(QObject *parent = nullptr);
    ~OrganizationTreeModel() override;

    QModelIndex index(int row, int column,
                      const QModelIndex &parent = QModelIndex()) const override;
    QModelIndex parent(const QModelIndex &index) const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index,
                  int role = Qt::DisplayRole) const override;
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    QHash<int, QByteArray> roleNames() const override;

    int nodeCount() const;

    Q_INVOKABLE bool addNode(const QModelIndex &parentIndex,
                             const QString &name, const QString &title,
                             const QString &department, const QString &email);
    Q_INVOKABLE bool removeNode(const QModelIndex &index);
    Q_INVOKABLE bool editNode(const QModelIndex &index,
                              const QString &name, const QString &title,
                              const QString &department, const QString &email);

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
