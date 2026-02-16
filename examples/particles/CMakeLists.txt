qt_add_library(particlesplugin STATIC)
qt_add_qml_module(particlesplugin
    URI "particles"
    VERSION 1.0
    QML_FILES
        Main.qml
)
