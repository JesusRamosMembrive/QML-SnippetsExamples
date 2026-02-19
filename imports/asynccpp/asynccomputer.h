// =============================================================================
// AsyncComputer - Computacion asincrona simple con QtConcurrent
// =============================================================================
//
// Esta clase demuestra el patron basico de QtConcurrent:
//   1. Crear una funcion lambda con el calculo pesado
//   2. Lanzarla con QtConcurrent::run() -> devuelve un QFuture<QString>
//   3. Monitorear con QFutureWatcher -> emite finished() cuando termina
//   4. Leer el resultado y notificar a QML via signals
//
// QFuture<T>: representa un resultado asincrono de tipo T. No bloquea el hilo
// principal; es como una "promesa" de que el resultado llegara eventualmente.
//
// QFutureWatcher<T>: observa un QFuture y emite signals de Qt cuando el estado
// cambia (finished, canceled, progressValueChanged). Esto es lo que permite
// conectar el mundo asincrono de QtConcurrent con el event loop de Qt/QML.
//
// QElapsedTimer: cronometro de alta precision para medir cuanto tarda cada
// operacion (permite mostrar los milisegundos en la UI).
//
// Por que no usar QThread directamente?
//   - QThread requiere crear una subclase o un worker object, moverlo al hilo,
//     y gestionar el ciclo de vida manualmente.
//   - QtConcurrent::run() es una sola linea: le pasas un lambda y listo.
//   - Internamente usa QThreadPool, que reutiliza hilos automaticamente.
//   - Perfecto para calculos puntuales que no necesitan un hilo permanente.
// =============================================================================

#ifndef ASYNCCOMPUTER_H
#define ASYNCCOMPUTER_H

#include <QObject>
#include <QFutureWatcher>
#include <QElapsedTimer>
#include <QtQml/qqmlregistration.h>

class AsyncComputer : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    // Propiedades expuestas a QML para binding reactivo
    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
    Q_PROPERTY(QString result READ result NOTIFY resultChanged)
    Q_PROPERTY(int elapsedMs READ elapsedMs NOTIFY elapsedMsChanged)

public:
    explicit AsyncComputer(QObject *parent = nullptr);
    ~AsyncComputer() override;

    bool running() const { return m_running; }
    QString result() const { return m_result; }
    int elapsedMs() const { return m_elapsedMs; }

    // Metodos Q_INVOKABLE: invocables directamente desde QML
    // Cada uno lanza un calculo diferente en un hilo secundario
    Q_INVOKABLE void countPrimes(int limit);
    Q_INVOKABLE void computeFibonacci(int n);
    Q_INVOKABLE void sortRandom(int count);

signals:
    void runningChanged();
    void resultChanged();
    void elapsedMsChanged();

private:
    // Metodo generico que acepta cualquier funcion QString() y la ejecuta
    // en un hilo del pool via QtConcurrent::run()
    void start(std::function<QString()> func);

    // QFutureWatcher<QString>: observa el QFuture devuelto por QtConcurrent::run().
    // Cuando el calculo termina, emite finished() y podemos leer el resultado
    // con m_watcher.result().
    QFutureWatcher<QString> m_watcher;

    // Cronometro para medir la duracion de cada operacion
    QElapsedTimer m_timer;

    bool m_running = false;
    QString m_result;
    int m_elapsedMs = 0;
};

#endif
