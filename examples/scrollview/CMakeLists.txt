qt_add_library(scrollviewplugin STATIC)
qt_add_qml_module(scrollviewplugin
    URI "scrollview"
    VERSION 1.0
    QML_FILES
        Main.qml
        BasicScrollCard.qml
        CustomScrollBarCard.qml
        FlickableCard.qml
        InteractiveScrollCard.qml
)
