#ifndef TREEITEM_H
#define TREEITEM_H

#include <QVariantList>
#include <memory>
#include <vector>

class TreeItem
{
public:
    explicit TreeItem(const QVariantList &data, TreeItem *parent = nullptr);

    void appendChild(std::unique_ptr<TreeItem> child);
    bool removeChildren(int row, int count);

    TreeItem *child(int row) const;
    int childCount() const;
    int columnCount() const;
    QVariant data(int column) const;
    bool setData(int column, const QVariant &value);
    int row() const;
    TreeItem *parentItem() const;

private:
    std::vector<std::unique_ptr<TreeItem>> m_children;
    QVariantList m_data;
    TreeItem *m_parent = nullptr;
};

#endif // TREEITEM_H
