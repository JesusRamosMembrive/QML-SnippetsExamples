qt_add_library(visualeffectsplugin STATIC)
qt_add_qml_module(visualeffectsplugin
    URI "visualeffects"
    VERSION 1.0
    QML_FILES
        Main.qml
)
