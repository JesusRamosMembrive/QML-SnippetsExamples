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
    void mousePressEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;

private:
    struct Stroke {
        QColor color;
        int width;
        QList<QPointF> points;
    };

    QList<Stroke> m_strokes;
    Stroke m_currentStroke;
    bool m_drawing = false;
    QColor m_penColor{"#00D1A9"};
    int m_penWidth = 3;
};

#endif
