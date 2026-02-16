qt_add_library(hudplugin STATIC)
qt_add_qml_module(hudplugin
    URI "hud"
    VERSION 1.0
    QML_FILES
        Main.qml
)
