qt_add_library(dateplugin STATIC)
qt_add_qml_module(dateplugin
    URI "date"
    VERSION 1.0
    QML_FILES
        Main.qml
)
