qt_add_library(switchesplugin STATIC)
qt_add_qml_module(switchesplugin
    URI "switches"
    VERSION 1.0
    QML_FILES
        Main.qml
)
