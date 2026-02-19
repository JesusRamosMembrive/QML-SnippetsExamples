// =============================================================================
// GaugeItem - Implementacion del medidor semicircular
// =============================================================================

#include "gaugeitem.h"
#include <QPainter>
#include <QtMath>

GaugeItem::GaugeItem(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    setAntialiasing(true);
}

void GaugeItem::setValue(double v)
{
    if (!qFuzzyCompare(m_value, v)) { m_value = v; emit valueChanged(); update(); }
}

void GaugeItem::setMinValue(double v)
{
    if (!qFuzzyCompare(m_minValue, v)) { m_minValue = v; emit minValueChanged(); update(); }
}

void GaugeItem::setMaxValue(double v)
{
    if (!qFuzzyCompare(m_maxValue, v)) { m_maxValue = v; emit maxValueChanged(); update(); }
}

void GaugeItem::setLabel(const QString &l)
{
    if (m_label != l) { m_label = l; emit labelChanged(); update(); }
}

void GaugeItem::setGaugeColor(const QColor &c)
{
    if (m_gaugeColor != c) { m_gaugeColor = c; emit gaugeColorChanged(); update(); }
}

void GaugeItem::setBackgroundColor(const QColor &c)
{
    if (m_backgroundColor != c) { m_backgroundColor = c; emit backgroundColorChanged(); update(); }
}

// paint(): dibuja el medidor completo en varias capas.
// Usa el mismo patron de translate+scale que AnalogClock para trabajar
// en un espacio virtual de 200x200 que se escala al tamano real del item.
void GaugeItem::paint(QPainter *painter)
{
    const double side = qMin(width(), height());

    painter->save();
    painter->setRenderHint(QPainter::Antialiasing);
    painter->translate(width() / 2.0, height() / 2.0);
    painter->scale(side / 200.0, side / 200.0);

    const double radius = 85.0;
    const double startAngle = 225.0;   // Arriba-izquierda (7:30 en reloj)
    const double endAngle = -45.0;     // Arriba-derecha (4:30 en reloj)
    const double spanAngle = startAngle - endAngle; // 270 grados de arco total

    // Arco de fondo: muestra el rango completo en gris semi-transparente.
    // drawArc() espera angulos en 1/16 de grado (convencion de Qt).
    // Por eso multiplicamos por 16.
    QPen bgPen(QColor(255, 255, 255, 30), 12, Qt::SolidLine, Qt::RoundCap);
    painter->setPen(bgPen);
    painter->drawArc(QRectF(-radius, -radius, radius * 2, radius * 2),
                     static_cast<int>(endAngle * 16),
                     static_cast<int>(spanAngle * 16));

    // Arco de valor: se superpone al arco de fondo mostrando el valor actual.
    // qBound(0.0, valor, 1.0): limita la fraccion entre 0 y 1 para que
    // la aguja no se salga del rango visual del medidor.
    double range = m_maxValue - m_minValue;
    double fraction = (range > 0) ? qBound(0.0, (m_value - m_minValue) / range, 1.0) : 0.0;
    double valueSpan = spanAngle * fraction;

    if (valueSpan > 0) {
        QPen valuePen(m_gaugeColor, 12, Qt::SolidLine, Qt::RoundCap);
        painter->setPen(valuePen);
        painter->drawArc(QRectF(-radius, -radius, radius * 2, radius * 2),
                         static_cast<int>(startAngle * 16),
                         static_cast<int>(-valueSpan * 16));
    }

    // Marcas de graduacion (ticks): 11 marcas distribuidas en el arco de 270 grados.
    // Usa trigonometria (cos/sin) para calcular las posiciones en el arco.
    painter->setPen(QPen(QColor(255, 255, 255, 100), 1));
    for (int i = 0; i <= 10; i++) {
        double angle = qDegreesToRadians(startAngle - spanAngle * i / 10.0);
        double cosA = qCos(angle);
        double sinA = -qSin(angle);
        painter->drawLine(
            QPointF(cosA * 70, sinA * 70),
            QPointF(cosA * 78, sinA * 78)
        );
    }

    // Aguja indicadora: linea desde el centro hasta la posicion del valor
    double needleAngle = qDegreesToRadians(startAngle - spanAngle * fraction);
    double nx = qCos(needleAngle);
    double ny = -qSin(needleAngle);
    painter->setPen(QPen(QColor(255, 255, 255), 2));
    painter->drawLine(QPointF(0, 0), QPointF(nx * 62, ny * 62));

    // Punto central decorativo
    painter->setPen(Qt::NoPen);
    painter->setBrush(m_gaugeColor);
    painter->drawEllipse(QPointF(0, 0), 5, 5);

    // Texto del valor numerico: usa QFont para controlar tamano y negrita.
    // drawText() con QRectF y Qt::AlignCenter centra el texto en el area dada.
    QFont valueFont;
    valueFont.setPixelSize(28);
    valueFont.setBold(true);
    painter->setFont(valueFont);
    painter->setPen(QColor(255, 255, 255));
    painter->drawText(QRectF(-50, 10, 100, 35), Qt::AlignCenter,
                      QString::number(m_value, 'f', 0));

    // Etiqueta descriptiva (RPM, km/h, etc.) debajo del valor
    QFont labelFont;
    labelFont.setPixelSize(14);
    painter->setFont(labelFont);
    painter->setPen(QColor(255, 255, 255, 128));
    painter->drawText(QRectF(-50, 38, 100, 20), Qt::AlignCenter, m_label);

    painter->restore();
}
