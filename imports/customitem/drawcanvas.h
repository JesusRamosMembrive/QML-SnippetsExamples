// =============================================================================
// DrawCanvas - Lienzo de dibujo libre con soporte de mouse
// =============================================================================
//
// A diferencia de los otros items (AnalogClock, GaugeItem, WaveformItem)
// que solo se observan, DrawCanvas es INTERACTIVO: captura eventos del mouse
// para permitir al usuario dibujar trazos a mano alzada.
//
// QQuickPaintedItem + eventos del mouse:
//   Para recibir eventos del mouse, hay que:
//   1. Llamar setAcceptedMouseButtons(Qt::LeftButton) en el constructor
//   2. Sobreescribir mousePressEvent, mouseMoveEvent, mouseReleaseEvent
//   Sin paso 1, los eventos se propagan a items padres y nunca llegan aqui.
//
// Modelo de datos: cada trazo (Stroke) almacena su color, grosor y puntos.
//   - mousePressEvent: inicia un nuevo trazo
//   - mouseMoveEvent: agrega puntos al trazo actual
//   - mouseReleaseEvent: finaliza el trazo y lo guarda en la lista
//
// paint() dibuja todos los trazos guardados + el trazo en progreso.
// Cada cambio de punto llama update() para repintar inmediatamente,
// dando feedback visual en tiempo real mientras el usuario dibuja.
// =============================================================================

#ifndef DRAWCANVAS_H
#define DRAWCANVAS_H

#include <QQuickPaintedItem>
#include <QColor>
#include <QPointF>
#include <QList>
#include <QtQml/qqmlregistration.h>

class DrawCanvas : public QQuickPaintedItem
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QColor penColor READ penColor WRITE setPenColor NOTIFY penColorChanged)
    Q_PROPERTY(int penWidth READ penWidth WRITE setPenWidth NOTIFY penWidthChanged)
    Q_PROPERTY(int strokeCount READ strokeCount NOTIFY strokeCountChanged)

public:
    explicit DrawCanvas(QQuickItem *parent = nullptr);
    void paint(QPainter *painter) override;

    QColor penColor() const { return m_penColor; }
    void setPenColor(const QColor &c);
    int penWidth() const { return m_penWidth; }
    void setPenWidth(int w);
    int strokeCount() const { return m_strokes.size(); }

    Q_INVOKABLE void clear();

signals:
    void penColorChanged();
    void penWidthChanged();
    void strokeCountChanged();

protected:
    // Sobreescrituras de eventos del mouse para dibujo interactivo
    void mousePressEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;

private:
    // Estructura que representa un trazo: color + grosor + serie de puntos
    struct Stroke {
        QColor color;
        int width;
        QList<QPointF> points;
    };

    QList<Stroke> m_strokes;       // Trazos completados
    Stroke m_currentStroke;         // Trazo en progreso
    bool m_drawing = false;         // Flag: esta el usuario dibujando?
    QColor m_penColor{"#00D1A9"};
    int m_penWidth = 3;
};

#endif
