// =============================================================================
// AnalogClock - Reloj analogico dibujado con QPainter
// =============================================================================
//
// QQuickPaintedItem: permite usar QPainter (la API de pintado 2D de Qt)
// dentro de una escena QML. Es el puente entre el sistema de pintado clasico
// de Qt Widgets y Qt Quick.
//
// Por que usar QQuickPaintedItem en vez de QML Canvas?
//   - QPainter es nativo C++, no JavaScript → mucho mas rapido
//   - Mas funciones: curvas anti-aliased, paths complejos, texto avanzado
//   - Control preciso con QPen (bordes), QBrush (rellenos), QFont (texto)
//   - Ideal para graficos complejos como relojes, medidores, visualizadores
//
// El metodo paint() es llamado por Qt cuando el item necesita repintarse.
// Para solicitar un repintado manual, llamar update() (NO paint() directamente).
//
// Pipeline de renderizado:
//   1. El scene graph de QML detecta que el item esta "sucio" (dirty)
//   2. Llama a paint() pasando un QPainter listo para dibujar
//   3. QPainter dibuja sobre una textura interna (offscreen)
//   4. La textura se compone en la escena junto con otros elementos QML
//
// Propiedades QML: hours, minutes, seconds controlan la posicion de las
// manecillas. faceColor y accentColor permiten personalizar los colores.
// Cada setter llama update() para solicitar un repintado automatico.
// =============================================================================

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

    // paint(): override obligatorio — aqui va toda la logica de dibujo
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
