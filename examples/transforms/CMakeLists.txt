qt_add_library(transformsplugin STATIC)
qt_add_qml_module(transformsplugin
    URI "transforms"
    VERSION 1.0
    QML_FILES
        Main.qml
)
