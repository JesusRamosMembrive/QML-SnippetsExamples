qt_add_library(slidersplugin STATIC)
qt_add_qml_module(slidersplugin
    URI "sliders"
    VERSION 1.0
    QML_FILES
        Main.qml
)
