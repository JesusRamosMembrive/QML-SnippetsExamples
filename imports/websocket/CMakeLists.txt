qt_add_library(websocketplugin STATIC)
qt_add_qml_module(websocketplugin
    URI "websocket"
    VERSION 1.0
    SOURCES
        websocketclient.h
        websocketclient.cpp
)
target_link_libraries(websocketplugin PRIVATE Qt6::WebSockets)
