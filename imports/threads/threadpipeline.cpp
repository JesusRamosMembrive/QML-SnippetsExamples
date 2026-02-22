// ============================================================================
// threadpipeline.cpp - Implementacion del controlador del pipeline
// ============================================================================
//
// Esta clase orquesta el ciclo de vida completo de los hilos:
//   1. Crear workers sin parent (requisito de moveToThread)
//   2. Configurar workers antes de moverlos (aun en el hilo principal)
//   3. Mover workers a sus QThreads respectivos
//   4. Conectar signals entre workers (cadena del pipeline)
//   5. Iniciar los QThreads (consumidores primero, productor al final)
//   6. Invocar start() en cada worker via QMetaObject::invokeMethod
//   7. Al parar: detener productor, quit() event loops, wait() hilos
//   8. Workers se eliminan automaticamente via finished -> deleteLater
//
// CADENA DEL PIPELINE:
//   Generator::dataGenerated --> Filter::processData --> Collector::collectData
//   Todas son conexiones cross-thread con QueuedConnection automatica.
// ============================================================================

#include "threadpipeline.h"
#include "pipelineworkers.h"
#include <QMetaObject>

ThreadPipeline::ThreadPipeline(QObject *parent)
    : QObject(parent)
{
    // Nombres para depuracion: aparecen en herramientas como QThread::objectName()
    m_generatorThread.setObjectName(QStringLiteral("GeneratorThread"));
    m_filterThread.setObjectName(QStringLiteral("FilterThread"));
    m_collectorThread.setObjectName(QStringLiteral("CollectorThread"));
}

// El destructor asegura que los hilos se detengan limpiamente.
// Si la pipeline se destruye mientras esta corriendo, stop() hace el cleanup.
ThreadPipeline::~ThreadPipeline()
{
    if (m_running)
        stop();
}

// ─── Properties ────────────────────────────────────────────────────
// Getters simples para las Q_PROPERTY declaradas en el header.
// QML lee estos valores reactivamente gracias al sistema de data binding.

bool ThreadPipeline::running() const { return m_running; }
int ThreadPipeline::generatedCount() const { return m_generatedCount; }
int ThreadPipeline::processedCount() const { return m_processedCount; }
int ThreadPipeline::matchedCount() const { return m_matchedCount; }

int ThreadPipeline::recordCount() const
{
    // recordCount() accede al CollectorWorker que vive en otro hilo.
    // Es seguro porque CollectorWorker::recordCount() usa QMutexLocker.
    return m_collector ? m_collector->recordCount() : 0;
}

QString ThreadPipeline::mainThreadId() const
{
    return QStringLiteral("0x%1")
        .arg(reinterpret_cast<quintptr>(QThread::currentThreadId()), 0, 16);
}

QString ThreadPipeline::generatorThreadId() const { return m_generatorThreadId; }
QString ThreadPipeline::filterThreadId() const { return m_filterThreadId; }
QString ThreadPipeline::collectorThreadId() const { return m_collectorThreadId; }

int ThreadPipeline::generationInterval() const { return m_generationInterval; }

// setGenerationInterval() se llama desde QML (Q_PROPERTY con WRITE).
// El worker vive en otro hilo, asi que usamos QMetaObject::invokeMethod
// con Qt::QueuedConnection para llamar su slot de forma thread-safe.
// Esto encola la llamada en el event loop del hilo del worker.
void ThreadPipeline::setGenerationInterval(int ms)
{
    if (m_generationInterval == ms)
        return;
    m_generationInterval = ms;
    if (m_generator)
        QMetaObject::invokeMethod(m_generator, "setInterval",
            Qt::QueuedConnection, Q_ARG(int, ms));
    emit generationIntervalChanged();
}

QString ThreadPipeline::filterPatternHex() const
{
    return m_filterPattern.toHex(' ');
}

// ============================================================================
// start() - Iniciar el pipeline
// ============================================================================
// Orden de operaciones critico:
//   1. Crear workers SIN parent (moveToThread lo requiere)
//   2. Configurar ANTES de moveToThread (todavia en hilo principal, seguro)
//   3. moveToThread: ahora los slots del worker corren en el hilo destino
//   4. Conectar signals DESPUES de moveToThread (las conexiones cross-thread
//      se detectan en el momento del emit, no del connect)
//   5. Iniciar hilos: consumidores PRIMERO, productor AL FINAL
//      (evita perder datos generados antes de que el filtro este listo)
//   6. Invocar start() en cada worker via QMetaObject::invokeMethod
//      con QueuedConnection (se ejecuta en el event loop del hilo destino)

void ThreadPipeline::start()
{
    if (m_running)
        return;

    m_generatedCount = 0;
    m_processedCount = 0;
    m_matchedCount = 0;
    emit generatedCountChanged();
    emit processedCountChanged();
    emit matchedCountChanged();

    // Paso 1: Crear workers sin parent (required for moveToThread)
    // Si tuvieran parent, moveToThread() fallaria con un warning porque
    // Qt no permite mover un objeto que tiene parent en otro hilo.
    m_generator = new GeneratorWorker();
    m_filter = new FilterWorker();
    m_collector = new CollectorWorker();

    // Paso 2: Apply config BEFORE moveToThread (safe: still on main thread)
    m_generator->setInterval(m_generationInterval);
    m_filter->setFilterPattern(m_filterPattern);

    // Paso 3: Move workers to their threads
    // Despues de esto, los slots de cada worker se ejecutan en su hilo.
    m_generator->moveToThread(&m_generatorThread);
    m_filter->moveToThread(&m_filterThread);
    m_collector->moveToThread(&m_collectorThread);

    // Paso 4: Cadena del pipeline (Generator -> Filter -> Collector)
    // Estas conexiones son automaticamente QueuedConnection porque emisor
    // y receptor viven en hilos diferentes. Qt serializa los argumentos
    // (QByteArray se copia) y los encola en el event loop del receptor.
    connect(m_generator, &GeneratorWorker::dataGenerated,
            m_filter, &FilterWorker::processData);
    connect(m_filter, &FilterWorker::dataMatched,
            m_collector, &CollectorWorker::collectData);

    // Actualizaciones de contadores: workers (hilos de fondo) -> pipeline (hilo principal)
    // Tambien son QueuedConnection automaticas. Las lambdas se ejecutan en
    // el hilo del receptor (this = hilo principal), asi que es seguro
    // modificar m_generatedCount etc. sin mutex.
    connect(m_generator, &GeneratorWorker::countChanged,
            this, [this](int count) {
        m_generatedCount = count;
        emit generatedCountChanged();
    });
    connect(m_filter, &FilterWorker::statsChanged,
            this, [this](int processed, int matched) {
        m_processedCount = processed;
        m_matchedCount = matched;
        emit processedCountChanged();
        emit matchedCountChanged();
    });
    connect(m_collector, &CollectorWorker::recordCountChanged,
            this, [this]() {
        emit recordCountChanged();
    });

    // Record added -> forward to QML
    connect(m_collector, &CollectorWorker::recordAdded,
            this, &ThreadPipeline::recordAdded);

    // Thread ID reporting
    connect(m_generator, &GeneratorWorker::threadIdReady,
            this, [this](const QString &id) {
        m_generatorThreadId = id;
        emit generatorThreadIdChanged();
    });
    connect(m_filter, &FilterWorker::threadIdReady,
            this, [this](const QString &id) {
        m_filterThreadId = id;
        emit filterThreadIdChanged();
    });
    connect(m_collector, &CollectorWorker::threadIdReady,
            this, [this](const QString &id) {
        m_collectorThreadId = id;
        emit collectorThreadIdChanged();
    });

    // LIMPIEZA AUTOMATICA:
    // Cuando un QThread termina (finished), deleteLater() destruye el worker.
    // Esto es seguro porque deleteLater() se ejecuta en el event loop
    // del hilo del objeto (que ya termino), y Qt maneja la destruccion
    // pendiente correctamente.
    connect(&m_generatorThread, &QThread::finished, m_generator, &QObject::deleteLater);
    connect(&m_filterThread, &QThread::finished, m_filter, &QObject::deleteLater);
    connect(&m_collectorThread, &QThread::finished, m_collector, &QObject::deleteLater);

    // Paso 5: Iniciar hilos - consumidores primero, productor al final.
    // Asi el Colector y Filtro ya tienen su event loop corriendo cuando
    // el Generador empiece a producir datos.
    m_collectorThread.start();
    m_filterThread.start();
    m_generatorThread.start();

    // Paso 6: Invocar start() en cada worker en su event loop.
    // QMetaObject::invokeMethod con QueuedConnection es la forma segura
    // de llamar un slot en un objeto que vive en otro hilo.
    QMetaObject::invokeMethod(m_collector, "start", Qt::QueuedConnection);
    QMetaObject::invokeMethod(m_filter, "start", Qt::QueuedConnection);
    QMetaObject::invokeMethod(m_generator, "start", Qt::QueuedConnection);

    m_running = true;
    emit runningChanged();
}

// ============================================================================
// stop() - Detener el pipeline
// ============================================================================
// Orden de detencion: productor primero, luego limpiar hilos.
// Al detener el generador primero, dejamos que los datos en transito
// (ya encolados en los event loops) se procesen antes de cerrar.

void ThreadPipeline::stop()
{
    if (!m_running)
        return;

    // Detener productor primero
    if (m_generator)
        QMetaObject::invokeMethod(m_generator, "stop", Qt::QueuedConnection);

    // Flush final counts
    emit generatedCountChanged();
    emit processedCountChanged();
    emit matchedCountChanged();

    cleanupThreads();

    m_running = false;
    emit runningChanged();
}

// ============================================================================
// cleanupThreads() - Ciclo de vida: apagar hilos limpiamente
// ============================================================================
// quit(): pide al event loop del hilo que termine (QThread::exec() retorna).
// wait(): bloquea hasta que el hilo realmente termina.
// Despues del wait(), el hilo emite finished(), que activa deleteLater()
// en el worker, destruyendolo de forma segura.
//
// IMPORTANTE: siempre llamar quit() ANTES de wait(). Sin quit(), el event
// loop sigue corriendo y wait() bloquea indefinidamente (deadlock).

void ThreadPipeline::cleanupThreads()
{
    // Quit event loops and wait for threads to finish
    m_generatorThread.quit();
    m_generatorThread.wait();

    m_filterThread.quit();
    m_filterThread.wait();

    m_collectorThread.quit();
    m_collectorThread.wait();

    // Workers are deleted by QThread::finished -> deleteLater
    // Ponemos los punteros a null para evitar dangling pointers.
    m_generator = nullptr;
    m_filter = nullptr;
    m_collector = nullptr;
}

// ─── Actions ───────────────────────────────────────────────────────

void ThreadPipeline::clear()
{
    if (m_collector)
        m_collector->clearRecords();
    emit recordCountChanged();
}

// setFilterPattern() recibe un array desde QML (QVariantList) y lo convierte
// a QByteArray para el FilterWorker. Usa invokeMethod con QueuedConnection
// porque el worker vive en otro hilo.
void ThreadPipeline::setFilterPattern(const QVariantList &bytes)
{
    QByteArray pattern;
    for (const auto &v : bytes)
        pattern.append(static_cast<char>(v.toInt()));

    m_filterPattern = pattern;
    if (m_filter)
        QMetaObject::invokeMethod(m_filter, "setFilterPattern",
            Qt::QueuedConnection, Q_ARG(QByteArray, pattern));
    emit filterPatternChanged();
}
