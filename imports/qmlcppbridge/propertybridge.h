#ifndef PROPERTYBRIDGE_H
#define PROPERTYBRIDGE_H

#include <QObject>
#include <QColor>
#include <QStringList>
#include <QtQml/qqmlregistration.h>

class PropertyBridge : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int counter READ counter WRITE setCounter NOTIFY counterChanged)
    Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged)
    Q_PROPERTY(double temperature READ temperature WRITE setTemperature NOTIFY temperatureChanged)
    Q_PROPERTY(bool active READ active WRITE setActive NOTIFY activeChanged)
    Q_PROPERTY(QStringList tags READ tags NOTIFY tagsChanged)
    Q_PROPERTY(QString summary READ summary NOTIFY summaryChanged)

public:
    explicit PropertyBridge(QObject *parent = nullptr);

    int counter() const { return m_counter; }
    void setCounter(int c);
    QString userName() const { return m_userName; }
    void setUserName(const QString &n);
    double temperature() const { return m_temperature; }
    void setTemperature(double t);
    bool active() const { return m_active; }
    void setActive(bool a);
    QStringList tags() const { return m_tags; }
    QString summary() const;

    Q_INVOKABLE void increment();
    Q_INVOKABLE void decrement();
    Q_INVOKABLE void addTag(const QString &tag);
    Q_INVOKABLE void removeTag(int index);

signals:
    void counterChanged();
    void userNameChanged();
    void temperatureChanged();
    void activeChanged();
    void tagsChanged();
    void summaryChanged();

private:
    int m_counter = 0;
    QString m_userName = "User";
    double m_temperature = 22.5;
    bool m_active = false;
    QStringList m_tags;
};

#endif
