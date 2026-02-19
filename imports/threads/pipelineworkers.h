// ============================================================================
// pipelineworkers.h - Workers (trabajadores) para el pipeline de hilos
// ============================================================================
//
// PATRON: QThread + moveToThread()
// ==================================
// Este es el patron RECOMENDADO por Qt para trabajar con hilos.
// La alternativa (heredar de QThread y sobreescribir run()) es mas limitada
// y propensa a errores.
//
// Como funciona:
//   1. Se crea un QObject normal (el "worker") con slots que hacen el trabajo
//   2. Se crea un QThread (que gestiona un event loop en segundo plano)
//   3. Se mueve el worker al hilo con worker->moveToThread(&thread)
//   4. Se inicia el hilo con thread.start()
//
// Por que moveToThread():
//   En Qt, un QObject procesa signals/slots en el hilo al que PERTENECE.
//   Al mover un worker a un QThread, todos sus slots se ejecutan en ese
//   hilo de fondo, NO en el hilo principal/GUI. Esto libera el hilo GUI
//   para que la interfaz no se congele.
//
// SIGNALS ENTRE HILOS (cross-thread):
//   Cuando el emisor y receptor de una conexion estan en hilos diferentes,
//   Qt automaticamente usa QueuedConnection. Esto significa que la signal
//   se serializa, se encola en el event loop del hilo receptor, y se
//   procesa de forma segura (thread-safe). No necesitas mutex para signals.
//
// En este pipeline tenemos 3 workers, cada uno en su propio hilo:
//   [Generador] --signal--> [Filtro] --signal--> [Colector]
//     Hilo 1                  Hilo 2               Hilo 3
// ============================================================================

#ifndef PIPELINEWORKERS_H
#define PIPELINEWORKERS_H

#include <QObject>
#include <QByteArray>
#include <QDateTime>
#include <QList>
#include <QMutex>
#include <QTimer>
#include <random>

// ============================================================================
// GeneratorWorker - Hilo 1: Generador de datos
// ============================================================================
// Produce arrays de bytes aleatorios a un ritmo configurable usando QTimer.
// Vive en su propio QThread via moveToThread().
//
// Nota importante: QTimer es hijo del worker (m_timer(this) en el constructor).
// Cuando hacemos moveToThread() sobre el worker, Qt mueve automaticamente
// todos los hijos tambien. Esto es CRITICO porque QTimer debe vivir en el
// mismo hilo que su padre para funcionar correctamente.

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
    // Esta signal cruza la frontera de hilos: se emite en el Hilo 1
    // y se recibe en el Hilo 2 (FilterWorker::processData).
    // Qt usa QueuedConnection automaticamente -> thread-safe.
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

// ============================================================================
// FilterWorker - Hilo 2: Filtro de datos
// ============================================================================
// Recibe arrays de bytes, busca un patron objetivo, y reenvia los que coinciden.
// El slot processData() se invoca via QueuedConnection cross-thread:
// el Generador emite dataGenerated() en el Hilo 1, y Qt encola la llamada
// a processData() en el event loop del Hilo 2. Asi el filtrado ocurre en
// un hilo separado sin bloquear ni al generador ni al GUI.

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
    // Signal cross-thread: Hilo 2 -> Hilo 3
    void dataMatched(const QByteArray &data);
    void statsChanged(int processed, int matched);
    void threadIdReady(const QString &threadId);

private:
    QByteArray m_pattern{"\x00\x01\x02", 3};
    int m_processedCount = 0;
    int m_matchedCount = 0;
};

// ============================================================================
// CollectorWorker - Hilo 3: Colector de resultados
// ============================================================================
// Recolecta datos que pasaron el filtro y los almacena con timestamp.
//
// PROTECCION CON QMutex:
// La lista m_records se escribe desde el Hilo 3 (collectData) pero se LEE
// desde el hilo principal/QML (getRecords, recordCount, clearRecords).
// Las signals cross-thread son thread-safe automaticamente, pero el acceso
// directo a datos compartidos (como leer m_records desde otro hilo) SI
// necesita proteccion con mutex.
//
// "mutable QMutex" permite usar el mutex en metodos const (como recordCount).

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
