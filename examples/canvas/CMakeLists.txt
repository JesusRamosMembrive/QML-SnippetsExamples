qt_add_library(canvasplugin STATIC)
qt_add_qml_module(canvasplugin
    URI "canvas"
    VERSION 1.0
    QML_FILES
        Main.qml
)
