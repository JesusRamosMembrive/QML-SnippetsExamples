#ifndef PIPELINEWORKERS_H
#define PIPELINEWORKERS_H

#include <QObject>
#include <QByteArray>
#include <QDateTime>
#include <QList>
#include <QMutex>
#include <QTimer>
#include <random>

// ─── Thread 1: Generator ───────────────────────────────────────────
// Produces random byte arrays at a configurable rate using QTimer.
// Lives on its own QThread via moveToThread().

class GeneratorWorker : public QObject
{
    Q_OBJECT

public:
    explicit GeneratorWorker(QObject *parent = nullptr);

public slots:
    void start();
    void stop();
    void setInterval(int ms);

signals:
    void dataGenerated(const QByteArray &data);
    void countChanged(int count);
    void threadIdReady(const QString &threadId);

private slots:
    void generate();

private:
    QTimer m_timer;
    std::mt19937 m_rng{std::random_device{}()};
    int m_count = 0;
    int m_interval = 10;
};

// ─── Thread 2: Filter ──────────────────────────────────────────────
// Receives byte arrays, searches for a target pattern, forwards matches.
// Slot processData() is called via cross-thread QueuedConnection.

class FilterWorker : public QObject
{
    Q_OBJECT

public:
    explicit FilterWorker(QObject *parent = nullptr);

public slots:
    void start();
    void processData(const QByteArray &data);
    void setFilterPattern(const QByteArray &pattern);

signals:
    void dataMatched(const QByteArray &data);
    void statsChanged(int processed, int matched);
    void threadIdReady(const QString &threadId);

private:
    QByteArray m_pattern{"\x00\x01\x02", 3};
    int m_processedCount = 0;
    int m_matchedCount = 0;
};

// ─── Thread 3: Collector ───────────────────────────────────────────
// Collects matched data with timestamps. Shared record list protected
// by QMutex since it's read from the main/QML thread.

class CollectorWorker : public QObject
{
    Q_OBJECT

public:
    explicit CollectorWorker(QObject *parent = nullptr);

    int recordCount() const;
    QVariantList getRecords() const;
    void clearRecords();

public slots:
    void start();
    void collectData(const QByteArray &data);

signals:
    void recordAdded(const QString &timestamp, const QString &hexData, int size);
    void recordCountChanged(int count);
    void threadIdReady(const QString &threadId);

private:
    struct Record {
        QByteArray data;
        QDateTime timestamp;
    };

    mutable QMutex m_mutex;
    QList<Record> m_records;
    static constexpr int MaxRecords = 500;
};

#endif // PIPELINEWORKERS_H
