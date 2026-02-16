qt_add_library(websocketexplugin STATIC)
qt_add_qml_module(websocketexplugin
    URI "websocketex"
    VERSION 1.0
    QML_FILES
        Main.qml
)
