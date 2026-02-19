#include "asynctask.h"
#include <QtConcurrent>
#include <QThread>

AsyncTask::AsyncTask(QObject *parent) : QObject(parent)
{
    connect(&m_watcher, &QFutureWatcher<void>::progressValueChanged,
            this, [this](int value) {
        int range = m_watcher.progressMaximum() - m_watcher.progressMinimum();
        m_progress = range > 0 ? static_cast<double>(value) / range : 0.0;
        emit progressChanged();
    });

    connect(&m_watcher, &QFutureWatcher<void>::finished, this, [this]() {
        if (m_watcher.isCanceled())
            setStatus("Cancelled");
        else {
            setProgress(1.0);
            setStatus("Completed");
        }
        setRunning(false);
    });
}

AsyncTask::~AsyncTask()
{
    m_watcher.cancel();
    m_watcher.waitForFinished();
}

void AsyncTask::setRunning(bool r)
{
    if (m_running != r) { m_running = r; emit runningChanged(); }
}

void AsyncTask::setProgress(double p)
{
    if (!qFuzzyCompare(m_progress, p)) { m_progress = p; emit progressChanged(); }
}

void AsyncTask::setStatus(const QString &s)
{
    if (m_status != s) { m_status = s; emit statusChanged(); }
}

void AsyncTask::runSteps(int totalSteps)
{
    if (m_running) return;
    setRunning(true);
    setProgress(0);
    setStatus("Starting...");
    m_results.clear();
    emit resultsChanged();

    static const QStringList stepNames = {
        "Initializing", "Loading data", "Parsing config",
        "Validating input", "Processing batch", "Analyzing results",
        "Compiling output", "Optimizing", "Finalizing", "Cleaning up"
    };

    auto future = QtConcurrent::run([this, totalSteps](QPromise<void> &promise) {
        promise.setProgressRange(0, totalSteps);

        for (int i = 0; i < totalSteps; i++) {
            if (promise.isCanceled()) return;

            QString name = (i < stepNames.size()) ? stepNames[i]
                         : QString("Step %1").arg(i + 1);

            QMetaObject::invokeMethod(this, [this, name, i, totalSteps]() {
                setStatus(QString("%1 (%2/%3)").arg(name).arg(i + 1).arg(totalSteps));
            }, Qt::QueuedConnection);

            QThread::msleep(300);
            promise.setProgressValue(i + 1);
        }
    });

    m_watcher.setFuture(future);
}

void AsyncTask::processItems(const QStringList &items)
{
    if (m_running) return;
    setRunning(true);
    setProgress(0);
    setStatus("Processing items...");
    m_results.clear();
    emit resultsChanged();

    auto future = QtConcurrent::run([this, items](QPromise<void> &promise) {
        promise.setProgressRange(0, items.size());

        for (int i = 0; i < items.size(); i++) {
            if (promise.isCanceled()) return;

            QThread::msleep(400);

            QString reversed;
            const QString &src = items[i];
            reversed.reserve(src.size());
            for (int j = src.size() - 1; j >= 0; --j)
                reversed.append(src[j]);

            QString result = src + "  ->  " + reversed.toUpper();

            QMetaObject::invokeMethod(this, [this, result, i, total = items.size()]() {
                m_results.append(result);
                emit resultsChanged();
                setStatus(QString("Processed %1/%2").arg(i + 1).arg(total));
            }, Qt::QueuedConnection);

            promise.setProgressValue(i + 1);
        }
    });

    m_watcher.setFuture(future);
}

void AsyncTask::cancel()
{
    if (m_running)
        m_watcher.cancel();
}
