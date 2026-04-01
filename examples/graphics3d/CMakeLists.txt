qt_add_library(graphics3dplugin STATIC)
qt_add_qml_module(graphics3dplugin
    URI "graphics3d"
    VERSION 1.0
    QML_FILES
        Main.qml
)
