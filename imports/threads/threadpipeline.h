// ============================================================================
// threadpipeline.h - Controlador del pipeline expuesto a QML
// ============================================================================
//
// Esta clase es la FACHADA del pipeline de hilos. Es el unico punto de
// contacto entre QML y los workers de fondo. QML interactua con esta clase;
// esta clase gestiona los hilos y workers internamente.
//
// REGISTRO EN QML:
//   Q_OBJECT  - Habilita el sistema de meta-objetos de Qt (signals, slots,
//               propiedades). OBLIGATORIO para cualquier clase que use signals/slots.
//   QML_ELEMENT - Registra automaticamente la clase en el modulo QML definido
//               en CMakeLists.txt. En QML se usa directamente:
//                 import threads
//                 ThreadPipeline { ... }
//
// Q_PROPERTY:
//   Expone propiedades C++ a QML con soporte para data binding.
//   Formato: Q_PROPERTY(tipo nombre READ getter NOTIFY signal)
//   QML puede hacer: text: pipeline.generatedCount y se actualiza reactivamente.
//
// Q_INVOKABLE:
//   Permite llamar metodos C++ directamente desde QML:
//     pipeline.start(), pipeline.stop(), pipeline.clear()
//   Alternativa a declarar un slot publico (los slots tambien son invocables).
// ============================================================================

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

    // ─── Propiedades expuestas a QML ────────────────────────────────
    // Cada Q_PROPERTY necesita al minimo READ y NOTIFY.
    // READ: funcion que devuelve el valor actual.
    // NOTIFY: signal que se emite cuando el valor cambia (para data binding).
    // WRITE: funcion setter (opcional, solo si QML puede modificar el valor).
    // CONSTANT: el valor nunca cambia (no necesita NOTIFY).
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

    // Getters para Q_PROPERTY
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

    // ─── Metodos invocables desde QML ───────────────────────────────
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
    // Signal reenviada desde CollectorWorker para que QML reciba registros
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

    // ─── Los 3 QThreads del pipeline ────────────────────────────────
    // Cada QThread gestiona un event loop en segundo plano.
    // Los workers se mueven a estos hilos con moveToThread().
    QThread m_generatorThread;
    QThread m_filterThread;
    QThread m_collectorThread;

    // ─── Punteros a los workers ─────────────────────────────────────
    // Se crean con new SIN parent (requisito de moveToThread).
    // Se destruyen automaticamente via QThread::finished -> deleteLater.
    GeneratorWorker *m_generator = nullptr;
    FilterWorker *m_filter = nullptr;
    CollectorWorker *m_collector = nullptr;
};

#endif // THREADPIPELINE_H
