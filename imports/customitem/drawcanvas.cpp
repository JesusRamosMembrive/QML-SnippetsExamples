#include "drawcanvas.h"
#include <QPainter>
#include <QMouseEvent>

DrawCanvas::DrawCanvas(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    setAcceptedMouseButtons(Qt::LeftButton);
    setAntialiasing(true);
}

void DrawCanvas::setPenColor(const QColor &c)
{
    if (m_penColor != c) {
        m_penColor = c;
        emit penColorChanged();
    }
}

void DrawCanvas::setPenWidth(int w)
{
    if (m_penWidth != w) {
        m_penWidth = w;
        emit penWidthChanged();
    }
}

void DrawCanvas::clear()
{
    m_strokes.clear();
    emit strokeCountChanged();
    update();
}

void DrawCanvas::mousePressEvent(QMouseEvent *event)
{
    m_drawing = true;
    m_currentStroke.color = m_penColor;
    m_currentStroke.width = m_penWidth;
    m_currentStroke.points.clear();
    m_currentStroke.points.append(event->position());
    update();
}

void DrawCanvas::mouseMoveEvent(QMouseEvent *event)
{
    if (m_drawing) {
        m_currentStroke.points.append(event->position());
        update();
    }
}

void DrawCanvas::mouseReleaseEvent(QMouseEvent *event)
{
    Q_UNUSED(event)
    if (m_drawing) {
        m_drawing = false;
        if (m_currentStroke.points.size() > 1) {
            m_strokes.append(m_currentStroke);
            emit strokeCountChanged();
        }
        m_currentStroke.points.clear();
        update();
    }
}

void DrawCanvas::paint(QPainter *painter)
{
    painter->setRenderHint(QPainter::Antialiasing);

    auto drawStroke = [painter](const Stroke &stroke) {
        if (stroke.points.size() < 2) return;
        QPen pen(stroke.color, stroke.width, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin);
        painter->setPen(pen);
        for (int i = 1; i < stroke.points.size(); i++) {
            painter->drawLine(stroke.points[i - 1], stroke.points[i]);
        }
    };

    for (const auto &stroke : m_strokes) {
        drawStroke(stroke);
    }

    if (m_drawing) {
        drawStroke(m_currentStroke);
    }
}
