// =============================================================================
// AsyncTask - Implementacion con QPromise, progreso y cancelacion
// =============================================================================
//
// Esta clase demuestra el uso avanzado de QtConcurrent con QPromise:
//
// Firma de QtConcurrent::run() con QPromise:
//   QtConcurrent::run([](QPromise<void> &promise) { ... })
//   Qt inyecta automaticamente el QPromise como primer parametro del lambda.
//   Dentro del lambda puedes:
//     - promise.setProgressRange(min, max) - definir el rango de progreso
//     - promise.setProgressValue(n)        - actualizar el progreso actual
//     - promise.isCanceled()               - verificar si se pidio cancelacion
//
// Comunicacion thread-safe con el hilo principal:
//   QMetaObject::invokeMethod(this, [...]() { ... }, Qt::QueuedConnection)
//   Encola el lambda en el event loop del objeto destino (hilo principal).
//   Es la forma segura de actualizar propiedades de QObject desde un hilo
//   secundario, ya que los QObject NO son thread-safe.
//
// Por que QFutureWatcher<void>?
//   Cuando la tarea no devuelve un valor final sino que reporta progreso
//   y resultados parciales via invokeMethod, usamos QFuture<void>.
//   El watcher aun emite progressValueChanged() y finished().
// =============================================================================

#include "asynctask.h"
#include <QtConcurrent>
#include <QThread>

AsyncTask::AsyncTask(QObject *parent) : QObject(parent)
{
    // Conexion para el progreso: el watcher emite progressValueChanged cada vez
    // que la tarea llama a promise.setProgressValue(). Convertimos el valor
    // absoluto a un porcentaje normalizado (0.0 a 1.0) para QML.
    connect(&m_watcher, &QFutureWatcher<void>::progressValueChanged,
            this, [this](int value) {
        int range = m_watcher.progressMaximum() - m_watcher.progressMinimum();
        m_progress = range > 0 ? static_cast<double>(value) / range : 0.0;
        emit progressChanged();
    });

    // Conexion para el fin de la tarea: verificamos si fue cancelada o
    // completada normalmente, y actualizamos el estado correspondientemente.
    connect(&m_watcher, &QFutureWatcher<void>::finished, this, [this]() {
        if (m_watcher.isCanceled())
            setStatus("Cancelled");
        else {
            setProgress(1.0);
            setStatus("Completed");
        }
        setRunning(false);
    });
}

AsyncTask::~AsyncTask()
{
    // Limpieza segura: cancelar y esperar. Si no hacemos esto, el hilo
    // del pool podria intentar acceder al objeto despues de destruirlo.
    m_watcher.cancel();
    m_watcher.waitForFinished();
}

// Setters con proteccion de redundancia: solo emiten signal si el valor cambio.
// qFuzzyCompare se usa para doubles porque la comparacion directa con == puede
// fallar por errores de precision de punto flotante.
void AsyncTask::setRunning(bool r)
{
    if (m_running != r) { m_running = r; emit runningChanged(); }
}

void AsyncTask::setProgress(double p)
{
    if (!qFuzzyCompare(m_progress, p)) { m_progress = p; emit progressChanged(); }
}

void AsyncTask::setStatus(const QString &s)
{
    if (m_status != s) { m_status = s; emit statusChanged(); }
}

// runSteps() - Ejecuta una serie de pasos numerados, simulando un proceso largo
//
// Demuestra:
//   - QPromise con setProgressRange/setProgressValue para reportar progreso
//   - promise.isCanceled() para cancelacion cooperativa
//   - QMetaObject::invokeMethod() para actualizar la UI desde el hilo secundario
//   - QThread::msleep() para simular trabajo pesado (300ms por paso)
void AsyncTask::runSteps(int totalSteps)
{
    if (m_running) return;
    setRunning(true);
    setProgress(0);
    setStatus("Starting...");
    m_results.clear();
    emit resultsChanged();

    // Nombres descriptivos para los primeros 10 pasos (despues usa "Step N")
    static const QStringList stepNames = {
        "Initializing", "Loading data", "Parsing config",
        "Validating input", "Processing batch", "Analyzing results",
        "Compiling output", "Optimizing", "Finalizing", "Cleaning up"
    };

    // QtConcurrent::run() con QPromise<void>:
    // Qt detecta que el lambda acepta QPromise<void>& como primer parametro
    // y lo inyecta automaticamente. El QFuture devuelto esta conectado a
    // este QPromise internamente.
    auto future = QtConcurrent::run([this, totalSteps](QPromise<void> &promise) {
        promise.setProgressRange(0, totalSteps);

        for (int i = 0; i < totalSteps; i++) {
            // Cancelacion cooperativa: verificamos antes de cada paso.
            // Si el usuario llamo cancel(), isCanceled() devuelve true
            // y salimos del loop voluntariamente.
            if (promise.isCanceled()) return;

            QString name = (i < stepNames.size()) ? stepNames[i]
                         : QString("Step %1").arg(i + 1);

            // QMetaObject::invokeMethod con Qt::QueuedConnection:
            // Encola esta llamada en el event loop del hilo principal.
            // Es NECESARIO porque estamos en un hilo secundario y no
            // podemos modificar propiedades de QObject directamente.
            QMetaObject::invokeMethod(this, [this, name, i, totalSteps]() {
                setStatus(QString("%1 (%2/%3)").arg(name).arg(i + 1).arg(totalSteps));
            }, Qt::QueuedConnection);

            // Simula trabajo pesado (en una app real, aqui iria el calculo)
            QThread::msleep(300);
            // Actualiza el progreso - esto dispara progressValueChanged en el watcher
            promise.setProgressValue(i + 1);
        }
    });

    m_watcher.setFuture(future);
}

// processItems() - Procesa una lista de strings: invierte y pone en mayusculas
//
// Demuestra resultados incrementales: cada item procesado se agrega a m_results
// inmediatamente via invokeMethod, y QML ve los resultados aparecer uno por uno
// gracias a la signal resultsChanged().
void AsyncTask::processItems(const QStringList &items)
{
    if (m_running) return;
    setRunning(true);
    setProgress(0);
    setStatus("Processing items...");
    m_results.clear();
    emit resultsChanged();

    auto future = QtConcurrent::run([this, items](QPromise<void> &promise) {
        promise.setProgressRange(0, items.size());

        for (int i = 0; i < items.size(); i++) {
            // Verificar cancelacion antes de cada item
            if (promise.isCanceled()) return;

            // Simula procesamiento lento (400ms por item)
            QThread::msleep(400);

            // Logica de ejemplo: invertir el string y convertir a mayusculas
            QString reversed;
            const QString &src = items[i];
            reversed.reserve(src.size());
            for (int j = src.size() - 1; j >= 0; --j)
                reversed.append(src[j]);

            QString result = src + "  ->  " + reversed.toUpper();

            // Enviar resultado al hilo principal de forma thread-safe.
            // Notar que capturamos 'total = items.size()' por valor
            // porque items podria dejar de existir despues.
            QMetaObject::invokeMethod(this, [this, result, i, total = items.size()]() {
                m_results.append(result);
                emit resultsChanged();
                setStatus(QString("Processed %1/%2").arg(i + 1).arg(total));
            }, Qt::QueuedConnection);

            promise.setProgressValue(i + 1);
        }
    });

    m_watcher.setFuture(future);
}

// cancel() - Solicita la cancelacion de la tarea en ejecucion.
// Llama a m_watcher.cancel() que a su vez cancela el QFuture asociado.
// La tarea debe cooperar verificando promise.isCanceled() periodicamente.
// Si no lo verifica, la tarea seguira ejecutandose hasta completar.
void AsyncTask::cancel()
{
    if (m_running)
        m_watcher.cancel();
}
