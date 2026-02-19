# ==============================================================================
# Modulo QML-C++ Bridge — Tres clases en un solo modulo QML
# ==============================================================================
#
# Este modulo contiene tres clases C++, cada una demostrando un mecanismo
# diferente de comunicacion entre QML y C++:
#
#   PropertyBridge  → Q_PROPERTY (data binding bidireccional entre C++ y QML)
#   MethodBridge    → Q_INVOKABLE + Q_ENUM (llamar funciones C++ desde QML
#                     con parametros tipados, incluyendo enums)
#   SignalBridge    → signals (C++ notifica a QML de eventos asincronamente)
#
# Qt6::Gui es necesario porque algunas propiedades usan el tipo QColor,
# que pertenece al modulo QtGui (no a QtCore).
# ==============================================================================

qt_add_library(qmlcppbridgeplugin STATIC)
qt_add_qml_module(qmlcppbridgeplugin
    URI "qmlcppbridge"
    VERSION 1.0
    SOURCES
        propertybridge.h propertybridge.cpp
        methodbridge.h methodbridge.cpp
        signalbridge.h signalbridge.cpp
)
target_link_libraries(qmlcppbridgeplugin PRIVATE Qt6::Qml Qt6::Gui)
