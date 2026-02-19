qt_add_library(pathviewplugin STATIC)
qt_add_qml_module(pathviewplugin
    URI "pathview"
    VERSION 1.0
    QML_FILES
        Main.qml
        CircularPathCard.qml
        ArcPathCard.qml
        CoverFlowCard.qml
        InteractivePathCard.qml
)
