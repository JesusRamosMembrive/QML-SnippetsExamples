qt_add_library(indicatorsplugin STATIC)
qt_add_qml_module(indicatorsplugin
    URI "indicators"
    VERSION 1.0
    QML_FILES
        Main.qml
)
