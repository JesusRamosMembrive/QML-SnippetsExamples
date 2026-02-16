qt_add_library(layoutsplugin STATIC)
qt_add_qml_module(layoutsplugin
    URI "layouts"
    VERSION 1.0
    QML_FILES
        Main.qml
)
