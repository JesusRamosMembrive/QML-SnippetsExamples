qt_add_library(menubarplugin STATIC)
qt_add_qml_module(menubarplugin
    URI "menubar"
    VERSION 1.0
    QML_FILES
        Main.qml
        BasicMenuBarCard.qml
        ContextMenuCard.qml
        CheckableMenuCard.qml
        InteractiveMenuCard.qml
)
