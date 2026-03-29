qt_add_library(multiplaneplugin STATIC)
qt_add_qml_module(multiplaneplugin
    URI "multiplane"
    VERSION 1.0
    QML_FILES
        Main.qml
        MultiplaneScene.qml
        SceneLayer.qml
)
