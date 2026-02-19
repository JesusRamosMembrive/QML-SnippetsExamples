# ==============================================================================
# asynccpp - Modulo QML con backend C++ para operaciones asincronas
# ==============================================================================
#
# Este modulo demuestra como usar QtConcurrent para ejecutar tareas pesadas
# en hilos secundarios sin bloquear la interfaz grafica (hilo principal/GUI).
#
# QtConcurrent vs QThread:
#   - QtConcurrent es la API de alto nivel de Qt para threading. Ideal para
#     computaciones "fire-and-forget": le pasas una funcion y te devuelve
#     un QFuture con el resultado.
#   - QThread es mas apropiado para objetos trabajadores de larga duracion
#     que necesitan su propio event loop.
#   - QtConcurrent usa automaticamente el QThreadPool global de Qt, asi que
#     no tienes que gestionar hilos manualmente.
#
# Clases incluidas:
#   - AsyncComputer: ejecuta calculos pesados (primos, fibonacci, sort) con
#     QtConcurrent::run() y QFutureWatcher para notificar a QML al terminar.
#   - AsyncTask: demuestra QPromise para reportar progreso incremental y
#     soportar cancelacion desde QML.
#
# Dependencia clave: Qt6::Concurrent (proporciona QtConcurrent::run, QFuture,
# QFutureWatcher, QPromise).
# ==============================================================================

qt_add_library(asynccppplugin STATIC)
qt_add_qml_module(asynccppplugin
    URI "asynccpp"
    VERSION 1.0
    SOURCES
        asynccomputer.h asynccomputer.cpp
        asynctask.h asynctask.cpp
)
target_link_libraries(asynccppplugin PRIVATE Qt6::Concurrent)
