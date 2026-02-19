#ifndef ASYNCTASK_H
#define ASYNCTASK_H

#include <QObject>
#include <QFutureWatcher>
#include <QStringList>
#include <QtQml/qqmlregistration.h>

class AsyncTask : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
    Q_PROPERTY(double progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)
    Q_PROPERTY(QStringList results READ results NOTIFY resultsChanged)

public:
    explicit AsyncTask(QObject *parent = nullptr);
    ~AsyncTask() override;

    bool running() const { return m_running; }
    double progress() const { return m_progress; }
    QString status() const { return m_status; }
    QStringList results() const { return m_results; }

    Q_INVOKABLE void runSteps(int totalSteps);
    Q_INVOKABLE void processItems(const QStringList &items);
    Q_INVOKABLE void cancel();

signals:
    void runningChanged();
    void progressChanged();
    void statusChanged();
    void resultsChanged();

private:
    void setRunning(bool r);
    void setProgress(double p);
    void setStatus(const QString &s);

    QFutureWatcher<void> m_watcher;
    bool m_running = false;
    double m_progress = 0.0;
    QString m_status;
    QStringList m_results;
};

#endif
