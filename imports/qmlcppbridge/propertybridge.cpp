#include "propertybridge.h"

// Constructor: encadenamiento de signals (signal chaining).
// Conectamos counterChanged y userNameChanged a summaryChanged.
// Esto significa que cuando counter o userName cambian, summary se
// actualiza automaticamente tambien. En QML, un binding sobre "summary"
// se re-evaluara cada vez que counter o userName cambien, aunque summary
// no tenga su propio setter (WRITE).
PropertyBridge::PropertyBridge(QObject *parent) : QObject(parent)
{
    m_tags << "Qt" << "QML" << "C++";

    connect(this, &PropertyBridge::counterChanged, this, &PropertyBridge::summaryChanged);
    connect(this, &PropertyBridge::userNameChanged, this, &PropertyBridge::summaryChanged);
}

// Patron setter explicado en detalle:
//   1. Clausula de guarda: if (m_counter != c) — evita setear el mismo valor,
//      lo cual causaria signal -> re-evaluacion de binding -> posiblemente
//      setear de nuevo -> bucle infinito
//   2. Actualizar: m_counter = c;
//   3. Notificar: emit counterChanged() — le dice a QML "este valor cambio,
//      re-evalua tus bindings"
void PropertyBridge::setCounter(int c)
{
    if (m_counter != c) { m_counter = c; emit counterChanged(); }
}

void PropertyBridge::setUserName(const QString &n)
{
    if (m_userName != n) { m_userName = n; emit userNameChanged(); }
}

// qFuzzyCompare para doubles: los numeros de punto flotante no pueden
// compararse con == debido a errores de precision. qFuzzyCompare maneja
// esto correctamente (considera una diferencia de 0.0000001 como "igual").
void PropertyBridge::setTemperature(double t)
{
    if (!qFuzzyCompare(m_temperature, t)) { m_temperature = t; emit temperatureChanged(); }
}

void PropertyBridge::setActive(bool a)
{
    if (m_active != a) { m_active = a; emit activeChanged(); }
}

// Propiedad computada (computed property): no tiene variable miembro propia,
// se calcula bajo demanda a partir de otros miembros (m_userName, m_counter,
// m_active). Gracias al encadenamiento de signals en el constructor, QML
// re-evalua este valor automaticamente cuando sus dependencias cambian.
QString PropertyBridge::summary() const
{
    return QString("%1 (counter: %2, %3)")
        .arg(m_userName)
        .arg(m_counter)
        .arg(m_active ? "active" : "inactive");
}

void PropertyBridge::increment() { setCounter(m_counter + 1); }
void PropertyBridge::decrement() { setCounter(m_counter - 1); }

// addTag: verifica duplicados con contains() antes de agregar.
// Buena practica para propiedades de tipo lista — evita entradas repetidas.
void PropertyBridge::addTag(const QString &tag)
{
    if (!tag.isEmpty() && !m_tags.contains(tag)) {
        m_tags.append(tag);
        emit tagsChanged();
    }
}

void PropertyBridge::removeTag(int index)
{
    if (index >= 0 && index < m_tags.size()) {
        m_tags.removeAt(index);
        emit tagsChanged();
    }
}
