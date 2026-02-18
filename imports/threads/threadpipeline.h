#ifndef THREADPIPELINE_H
#define THREADPIPELINE_H

#include <QObject>
#include <QThread>
#include <QByteArray>
#include <QtQml/qqmlregistration.h>

class GeneratorWorker;
class FilterWorker;
class CollectorWorker;

class ThreadPipeline : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
    Q_PROPERTY(int generatedCount READ generatedCount NOTIFY generatedCountChanged)
    Q_PROPERTY(int processedCount READ processedCount NOTIFY processedCountChanged)
    Q_PROPERTY(int matchedCount READ matchedCount NOTIFY matchedCountChanged)
    Q_PROPERTY(int recordCount READ recordCount NOTIFY recordCountChanged)
    Q_PROPERTY(QString mainThreadId READ mainThreadId CONSTANT)
    Q_PROPERTY(QString generatorThreadId READ generatorThreadId NOTIFY generatorThreadIdChanged)
    Q_PROPERTY(QString filterThreadId READ filterThreadId NOTIFY filterThreadIdChanged)
    Q_PROPERTY(QString collectorThreadId READ collectorThreadId NOTIFY collectorThreadIdChanged)
    Q_PROPERTY(int generationInterval READ generationInterval WRITE setGenerationInterval NOTIFY generationIntervalChanged)
    Q_PROPERTY(QString filterPatternHex READ filterPatternHex NOTIFY filterPatternChanged)

public:
    explicit ThreadPipeline(QObject *parent = nullptr);
    ~ThreadPipeline() override;

    bool running() const;
    int generatedCount() const;
    int processedCount() const;
    int matchedCount() const;
    int recordCount() const;
    QString mainThreadId() const;
    QString generatorThreadId() const;
    QString filterThreadId() const;
    QString collectorThreadId() const;
    int generationInterval() const;
    void setGenerationInterval(int ms);
    QString filterPatternHex() const;

    Q_INVOKABLE void start();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void clear();
    Q_INVOKABLE void setFilterPattern(const QVariantList &bytes);

signals:
    void runningChanged();
    void generatedCountChanged();
    void processedCountChanged();
    void matchedCountChanged();
    void recordCountChanged();
    void generatorThreadIdChanged();
    void filterThreadIdChanged();
    void collectorThreadIdChanged();
    void generationIntervalChanged();
    void filterPatternChanged();
    void recordAdded(const QString &timestamp, const QString &hexData, int size);

private:
    void cleanupThreads();

    bool m_running = false;
    int m_generatedCount = 0;
    int m_processedCount = 0;
    int m_matchedCount = 0;
    int m_generationInterval = 10;
    QByteArray m_filterPattern{"\x00\x01\x02", 3};

    QString m_generatorThreadId;
    QString m_filterThreadId;
    QString m_collectorThreadId;

    QThread m_generatorThread;
    QThread m_filterThread;
    QThread m_collectorThread;

    GeneratorWorker *m_generator = nullptr;
    FilterWorker *m_filter = nullptr;
    CollectorWorker *m_collector = nullptr;
};

#endif // THREADPIPELINE_H
