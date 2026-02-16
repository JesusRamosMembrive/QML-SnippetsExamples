qt_add_library(popupsplugin STATIC)
qt_add_qml_module(popupsplugin
    URI "popups"
    VERSION 1.0
    QML_FILES
        Main.qml
)
