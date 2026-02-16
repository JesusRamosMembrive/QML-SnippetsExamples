qt_add_library(textinputsplugin STATIC)
qt_add_qml_module(textinputsplugin
    URI "textinputs"
    VERSION 1.0
    QML_FILES
        Main.qml
)
