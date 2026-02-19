// =============================================================================
// TreeItem - Implementacion del nodo generico del arbol
// =============================================================================

#include "treeitem.h"

// Constructor: inicializa los datos del nodo y el puntero al padre.
// El padre es opcional (nullptr para el nodo raiz invisible).
TreeItem::TreeItem(const QVariantList &data, TreeItem *parent)
    : m_data(data)
    , m_parent(parent)
{
}

// appendChild: agrega un hijo al final de la lista.
// std::move() transfiere el ownership del unique_ptr — despues de esto,
// el unique_ptr original queda vacio y el vector es el nuevo dueno.
void TreeItem::appendChild(std::unique_ptr<TreeItem> child)
{
    m_children.push_back(std::move(child));
}

// removeChildren: elimina 'count' hijos a partir de la fila 'row'.
// Al borrar unique_ptrs del vector, los TreeItem apuntados se destruyen
// automaticamente (junto con todos sus hijos — destruccion en cascada).
bool TreeItem::removeChildren(int row, int count)
{
    if (row < 0 || row + count > static_cast<int>(m_children.size()))
        return false;

    m_children.erase(m_children.begin() + row,
                     m_children.begin() + row + count);
    return true;
}

// child: devuelve puntero raw al hijo en la posicion 'row'.
// Usamos .get() para obtener el puntero raw desde el unique_ptr.
// El ownership NO se transfiere — el vector sigue siendo el dueno.
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

// data/setData: acceso a las columnas del nodo por indice.
// Columna 0 podria ser "nombre", columna 1 "cargo", etc.
// El significado de cada columna depende del modelo que use este TreeItem.
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

// row: devuelve la posicion (fila) de este nodo dentro de los hijos de su padre.
// Esto es necesario para que QAbstractItemModel pueda construir QModelIndex
// correctos. Busca "this" en la lista de hijos del padre comparando punteros.
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
