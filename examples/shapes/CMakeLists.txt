qt_add_library(shapesplugin STATIC)
qt_add_qml_module(shapesplugin
    URI "shapes"
    VERSION 1.0
    QML_FILES
        Main.qml
)
