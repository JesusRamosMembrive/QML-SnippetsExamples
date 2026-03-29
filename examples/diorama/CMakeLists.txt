qt_add_library(dioramaplugin STATIC)
qt_add_qml_module(dioramaplugin
    URI "diorama"
    VERSION 1.0
    QML_FILES
        Main.qml
)
