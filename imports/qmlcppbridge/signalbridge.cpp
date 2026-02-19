#include "signalbridge.h"

SignalBridge::SignalBridge(QObject *parent) : QObject(parent)
{
    m_steps << "Initializing module..."
            << "Loading configuration..."
            << "Connecting to service..."
            << "Authenticating..."
            << "Fetching data batch 1..."
            << "Fetching data batch 2..."
            << "Processing results..."
            << "Validating output..."
            << "Finalizing..."
            << "Done!";

    connect(&m_timer, &QTimer::timeout, this, &SignalBridge::onTick);
}

void SignalBridge::startTask()
{
    if (m_running) return;
    m_running = true;
    m_progress = 0.0;
    m_step = 0;
    emit runningChanged();
    emit progressChanged();
    m_timer.start(500);
}

void SignalBridge::stopTask()
{
    m_timer.stop();
    m_running = false;
    m_progress = 0.0;
    m_step = 0;
    emit runningChanged();
    emit progressChanged();
    emit errorOccurred("Task cancelled by user");
}

void SignalBridge::emitCustom(const QString &message)
{
    emit customSignal(message);
}

void SignalBridge::onTick()
{
    if (m_step < m_steps.size()) {
        emit dataReceived(m_steps[m_step]);
        m_progress = static_cast<double>(m_step + 1) / m_steps.size();
        emit progressChanged();
        m_step++;
    }

    if (m_step >= m_steps.size()) {
        m_timer.stop();
        m_running = false;
        emit runningChanged();
        emit taskCompleted("All " + QString::number(m_steps.size()) + " steps completed");
    }
}
