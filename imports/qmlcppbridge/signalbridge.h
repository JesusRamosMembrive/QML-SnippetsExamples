// =============================================================================
// EDUCATIVO: Signals de C++ -> Handlers de QML (comunicacion asincrona)
// =============================================================================
//
// QTimer: emite la signal timeout() a intervalos regulares. Aqui se usa
// para simular una tarea de multiples pasos que avanza cada 500ms.
//
// Seccion "signals": estas son signals de C++ que QML conecta con
// handlers "on<NombreSignal>":
//
//   dataReceived(data)      ->  QML: onDataReceived: function(data) { ... }
//   taskCompleted(result)   ->  QML: onTaskCompleted: function(result) { ... }
//   errorOccurred(error)    ->  QML: onErrorOccurred: function(error) { ... }
//   customSignal(message)   ->  QML: onCustomSignal: function(message) { ... }
//
// Seccion "private slots": "slots" es la palabra clave de Qt para metodos
// que pueden ser conectados a signals. Tambien pueden llamarse como metodos
// normales. Aqui onTick() se conecta a QTimer::timeout en el constructor.
// =============================================================================

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
