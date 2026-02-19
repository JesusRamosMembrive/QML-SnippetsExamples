#include "waveformitem.h"
#include <QPainter>
#include <QPainterPath>
#include <QtMath>

WaveformItem::WaveformItem(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    setAntialiasing(true);
}

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

void WaveformItem::paint(QPainter *painter)
{
    const double w = width();
    const double h = height();
    const double midY = h / 2.0;

    painter->setRenderHint(QPainter::Antialiasing);

    // Grid
    if (m_showGrid) {
        QPen gridPen(QColor(255, 255, 255, 30), 0.5);
        painter->setPen(gridPen);

        // Center line
        painter->drawLine(QPointF(0, midY), QPointF(w, midY));

        // Vertical grid
        for (int i = 1; i < 8; i++) {
            double x = w * i / 8.0;
            painter->drawLine(QPointF(x, 0), QPointF(x, h));
        }

        // Horizontal grid
        for (int i = 1; i < 4; i++) {
            double y = h * i / 4.0;
            painter->drawLine(QPointF(0, y), QPointF(w, y));
        }
    }

    // Waveform path
    QPainterPath path;
    const int steps = qMax(static_cast<int>(w), 200);

    for (int i = 0; i <= steps; i++) {
        double x = w * i / steps;
        double t = 2.0 * M_PI * m_frequency * i / steps + m_phase;
        double y = midY - m_amplitude * (midY - 4) * qSin(t);

        if (i == 0)
            path.moveTo(x, y);
        else
            path.lineTo(x, y);
    }

    painter->setPen(QPen(m_lineColor, m_lineWidth, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin));
    painter->drawPath(path);
}
