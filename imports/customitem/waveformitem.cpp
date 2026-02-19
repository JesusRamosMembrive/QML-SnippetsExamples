// =============================================================================
// WaveformItem - Implementacion del visualizador de ondas sinusoidales
// =============================================================================

#include "waveformitem.h"
#include <QPainter>
#include <QPainterPath>
#include <QtMath>

WaveformItem::WaveformItem(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    setAntialiasing(true);
}

// Setters con qFuzzyCompare(): compara doubles con tolerancia.
// Nunca usar == para comparar doubles porque 0.1 + 0.2 != 0.3 en
// aritmetica de punto flotante. qFuzzyCompare() maneja este problema.
void WaveformItem::setFrequency(double f)
{
    if (!qFuzzyCompare(m_frequency, f)) { m_frequency = f; emit frequencyChanged(); update(); }
}

void WaveformItem::setAmplitude(double a)
{
    if (!qFuzzyCompare(m_amplitude, a)) { m_amplitude = a; emit amplitudeChanged(); update(); }
}

void WaveformItem::setPhase(double p)
{
    if (!qFuzzyCompare(m_phase, p)) { m_phase = p; emit phaseChanged(); update(); }
}

void WaveformItem::setLineColor(const QColor &c)
{
    if (m_lineColor != c) { m_lineColor = c; emit lineColorChanged(); update(); }
}

void WaveformItem::setLineWidth(int w)
{
    if (m_lineWidth != w) { m_lineWidth = w; emit lineWidthChanged(); update(); }
}

void WaveformItem::setShowGrid(bool g)
{
    if (m_showGrid != g) { m_showGrid = g; emit showGridChanged(); update(); }
}

// paint(): dibuja la cuadricula y la onda sinusoidal.
// Trabaja en coordenadas de pixeles reales (no escaladas como AnalogClock).
void WaveformItem::paint(QPainter *painter)
{
    const double w = width();
    const double h = height();
    const double midY = h / 2.0;

    painter->setRenderHint(QPainter::Antialiasing);

    // Cuadricula tipo osciloscopio: lineas semi-transparentes
    if (m_showGrid) {
        QPen gridPen(QColor(255, 255, 255, 30), 0.5);
        painter->setPen(gridPen);

        // Linea central horizontal (eje Y = 0)
        painter->drawLine(QPointF(0, midY), QPointF(w, midY));

        // Lineas verticales (8 divisiones)
        for (int i = 1; i < 8; i++) {
            double x = w * i / 8.0;
            painter->drawLine(QPointF(x, 0), QPointF(x, h));
        }

        // Lineas horizontales (4 divisiones)
        for (int i = 1; i < 4; i++) {
            double y = h * i / 4.0;
            painter->drawLine(QPointF(0, y), QPointF(w, y));
        }
    }

    // Onda sinusoidal usando QPainterPath.
    // QPainterPath: permite construir una curva compleja punto a punto.
    // moveTo() establece el punto inicial, lineTo() agrega segmentos.
    // drawPath() dibuja toda la curva de una vez — mucho mas eficiente
    // que llamar drawLine() cientos de veces.
    QPainterPath path;
    const int steps = qMax(static_cast<int>(w), 200);

    // Formula de la onda: y = midY - amplitude * (midY - margen) * sin(2*PI*freq*t + phase)
    for (int i = 0; i <= steps; i++) {
        double x = w * i / steps;
        double t = 2.0 * M_PI * m_frequency * i / steps + m_phase;
        double y = midY - m_amplitude * (midY - 4) * qSin(t);

        if (i == 0)
            path.moveTo(x, y);
        else
            path.lineTo(x, y);
    }

    // QPen con RoundCap y RoundJoin: extremos y uniones redondeadas
    // para una linea suave y visualmente agradable
    painter->setPen(QPen(m_lineColor, m_lineWidth, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin));
    painter->drawPath(path);
}
