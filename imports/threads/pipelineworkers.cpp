#include "pipelineworkers.h"
#include <QThread>
#include <QMutexLocker>
#include <QVariantMap>

// ─── GeneratorWorker ───────────────────────────────────────────────

GeneratorWorker::GeneratorWorker(QObject *parent)
    : QObject(parent)
    , m_timer(this)   // Parent timer to worker so moveToThread() moves both
{
    m_timer.setInterval(m_interval);
    connect(&m_timer, &QTimer::timeout, this, &GeneratorWorker::generate);
}

void GeneratorWorker::start()
{
    m_count = 0;
    emit threadIdReady(QStringLiteral("0x%1")
        .arg(reinterpret_cast<quintptr>(QThread::currentThreadId()), 0, 16));
    m_timer.start();
}

void GeneratorWorker::stop()
{
    m_timer.stop();
}

void GeneratorWorker::setInterval(int ms)
{
    m_interval = ms;
    m_timer.setInterval(ms);
}

void GeneratorWorker::generate()
{
    std::uniform_int_distribution<int> lenDist(1, 100);
    std::uniform_int_distribution<int> byteDist(0, 255);

    int len = lenDist(m_rng);
    QByteArray data(len, Qt::Uninitialized);
    for (int i = 0; i < len; ++i)
        data[i] = static_cast<char>(byteDist(m_rng));

    emit dataGenerated(data);

    ++m_count;
    if (m_count % 50 == 0)
        emit countChanged(m_count);
}

// ─── FilterWorker ──────────────────────────────────────────────────

FilterWorker::FilterWorker(QObject *parent)
    : QObject(parent)
{
}

void FilterWorker::start()
{
    m_processedCount = 0;
    m_matchedCount = 0;
    emit threadIdReady(QStringLiteral("0x%1")
        .arg(reinterpret_cast<quintptr>(QThread::currentThreadId()), 0, 16));
}

void FilterWorker::processData(const QByteArray &data)
{
    ++m_processedCount;

    if (data.contains(m_pattern)) {
        ++m_matchedCount;
        emit dataMatched(data);
    }

    if (m_processedCount % 50 == 0)
        emit statsChanged(m_processedCount, m_matchedCount);
}

void FilterWorker::setFilterPattern(const QByteArray &pattern)
{
    m_pattern = pattern;
}

// ─── CollectorWorker ───────────────────────────────────────────────

CollectorWorker::CollectorWorker(QObject *parent)
    : QObject(parent)
{
}

void CollectorWorker::start()
{
    emit threadIdReady(QStringLiteral("0x%1")
        .arg(reinterpret_cast<quintptr>(QThread::currentThreadId()), 0, 16));
}

void CollectorWorker::collectData(const QByteArray &data)
{
    QMutexLocker lock(&m_mutex);

    if (m_records.size() >= MaxRecords)
        m_records.removeFirst();

    m_records.append({data, QDateTime::currentDateTimeUtc()});
    int count = m_records.size();
    lock.unlock();

    QString timestamp = QDateTime::currentDateTimeUtc().toString(Qt::ISODateWithMs);
    QString hex = data.toHex(' ').left(120);
    emit recordAdded(timestamp, hex, data.size());
    emit recordCountChanged(count);
}

int CollectorWorker::recordCount() const
{
    QMutexLocker lock(&m_mutex);
    return m_records.size();
}

QVariantList CollectorWorker::getRecords() const
{
    QMutexLocker lock(&m_mutex);
    QVariantList list;
    for (const auto &r : m_records) {
        QVariantMap map;
        map[QStringLiteral("timestamp")] = r.timestamp.toString(Qt::ISODateWithMs);
        map[QStringLiteral("hex")] = r.data.toHex(' ').left(120);
        map[QStringLiteral("size")] = r.data.size();
        list.append(map);
    }
    return list;
}

void CollectorWorker::clearRecords()
{
    QMutexLocker lock(&m_mutex);
    m_records.clear();
}
