// =============================================================================
// AsyncTask - Tarea asincrona con progreso y cancelacion via QPromise
// =============================================================================
//
// Mientras que AsyncComputer demuestra el patron basico de QtConcurrent
// (lanzar y esperar resultado), AsyncTask demuestra las funcionalidades
// avanzadas: progreso incremental y cancelacion.
//
// QPromise<T>: es el lado "productor" de un QFuture. Permite:
//   - Reportar progreso: promise.setProgressRange() + promise.setProgressValue()
//   - Verificar cancelacion: promise.isCanceled()
//   - Emitir resultados parciales: promise.addResult()
//
// QFutureWatcher<T>: es el lado "consumidor". Observa el QFuture y emite:
//   - progressValueChanged(int): cuando el progreso cambia
//   - finished(): cuando la tarea termina (completada o cancelada)
//   - isCanceled(): para saber si fue cancelada
//
// Cancelacion cooperativa:
//   - Desde QML se llama cancel() -> m_watcher.cancel() -> future.cancel()
//   - El hilo trabajador debe verificar promise.isCanceled() periodicamente
//     para detenerse voluntariamente. Qt NO mata el hilo a la fuerza.
//   - Si la tarea no verifica isCanceled(), seguira ejecutandose hasta
//     terminar a pesar de la solicitud de cancelacion.
//
// Comunicacion hilo secundario -> hilo principal:
//   - QMetaObject::invokeMethod() con Qt::QueuedConnection encola una
//     llamada en el event loop del hilo principal. Esto es thread-safe
//     y permite actualizar la UI desde un hilo trabajador.
// =============================================================================

#ifndef ASYNCTASK_H
#define ASYNCTASK_H

#include <QObject>
#include <QFutureWatcher>
#include <QStringList>
#include <QtQml/qqmlregistration.h>

class AsyncTask : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    // Propiedades reactivas para QML
    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
    Q_PROPERTY(double progress READ progress NOTIFY progressChanged)   // 0.0 a 1.0
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)        // Texto descriptivo del paso actual
    Q_PROPERTY(QStringList results READ results NOTIFY resultsChanged) // Resultados acumulados

public:
    explicit AsyncTask(QObject *parent = nullptr);
    ~AsyncTask() override;

    bool running() const { return m_running; }
    double progress() const { return m_progress; }
    QString status() const { return m_status; }
    QStringList results() const { return m_results; }

    // runSteps: ejecuta N pasos secuenciales con nombre, reportando progreso
    Q_INVOKABLE void runSteps(int totalSteps);

    // processItems: procesa una lista de strings, invierte cada uno y
    // acumula resultados incrementalmente
    Q_INVOKABLE void processItems(const QStringList &items);

    // cancel: solicita la cancelacion de la tarea actual.
    // La cancelacion es cooperativa: la tarea debe verificar isCanceled().
    Q_INVOKABLE void cancel();

signals:
    void runningChanged();
    void progressChanged();
    void statusChanged();
    void resultsChanged();

private:
    void setRunning(bool r);
    void setProgress(double p);
    void setStatus(const QString &s);

    // QFutureWatcher<void>: watcher para tareas que no devuelven valor,
    // pero si reportan progreso y soportan cancelacion
    QFutureWatcher<void> m_watcher;

    bool m_running = false;
    double m_progress = 0.0;
    QString m_status;
    QStringList m_results;
};

#endif
