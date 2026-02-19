#include "analogclock.h"
#include <QPainter>
#include <QtMath>

AnalogClock::AnalogClock(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    setAntialiasing(true);
}

void AnalogClock::setHours(int h)
{
    if (m_hours != h) { m_hours = h; emit hoursChanged(); update(); }
}

void AnalogClock::setMinutes(int m)
{
    if (m_minutes != m) { m_minutes = m; emit minutesChanged(); update(); }
}

void AnalogClock::setSeconds(int s)
{
    if (m_seconds != s) { m_seconds = s; emit secondsChanged(); update(); }
}

void AnalogClock::setFaceColor(const QColor &c)
{
    if (m_faceColor != c) { m_faceColor = c; emit faceColorChanged(); update(); }
}

void AnalogClock::setAccentColor(const QColor &c)
{
    if (m_accentColor != c) { m_accentColor = c; emit accentColorChanged(); update(); }
}

void AnalogClock::paint(QPainter *painter)
{
    const int side = qMin(static_cast<int>(width()), static_cast<int>(height()));

    painter->save();
    painter->setRenderHint(QPainter::Antialiasing);
    painter->translate(width() / 2.0, height() / 2.0);
    painter->scale(side / 200.0, side / 200.0);

    // Face
    painter->setPen(Qt::NoPen);
    painter->setBrush(m_faceColor);
    painter->drawEllipse(QPointF(0, 0), 95, 95);

    // Outer ring
    painter->setPen(QPen(m_accentColor, 2));
    painter->setBrush(Qt::NoBrush);
    painter->drawEllipse(QPointF(0, 0), 95, 95);

    // Hour markers
    painter->setPen(QPen(QColor(255, 255, 255, 150), 1.5));
    for (int i = 0; i < 12; i++) {
        painter->save();
        painter->rotate(30.0 * i);
        painter->drawLine(QPointF(0, -85), QPointF(0, -76));
        painter->restore();
    }

    // Minute markers
    painter->setPen(QPen(QColor(255, 255, 255, 60), 0.5));
    for (int i = 0; i < 60; i++) {
        if (i % 5 != 0) {
            painter->save();
            painter->rotate(6.0 * i);
            painter->drawLine(QPointF(0, -85), QPointF(0, -81));
            painter->restore();
        }
    }

    // Hour hand
    painter->save();
    painter->rotate(30.0 * (m_hours % 12) + 0.5 * m_minutes);
    painter->setPen(Qt::NoPen);
    painter->setBrush(QColor(255, 255, 255));
    const QPointF hourHand[] = {
        QPointF(-4, 8), QPointF(0, -55), QPointF(4, 8)
    };
    painter->drawConvexPolygon(hourHand, 3);
    painter->restore();

    // Minute hand
    painter->save();
    painter->rotate(6.0 * m_minutes + 0.1 * m_seconds);
    painter->setBrush(QColor(255, 255, 255, 200));
    const QPointF minuteHand[] = {
        QPointF(-3, 8), QPointF(0, -72), QPointF(3, 8)
    };
    painter->drawConvexPolygon(minuteHand, 3);
    painter->restore();

    // Second hand
    painter->save();
    painter->rotate(6.0 * m_seconds);
    painter->setPen(QPen(m_accentColor, 1.5));
    painter->drawLine(QPointF(0, 12), QPointF(0, -80));
    painter->restore();

    // Center dot
    painter->setPen(Qt::NoPen);
    painter->setBrush(m_accentColor);
    painter->drawEllipse(QPointF(0, 0), 4, 4);

    painter->restore();
}
