#ifndef WAVEFORMITEM_H
#define WAVEFORMITEM_H

#include <QQuickPaintedItem>
#include <QColor>
#include <QtQml/qqmlregistration.h>

class WaveformItem : public QQuickPaintedItem
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(double frequency READ frequency WRITE setFrequency NOTIFY frequencyChanged)
    Q_PROPERTY(double amplitude READ amplitude WRITE setAmplitude NOTIFY amplitudeChanged)
    Q_PROPERTY(double phase READ phase WRITE setPhase NOTIFY phaseChanged)
    Q_PROPERTY(QColor lineColor READ lineColor WRITE setLineColor NOTIFY lineColorChanged)
    Q_PROPERTY(int lineWidth READ lineWidth WRITE setLineWidth NOTIFY lineWidthChanged)
    Q_PROPERTY(bool showGrid READ showGrid WRITE setShowGrid NOTIFY showGridChanged)

public:
    explicit WaveformItem(QQuickItem *parent = nullptr);
    void paint(QPainter *painter) override;

    double frequency() const { return m_frequency; }
    void setFrequency(double f);
    double amplitude() const { return m_amplitude; }
    void setAmplitude(double a);
    double phase() const { return m_phase; }
    void setPhase(double p);
    QColor lineColor() const { return m_lineColor; }
    void setLineColor(const QColor &c);
    int lineWidth() const { return m_lineWidth; }
    void setLineWidth(int w);
    bool showGrid() const { return m_showGrid; }
    void setShowGrid(bool g);

signals:
    void frequencyChanged();
    void amplitudeChanged();
    void phaseChanged();
    void lineColorChanged();
    void lineWidthChanged();
    void showGridChanged();

private:
    double m_frequency = 2.0;
    double m_amplitude = 0.8;
    double m_phase = 0.0;
    QColor m_lineColor{"#00D1A9"};
    int m_lineWidth = 2;
    bool m_showGrid = true;
};

#endif
