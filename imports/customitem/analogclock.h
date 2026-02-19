#ifndef ANALOGCLOCK_H
#define ANALOGCLOCK_H

#include <QQuickPaintedItem>
#include <QColor>
#include <QtQml/qqmlregistration.h>

class AnalogClock : public QQuickPaintedItem
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int hours READ hours WRITE setHours NOTIFY hoursChanged)
    Q_PROPERTY(int minutes READ minutes WRITE setMinutes NOTIFY minutesChanged)
    Q_PROPERTY(int seconds READ seconds WRITE setSeconds NOTIFY secondsChanged)
    Q_PROPERTY(QColor faceColor READ faceColor WRITE setFaceColor NOTIFY faceColorChanged)
    Q_PROPERTY(QColor accentColor READ accentColor WRITE setAccentColor NOTIFY accentColorChanged)

public:
    explicit AnalogClock(QQuickItem *parent = nullptr);
    void paint(QPainter *painter) override;

    int hours() const { return m_hours; }
    void setHours(int h);
    int minutes() const { return m_minutes; }
    void setMinutes(int m);
    int seconds() const { return m_seconds; }
    void setSeconds(int s);
    QColor faceColor() const { return m_faceColor; }
    void setFaceColor(const QColor &c);
    QColor accentColor() const { return m_accentColor; }
    void setAccentColor(const QColor &c);

signals:
    void hoursChanged();
    void minutesChanged();
    void secondsChanged();
    void faceColorChanged();
    void accentColorChanged();

private:
    int m_hours = 0;
    int m_minutes = 0;
    int m_seconds = 0;
    QColor m_faceColor{"#2A2D35"};
    QColor m_accentColor{"#00D1A9"};
};

#endif
