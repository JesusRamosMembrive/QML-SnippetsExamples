qt_add_library(listsplugin STATIC)
qt_add_qml_module(listsplugin
    URI "lists"
    VERSION 1.0
    QML_FILES
        Main.qml
)
