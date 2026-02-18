qt_add_library(treeviewplugin STATIC)
qt_add_qml_module(treeviewplugin
    URI "treeview"
    VERSION 1.0
    QML_FILES
        Main.qml
        FileSystemTreeCard.qml
        OrganizationTreeCard.qml
        InteractiveTreeCard.qml
)
