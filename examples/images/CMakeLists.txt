qt_add_library(imagesplugin STATIC)
qt_add_qml_module(imagesplugin
    URI "images"
    VERSION 1.0
    QML_FILES
        Main.qml
        FillModeCard.qml
        BorderImageCard.qml
        MaskImageCard.qml
        InteractiveImageCard.qml
)
