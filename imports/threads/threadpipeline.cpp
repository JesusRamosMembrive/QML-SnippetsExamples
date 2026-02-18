#include "threadpipeline.h"
#include "pipelineworkers.h"
#include <QMetaObject>

ThreadPipeline::ThreadPipeline(QObject *parent)
    : QObject(parent)
{
    m_generatorThread.setObjectName(QStringLiteral("GeneratorThread"));
    m_filterThread.setObjectName(QStringLiteral("FilterThread"));
    m_collectorThread.setObjectName(QStringLiteral("CollectorThread"));
}

ThreadPipeline::~ThreadPipeline()
{
    if (m_running)
        stop();
}

// ─── Properties ────────────────────────────────────────────────────

bool ThreadPipeline::running() const { return m_running; }
int ThreadPipeline::generatedCount() const { return m_generatedCount; }
int ThreadPipeline::processedCount() const { return m_processedCount; }
int ThreadPipeline::matchedCount() const { return m_matchedCount; }

int ThreadPipeline::recordCount() const
{
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

// ─── Start ─────────────────────────────────────────────────────────

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

    // Create workers without parent (required for moveToThread)
    m_generator = new GeneratorWorker();
    m_filter = new FilterWorker();
    m_collector = new CollectorWorker();

    // Apply config BEFORE moveToThread (safe: still on main thread)
    m_generator->setInterval(m_generationInterval);
    m_filter->setFilterPattern(m_filterPattern);

    // Move workers to their threads
    m_generator->moveToThread(&m_generatorThread);
    m_filter->moveToThread(&m_filterThread);
    m_collector->moveToThread(&m_collectorThread);

    // Pipeline chain: Generator → Filter → Collector
    // These cross-thread connections are automatically QueuedConnection
    connect(m_generator, &GeneratorWorker::dataGenerated,
            m_filter, &FilterWorker::processData);
    connect(m_filter, &FilterWorker::dataMatched,
            m_collector, &CollectorWorker::collectData);

    // Counter updates from workers → pipeline (main thread)
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

    // Record added → forward to QML
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

    // Clean up workers when threads finish
    connect(&m_generatorThread, &QThread::finished, m_generator, &QObject::deleteLater);
    connect(&m_filterThread, &QThread::finished, m_filter, &QObject::deleteLater);
    connect(&m_collectorThread, &QThread::finished, m_collector, &QObject::deleteLater);

    // Start threads: consumers first, producer last (like Actia)
    m_collectorThread.start();
    m_filterThread.start();
    m_generatorThread.start();

    // Invoke start() on each worker in their thread's event loop
    QMetaObject::invokeMethod(m_collector, "start", Qt::QueuedConnection);
    QMetaObject::invokeMethod(m_filter, "start", Qt::QueuedConnection);
    QMetaObject::invokeMethod(m_generator, "start", Qt::QueuedConnection);

    m_running = true;
    emit runningChanged();
}

// ─── Stop ──────────────────────────────────────────────────────────

void ThreadPipeline::stop()
{
    if (!m_running)
        return;

    // Stop producer first (like Actia: m1 → m2 → m3)
    if (m_generator)
        QMetaObject::invokeMethod(m_generator, "stop", Qt::QueuedConnection);

    // Flush final counts
    m_generatedCount = m_generatedCount; // already cached
    emit generatedCountChanged();
    emit processedCountChanged();
    emit matchedCountChanged();

    cleanupThreads();

    m_running = false;
    emit runningChanged();
}

void ThreadPipeline::cleanupThreads()
{
    // Quit event loops and wait for threads to finish
    m_generatorThread.quit();
    m_generatorThread.wait();

    m_filterThread.quit();
    m_filterThread.wait();

    m_collectorThread.quit();
    m_collectorThread.wait();

    // Workers are deleted by QThread::finished → deleteLater
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
