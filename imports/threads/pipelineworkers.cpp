// ============================================================================
// pipelineworkers.cpp - Implementacion de los workers del pipeline
// ============================================================================
//
// Cada worker procesa datos en su propio hilo de fondo. Sus slots se ejecutan
// en el hilo al que fueron movidos con moveToThread(), NO en el hilo principal.
//
// Flujo del pipeline:
//   GeneratorWorker::generate()  [Hilo 1]
//        |
//        | emit dataGenerated(data)  -- signal cross-thread (QueuedConnection) -->
//        v
//   FilterWorker::processData()  [Hilo 2]
//        |
//        | emit dataMatched(data)    -- signal cross-thread (QueuedConnection) -->
//        v
//   CollectorWorker::collectData()  [Hilo 3]
// ============================================================================

#include "pipelineworkers.h"
#include <QThread>
#include <QMutexLocker>
#include <QVariantMap>

// ============================================================================
// GeneratorWorker - Produce datos aleatorios en el Hilo 1
// ============================================================================

GeneratorWorker::GeneratorWorker(QObject *parent)
    : QObject(parent)
    , m_timer(this)   // Parent timer to worker so moveToThread() moves both
{
    m_timer.setInterval(m_interval);
    // Esta conexion timer->generate es DIRECTA (mismo hilo).
    // El timer y el worker viven ambos en el Hilo 1.
    connect(&m_timer, &QTimer::timeout, this, &GeneratorWorker::generate);
}

// start() se invoca via QMetaObject::invokeMethod con Qt::QueuedConnection
// desde el hilo principal. Se ejecuta en el Hilo 1 (el event loop del
// QThread al que este worker fue movido).
void GeneratorWorker::start()
{
    m_count = 0;
    // QThread::currentThreadId() devuelve el ID del hilo ACTUAL de ejecucion,
    // que aqui es el Hilo 1 (no el principal), confirmando que moveToThread funciono.
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

// generate() se llama cada vez que el QTimer dispara (en el Hilo 1).
// Crea un array de bytes aleatorio y emite dataGenerated(), que cruza
// al Hilo 2 via QueuedConnection automatica.
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

// ============================================================================
// FilterWorker - Filtra datos en el Hilo 2
// ============================================================================

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

// processData() se ejecuta en el Hilo 2 cada vez que el Generador emite
// dataGenerated(). Qt encolo la llamada automaticamente porque emisor
// (Hilo 1) y receptor (Hilo 2) estan en hilos diferentes.
//
// El filtro busca si los datos contienen el patron m_pattern.
// Solo los datos que coinciden se reenvian al Colector via dataMatched().
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

// ============================================================================
// CollectorWorker - Recolecta resultados en el Hilo 3
// ============================================================================

CollectorWorker::CollectorWorker(QObject *parent)
    : QObject(parent)
{
}

void CollectorWorker::start()
{
    emit threadIdReady(QStringLiteral("0x%1")
        .arg(reinterpret_cast<quintptr>(QThread::currentThreadId()), 0, 16));
}

// collectData() se ejecuta en el Hilo 3. Almacena el dato filtrado
// con un timestamp UTC.
//
// USO DE QMutex:
// QMutexLocker bloquea el mutex al crearse y lo desbloquea al destruirse
// (patron RAII). Esto protege m_records porque otros hilos pueden llamar
// a recordCount() o getRecords() en cualquier momento.
//
// Nota: hacemos lock.unlock() ANTES de emitir signals para minimizar el
// tiempo que el mutex esta bloqueado. Las signals no acceden a m_records,
// asi que no necesitan el mutex.
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

// Estos metodos se llaman desde el hilo principal (QML). Por eso necesitan
// QMutexLocker para acceder a m_records de forma thread-safe.
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
