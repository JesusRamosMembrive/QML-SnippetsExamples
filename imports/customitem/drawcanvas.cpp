// =============================================================================
// DrawCanvas - Implementacion del lienzo de dibujo libre
// =============================================================================

#include "drawcanvas.h"
#include <QPainter>
#include <QMouseEvent>

// Constructor: configura la aceptacion de eventos del mouse.
// setAcceptedMouseButtons(Qt::LeftButton): OBLIGATORIO para recibir eventos.
// Sin esto, los clics del mouse pasan a traves del item y nunca se detectan.
DrawCanvas::DrawCanvas(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    setAcceptedMouseButtons(Qt::LeftButton);
    setAntialiasing(true);
}

// Setters de propiedades: NO llaman update() porque cambiar el color/grosor
// del lapiz no afecta lo ya dibujado — solo afecta el proximo trazo.
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

// clear(): borra todos los trazos y repinta (lienzo vacio).
void DrawCanvas::clear()
{
    m_strokes.clear();
    emit strokeCountChanged();
    update();
}

// mousePressEvent(): inicia un nuevo trazo.
// Captura el color y grosor actuales (el usuario puede cambiarlos entre trazos),
// limpia los puntos previos y registra el primer punto del trazo.
// event->position() devuelve la posicion del mouse relativa al item.
void DrawCanvas::mousePressEvent(QMouseEvent *event)
{
    m_drawing = true;
    m_currentStroke.color = m_penColor;
    m_currentStroke.width = m_penWidth;
    m_currentStroke.points.clear();
    m_currentStroke.points.append(event->position());
    update();
}

// mouseMoveEvent(): agrega puntos mientras el usuario arrastra el mouse.
// Cada punto nuevo dispara un update() para repintar y dar feedback visual
// inmediato — el usuario ve la linea dibujandose en tiempo real.
void DrawCanvas::mouseMoveEvent(QMouseEvent *event)
{
    if (m_drawing) {
        m_currentStroke.points.append(event->position());
        update();
    }
}

// mouseReleaseEvent(): finaliza el trazo actual.
// Solo guarda trazos con 2+ puntos (un clic sin arrastrar no genera trazo).
// Despues limpia el trazo temporal y repinta.
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

// paint(): dibuja todos los trazos completados + el trazo en progreso.
// Usa una lambda drawStroke para evitar duplicar codigo.
// Cada trazo se dibuja como una serie de lineas punto-a-punto con
// RoundCap (extremos redondeados) y RoundJoin (uniones redondeadas)
// para un aspecto suave tipo "lapiz".
void DrawCanvas::paint(QPainter *painter)
{
    painter->setRenderHint(QPainter::Antialiasing);

    // Lambda que dibuja un trazo individual: configura QPen y conecta puntos
    auto drawStroke = [painter](const Stroke &stroke) {
        if (stroke.points.size() < 2) return;
        QPen pen(stroke.color, stroke.width, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin);
        painter->setPen(pen);
        for (int i = 1; i < stroke.points.size(); i++) {
            painter->drawLine(stroke.points[i - 1], stroke.points[i]);
        }
    };

    // Primero: dibujar todos los trazos completados
    for (const auto &stroke : m_strokes) {
        drawStroke(stroke);
    }

    // Despues: dibujar el trazo en progreso (feedback en tiempo real)
    if (m_drawing) {
        drawStroke(m_currentStroke);
    }
}
