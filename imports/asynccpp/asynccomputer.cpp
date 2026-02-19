// =============================================================================
// AsyncComputer - Implementacion
// =============================================================================
//
// Flujo de ejecucion:
//   1. QML llama a countPrimes()/computeFibonacci()/sortRandom()
//   2. Cada metodo crea un lambda con el calculo y llama a start()
//   3. start() lanza el lambda con QtConcurrent::run() en un hilo del pool
//   4. El lambda se ejecuta en segundo plano (NO bloquea la UI)
//   5. QFutureWatcher detecta que el Future termino y emite finished()
//   6. En el slot connected, leemos el resultado y emitimos signals a QML
//
// Nota importante: los lambdas que se pasan a QtConcurrent::run() se ejecutan
// en un hilo diferente al principal. NO pueden tocar directamente propiedades
// de QObject ni emitir signals. Por eso el resultado se lee despues, en el
// slot finished() que corre en el hilo principal.
// =============================================================================

#include "asynccomputer.h"
#include <QtConcurrent>
#include <QRandomGenerator>
#include <algorithm>

AsyncComputer::AsyncComputer(QObject *parent) : QObject(parent)
{
    // Conectamos la signal finished() del watcher a un lambda que:
    // 1. Lee el resultado del Future (m_watcher.result())
    // 2. Registra el tiempo transcurrido
    // 3. Notifica a QML que la operacion termino
    //
    // Esta conexion se ejecuta en el hilo principal (Qt::AutoConnection por defecto),
    // asi que es seguro modificar propiedades y emitir signals aqui.
    connect(&m_watcher, &QFutureWatcher<QString>::finished, this, [this]() {
        m_result = m_watcher.result();
        m_elapsedMs = static_cast<int>(m_timer.elapsed());
        m_running = false;
        emit resultChanged();
        emit elapsedMsChanged();
        emit runningChanged();
    });
}

AsyncComputer::~AsyncComputer()
{
    // Limpieza al destruir: cancelamos cualquier tarea pendiente y esperamos
    // a que termine. Sin esto, el hilo podria seguir accediendo a miembros
    // del objeto despues de que este sea destruido -> crash.
    m_watcher.cancel();
    m_watcher.waitForFinished();
}

// start() - Metodo generico para lanzar cualquier funcion asincrona
//
// Patron: recibir un std::function<QString()>, ejecutarla con
// QtConcurrent::run(), y asociar el QFuture resultante al watcher.
//
// QtConcurrent::run(func) hace lo siguiente internamente:
//   1. Toma un hilo libre del QThreadPool::globalInstance()
//   2. Ejecuta func() en ese hilo
//   3. Devuelve un QFuture<QString> que contendra el resultado
void AsyncComputer::start(std::function<QString()> func)
{
    if (m_running) return;
    m_running = true;
    m_result.clear();
    m_elapsedMs = 0;
    emit runningChanged();
    emit resultChanged();
    emit elapsedMsChanged();

    m_timer.start();
    // QtConcurrent::run() lanza la funcion en un hilo del pool global.
    // El QFuture devuelto se asigna al watcher, que emitira finished()
    // cuando el calculo termine.
    m_watcher.setFuture(QtConcurrent::run(std::move(func)));
}

// countPrimes - Cuenta numeros primos hasta 'limit' usando fuerza bruta.
// Es un calculo CPU-intensivo ideal para demostrar threading:
// con numeros grandes (1M+), tardaria segundos y congelaria la UI si
// se ejecutara en el hilo principal.
void AsyncComputer::countPrimes(int limit)
{
    start([limit]() -> QString {
        int count = 0;
        for (int n = 2; n <= limit; n++) {
            bool prime = true;
            for (int i = 2; i * i <= n; i++) {
                if (n % i == 0) { prime = false; break; }
            }
            if (prime) count++;
        }
        return QString("%1 primes found (up to %2)")
            .arg(count).arg(QLocale().toString(limit));
    });
}

// computeFibonacci - Calcula el n-esimo numero de Fibonacci iterativamente.
// Aunque es rapido para valores normales, demuestra el patron asincrono.
void AsyncComputer::computeFibonacci(int n)
{
    start([n]() -> QString {
        if (n < 0)
            return QStringLiteral("Invalid input: n must be >= 0");
        if (n > 92)
            return QString("fib(%1) overflows 64-bit (max supported n is 92)").arg(n);
        if (n == 0)
            return QStringLiteral("fib(0) = 0");
        if (n == 1)
            return QStringLiteral("fib(1) = 1");

        long long a = 0, b = 1;
        for (int i = 2; i <= n; i++) {
            long long c = a + b;
            a = b;
            b = c;
        }
        return QString("fib(%1) = %2").arg(n).arg(QLocale().toString(b));
    });
}

// sortRandom - Genera 'count' numeros aleatorios y los ordena.
// Con millones de elementos, el sort tarda lo suficiente como para
// apreciar que la UI no se congela durante la operacion.
void AsyncComputer::sortRandom(int count)
{
    start([count]() -> QString {
        if (count <= 0)
            return QStringLiteral("Invalid input: count must be > 0");

        std::vector<int> data(count);
        auto *rng = QRandomGenerator::global();
        for (int i = 0; i < count; i++)
            data[i] = rng->bounded(1000000);
        std::sort(data.begin(), data.end());
        if (data.empty())
            return QStringLiteral("Sorted 0 numbers");

        return QString("Sorted %1 numbers (min: %2, max: %3)")
            .arg(QLocale().toString(count))
            .arg(data.front()).arg(data.back());
    });
}
