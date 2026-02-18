#include "treeitem.h"

TreeItem::TreeItem(const QVariantList &data, TreeItem *parent)
    : m_data(data)
    , m_parent(parent)
{
}

void TreeItem::appendChild(std::unique_ptr<TreeItem> child)
{
    m_children.push_back(std::move(child));
}

bool TreeItem::removeChildren(int row, int count)
{
    if (row < 0 || row + count > static_cast<int>(m_children.size()))
        return false;

    m_children.erase(m_children.begin() + row,
                     m_children.begin() + row + count);
    return true;
}

TreeItem *TreeItem::child(int row) const
{
    if (row < 0 || row >= static_cast<int>(m_children.size()))
        return nullptr;
    return m_children[row].get();
}

int TreeItem::childCount() const
{
    return static_cast<int>(m_children.size());
}

int TreeItem::columnCount() const
{
    return static_cast<int>(m_data.size());
}

QVariant TreeItem::data(int column) const
{
    if (column < 0 || column >= m_data.size())
        return {};
    return m_data[column];
}

bool TreeItem::setData(int column, const QVariant &value)
{
    if (column < 0 || column >= m_data.size())
        return false;
    m_data[column] = value;
    return true;
}

int TreeItem::row() const
{
    if (!m_parent)
        return 0;

    for (int i = 0; i < static_cast<int>(m_parent->m_children.size()); ++i) {
        if (m_parent->m_children[i].get() == this)
            return i;
    }
    return 0;
}

TreeItem *TreeItem::parentItem() const
{
    return m_parent;
}
