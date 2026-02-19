#include "asynccomputer.h"
#include <QtConcurrent>
#include <QRandomGenerator>
#include <algorithm>

AsyncComputer::AsyncComputer(QObject *parent) : QObject(parent)
{
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
    m_watcher.cancel();
    m_watcher.waitForFinished();
}

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
    m_watcher.setFuture(QtConcurrent::run(std::move(func)));
}

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

void AsyncComputer::computeFibonacci(int n)
{
    start([n]() -> QString {
        if (n <= 0) return QStringLiteral("fib(0) = 0");
        long long a = 0, b = 1;
        for (int i = 2; i <= n; i++) {
            long long c = a + b;
            a = b;
            b = c;
        }
        return QString("fib(%1) = %2").arg(n).arg(b);
    });
}

void AsyncComputer::sortRandom(int count)
{
    start([count]() -> QString {
        std::vector<int> data(count);
        auto *rng = QRandomGenerator::global();
        for (int i = 0; i < count; i++)
            data[i] = rng->bounded(1000000);
        std::sort(data.begin(), data.end());
        return QString("Sorted %1 numbers (min: %2, max: %3)")
            .arg(QLocale().toString(count))
            .arg(data.front()).arg(data.back());
    });
}
