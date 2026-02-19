#include "propertybridge.h"

PropertyBridge::PropertyBridge(QObject *parent) : QObject(parent)
{
    m_tags << "Qt" << "QML" << "C++";

    connect(this, &PropertyBridge::counterChanged, this, &PropertyBridge::summaryChanged);
    connect(this, &PropertyBridge::userNameChanged, this, &PropertyBridge::summaryChanged);
}

void PropertyBridge::setCounter(int c)
{
    if (m_counter != c) { m_counter = c; emit counterChanged(); }
}

void PropertyBridge::setUserName(const QString &n)
{
    if (m_userName != n) { m_userName = n; emit userNameChanged(); }
}

void PropertyBridge::setTemperature(double t)
{
    if (!qFuzzyCompare(m_temperature, t)) { m_temperature = t; emit temperatureChanged(); }
}

void PropertyBridge::setActive(bool a)
{
    if (m_active != a) { m_active = a; emit activeChanged(); }
}

QString PropertyBridge::summary() const
{
    return QString("%1 (counter: %2, %3)")
        .arg(m_userName)
        .arg(m_counter)
        .arg(m_active ? "active" : "inactive");
}

void PropertyBridge::increment() { setCounter(m_counter + 1); }
void PropertyBridge::decrement() { setCounter(m_counter - 1); }

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
