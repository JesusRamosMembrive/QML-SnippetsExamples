# =============================================================================
# CMakeLists.txt — Modulo C++ backend para WebSocket
# =============================================================================
#
# PATRON: Modulo C++ backend (sin archivos QML, solo SOURCES de C++)
# -----------------------------------------------------------------------
# A diferencia de los modulos QML puros (que usan QML_FILES), este modulo
# registra clases C++ directamente en el sistema QML usando SOURCES.
#
# SOURCES le dice a CMake que estos archivos .h/.cpp contienen tipos C++
# decorados con QML_ELEMENT. El MOC + CMake generan automaticamente el
# codigo de registro en tiempo de compilacion.
#
# La clase C++ (WebSocketClient) queda auto-registrada bajo el URI "websocket",
# permitiendo usarla en QML asi:
#     import websocket
#     WebSocketClient { url: "wss://..." }
#
# target_link_libraries enlaza Qt6::WebSockets SOLO para este modulo
# (PRIVATE), sin propagarlo al resto de la app. Cada modulo gestiona
# sus propias dependencias de Qt.
#
# IMPORTANTE — Nombre de enlace (link target):
# La libreria se llama "websocketplugin", pero qt_add_qml_module() le
# agrega automaticamente el sufijo "plugin", asi que el target para
# target_link_libraries en /qmlmodules es "websocketpluginplugin"
# (doble sufijo). Este patron aplica a todos los modulos de ejemplo.
# =============================================================================

qt_add_library(websocketplugin STATIC)
qt_add_qml_module(websocketplugin
    URI "websocket"
    VERSION 1.0
    SOURCES
        websocketclient.h
        websocketclient.cpp
)
target_link_libraries(websocketplugin PRIVATE Qt6::WebSockets)
