// =============================================================================
// TreeItem - Nodo generico de datos para modelos de arbol
// =============================================================================
//
// TreeItem es el "ladrillo" fundamental de cualquier modelo jerarquico.
// Cada nodo contiene:
//   1. Un puntero al padre (m_parent) — para navegar hacia arriba en el arbol
//   2. Una lista de hijos (m_children) — para navegar hacia abajo
//   3. Datos por columna (m_data) — QVariantList que almacena N columnas
//
// GOTCHA IMPORTANTE sobre m_children:
//   Usamos std::vector<std::unique_ptr<TreeItem>> en vez de QVector/QList.
//   Esto es porque QVector y QList REQUIEREN que el tipo sea copiable (copyable),
//   y std::unique_ptr NO es copiable (solo movible). Si intentas usar
//   QVector<std::unique_ptr<T>>, el compilador dara errores crípticos.
//   Este es un gotcha comun de C++/Qt que confunde a muchos desarrolladores.
//
//   unique_ptr garantiza que cada TreeItem tiene UN solo dueno: su padre.
//   Cuando el padre se destruye, todos los hijos se destruyen automaticamente
//   (destruccion en cascada), evitando memory leaks.
//
// Metodos clave:
//   appendChild() — agrega un hijo al final (transfiere ownership via std::move)
//   removeChildren() — elimina N hijos desde una posicion (erase del vector)
//   child(row) — devuelve puntero raw al hijo en la posicion dada
//   row() — busca la posicion de este nodo dentro de los hijos de su padre
//   parentItem() — devuelve el puntero al nodo padre
// =============================================================================

#ifndef TREEITEM_H
#define TREEITEM_H

#include <QVariantList>
#include <memory>
#include <vector>

class TreeItem
{
public:
    explicit TreeItem(const QVariantList &data, TreeItem *parent = nullptr);

    // Gestion de la estructura del arbol: agregar y eliminar hijos
    void appendChild(std::unique_ptr<TreeItem> child);
    bool removeChildren(int row, int count);

    // Navegacion: acceder a hijos, contar hijos/columnas, obtener padre
    TreeItem *child(int row) const;
    int childCount() const;
    int columnCount() const;
    QVariant data(int column) const;
    bool setData(int column, const QVariant &value);
    int row() const;
    TreeItem *parentItem() const;

private:
    // IMPORTANTE: std::vector + unique_ptr, NO QVector (ver explicacion arriba)
    std::vector<std::unique_ptr<TreeItem>> m_children;

    // Datos del nodo: cada posicion representa una "columna" (nombre, cargo, etc.)
    QVariantList m_data;

    // Puntero raw al padre (NO es dueno del padre, solo referencia)
    TreeItem *m_parent = nullptr;
};

#endif // TREEITEM_H
