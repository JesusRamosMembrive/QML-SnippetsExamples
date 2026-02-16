qt_add_library(animationsplugin STATIC)
qt_add_qml_module(animationsplugin
    URI "animations"
    VERSION 1.0
    QML_FILES
        Main.qml
)
