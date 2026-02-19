#include "signalbridge.h"

// Constructor: inicializa la lista de pasos y conecta QTimer::timeout -> onTick.
// El timer disparara onTick() cada 500ms cuando este activo.
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

// startTask: reinicia el estado y arranca el timer.
// Emite runningChanged y progressChanged para que los bindings de QML
// se actualicen inmediatamente (ej: una barra de progreso se pone a 0).
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

// stopTask: detiene el timer, reinicia todo, y emite errorOccurred para
// informar a QML que la tarea fue cancelada. Esto permite que QML muestre
// un mensaje de cancelacion al usuario.
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

// emitCustom: demuestra que Q_INVOKABLE puede disparar signals.
// QML llama un metodo -> el metodo emite una signal -> QML tambien
// escucha esa signal. Esta comunicacion bidireccional es un patron
// muy poderoso: metodo para iniciar la accion, signal para el resultado.
void SignalBridge::emitCustom(const QString &message)
{
    emit customSignal(message);
}

// onTick: llamado cada 500ms por el QTimer.
// Emite dataReceived con el texto del paso actual para que QML lo muestre.
// Actualiza el progreso como fraccion (paso/total), ej: 3/10 = 0.3.
// Cuando todos los pasos terminan, detiene el timer y emite taskCompleted.
// Este patron simula una operacion asincrona real (como descargar archivos
// paso a paso o procesar datos en etapas).
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
