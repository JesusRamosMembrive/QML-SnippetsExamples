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

    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
    Q_PROPERTY(QString result READ result NOTIFY resultChanged)
    Q_PROPERTY(int elapsedMs READ elapsedMs NOTIFY elapsedMsChanged)

public:
    explicit AsyncComputer(QObject *parent = nullptr);
    ~AsyncComputer() override;

    bool running() const { return m_running; }
    QString result() const { return m_result; }
    int elapsedMs() const { return m_elapsedMs; }

    Q_INVOKABLE void countPrimes(int limit);
    Q_INVOKABLE void computeFibonacci(int n);
    Q_INVOKABLE void sortRandom(int count);

signals:
    void runningChanged();
    void resultChanged();
    void elapsedMsChanged();

private:
    void start(std::function<QString()> func);

    QFutureWatcher<QString> m_watcher;
    QElapsedTimer m_timer;
    bool m_running = false;
    QString m_result;
    int m_elapsedMs = 0;
};

#endif
