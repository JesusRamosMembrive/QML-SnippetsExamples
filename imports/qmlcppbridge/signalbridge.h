#ifndef SIGNALBRIDGE_H
#define SIGNALBRIDGE_H

#include <QObject>
#include <QTimer>
#include <QStringList>
#include <QtQml/qqmlregistration.h>

class SignalBridge : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
    Q_PROPERTY(double progress READ progress NOTIFY progressChanged)

public:
    explicit SignalBridge(QObject *parent = nullptr);

    bool running() const { return m_running; }
    double progress() const { return m_progress; }

    Q_INVOKABLE void startTask();
    Q_INVOKABLE void stopTask();
    Q_INVOKABLE void emitCustom(const QString &message);

signals:
    void runningChanged();
    void progressChanged();
    void dataReceived(const QString &data);
    void taskCompleted(const QString &result);
    void errorOccurred(const QString &error);
    void customSignal(const QString &message);

private slots:
    void onTick();

private:
    QTimer m_timer;
    bool m_running = false;
    double m_progress = 0.0;
    int m_step = 0;
    QStringList m_steps;
};

#endif
