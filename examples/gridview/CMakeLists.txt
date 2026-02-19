qt_add_library(gridviewplugin STATIC)
qt_add_qml_module(gridviewplugin
    URI "gridview"
    VERSION 1.0
    QML_FILES
        Main.qml
        BasicGridCard.qml
        PhotoGridCard.qml
        DynamicGridCard.qml
        InteractiveGridCard.qml
)
