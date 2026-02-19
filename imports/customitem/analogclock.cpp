// =============================================================================
// AnalogClock - Implementacion del reloj analogico con QPainter
// =============================================================================

#include "analogclock.h"
#include <QPainter>
#include <QtMath>

// Constructor: habilita anti-aliasing para bordes suaves en los circulos
// y lineas del reloj. Sin antialiasing, los bordes se ven pixelados.
AnalogClock::AnalogClock(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    setAntialiasing(true);
}

// Setters: patron tipico de QQuickPaintedItem.
// 1. Verificar que el valor realmente cambio (evitar repintados innecesarios)
// 2. Actualizar el valor interno
// 3. Emitir la signal para notificar a QML
// 4. Llamar update() para solicitar que Qt llame a paint() en el proximo frame
// IMPORTANTE: nunca llamar paint() directamente — siempre usar update()
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

// paint(): metodo principal de dibujo — llamado por Qt, NO por nosotros.
//
// Tecnica de coordenadas: en vez de calcular posiciones en pixeles reales,
// usamos translate() + scale() para trabajar en un espacio virtual de 200x200.
// Asi el reloj se escala automaticamente a cualquier tamano.
//
// painter->save()/restore(): guarda y restaura el estado del painter
// (transformaciones, pen, brush). Fundamental cuando se hacen rotaciones
// anidadas — sin save/restore, las rotaciones se acumulan incorrectamente.
void AnalogClock::paint(QPainter *painter)
{
    const int side = qMin(static_cast<int>(width()), static_cast<int>(height()));

    painter->save();
    painter->setRenderHint(QPainter::Antialiasing);
    // Mover el origen al centro del item
    painter->translate(width() / 2.0, height() / 2.0);
    // Escalar para que el espacio virtual sea 200x200
    painter->scale(side / 200.0, side / 200.0);

    // Cara del reloj: circulo relleno
    painter->setPen(Qt::NoPen);
    painter->setBrush(m_faceColor);
    painter->drawEllipse(QPointF(0, 0), 95, 95);

    // Anillo exterior: borde de color acento
    painter->setPen(QPen(m_accentColor, 2));
    painter->setBrush(Qt::NoBrush);
    painter->drawEllipse(QPointF(0, 0), 95, 95);

    // Marcadores de horas (12 lineas, una cada 30 grados)
    painter->setPen(QPen(QColor(255, 255, 255, 150), 1.5));
    for (int i = 0; i < 12; i++) {
        painter->save();
        painter->rotate(30.0 * i);
        painter->drawLine(QPointF(0, -85), QPointF(0, -76));
        painter->restore();
    }

    // Marcadores de minutos (60 lineas, una cada 6 grados, excepto las horas)
    painter->setPen(QPen(QColor(255, 255, 255, 60), 0.5));
    for (int i = 0; i < 60; i++) {
        if (i % 5 != 0) {
            painter->save();
            painter->rotate(6.0 * i);
            painter->drawLine(QPointF(0, -85), QPointF(0, -81));
            painter->restore();
        }
    }

    // Manecilla de horas: poligono triangular rotado segun hora + minutos
    // 30 grados por hora + 0.5 grados por minuto (movimiento suave)
    painter->save();
    painter->rotate(30.0 * (m_hours % 12) + 0.5 * m_minutes);
    painter->setPen(Qt::NoPen);
    painter->setBrush(QColor(255, 255, 255));
    const QPointF hourHand[] = {
        QPointF(-4, 8), QPointF(0, -55), QPointF(4, 8)
    };
    painter->drawConvexPolygon(hourHand, 3);
    painter->restore();

    // Manecilla de minutos: mas larga y delgada que la de horas
    // 6 grados por minuto + 0.1 grados por segundo
    painter->save();
    painter->rotate(6.0 * m_minutes + 0.1 * m_seconds);
    painter->setBrush(QColor(255, 255, 255, 200));
    const QPointF minuteHand[] = {
        QPointF(-3, 8), QPointF(0, -72), QPointF(3, 8)
    };
    painter->drawConvexPolygon(minuteHand, 3);
    painter->restore();

    // Manecilla de segundos: linea fina de color acento (6 grados por segundo)
    painter->save();
    painter->rotate(6.0 * m_seconds);
    painter->setPen(QPen(m_accentColor, 1.5));
    painter->drawLine(QPointF(0, 12), QPointF(0, -80));
    painter->restore();

    // Punto central decorativo
    painter->setPen(Qt::NoPen);
    painter->setBrush(m_accentColor);
    painter->drawEllipse(QPointF(0, 0), 4, 4);

    painter->restore();
}
