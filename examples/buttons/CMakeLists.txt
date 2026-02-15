qt_add_library(buttons STATIC)
qt_add_qml_module(buttons
    URI "buttons"
    VERSION 1.0
    QML_FILES
        Main.qml
)
