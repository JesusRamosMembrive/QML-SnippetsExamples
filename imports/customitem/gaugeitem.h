#ifndef GAUGEITEM_H
#define GAUGEITEM_H

#include <QQuickPaintedItem>
#include <QColor>
#include <QString>
#include <QtQml/qqmlregistration.h>

class GaugeItem : public QQuickPaintedItem
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(double value READ value WRITE setValue NOTIFY valueChanged)
    Q_PROPERTY(double minValue READ minValue WRITE setMinValue NOTIFY minValueChanged)
    Q_PROPERTY(double maxValue READ maxValue WRITE setMaxValue NOTIFY maxValueChanged)
    Q_PROPERTY(QString label READ label WRITE setLabel NOTIFY labelChanged)
    Q_PROPERTY(QColor gaugeColor READ gaugeColor WRITE setGaugeColor NOTIFY gaugeColorChanged)
    Q_PROPERTY(QColor backgroundColor READ backgroundColor WRITE setBackgroundColor NOTIFY backgroundColorChanged)

public:
    explicit GaugeItem(QQuickItem *parent = nullptr);
    void paint(QPainter *painter) override;

    double value() const { return m_value; }
    void setValue(double v);
    double minValue() const { return m_minValue; }
    void setMinValue(double v);
    double maxValue() const { return m_maxValue; }
    void setMaxValue(double v);
    QString label() const { return m_label; }
    void setLabel(const QString &l);
    QColor gaugeColor() const { return m_gaugeColor; }
    void setGaugeColor(const QColor &c);
    QColor backgroundColor() const { return m_backgroundColor; }
    void setBackgroundColor(const QColor &c);

signals:
    void valueChanged();
    void minValueChanged();
    void maxValueChanged();
    void labelChanged();
    void gaugeColorChanged();
    void backgroundColorChanged();

private:
    double m_value = 0;
    double m_minValue = 0;
    double m_maxValue = 100;
    QString m_label = "RPM";
    QColor m_gaugeColor{"#00D1A9"};
    QColor m_backgroundColor{"#2A2D35"};
};

#endif
