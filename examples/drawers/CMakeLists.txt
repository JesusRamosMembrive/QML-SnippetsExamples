qt_add_library(drawersplugin STATIC)
qt_add_qml_module(drawersplugin
    URI "drawers"
    VERSION 1.0
    QML_FILES
        Main.qml
        ContainedDrawer.qml
        LeftDrawerCard.qml
        RightDrawerCard.qml
        TopDrawerCard.qml
        BottomDrawerCard.qml
)
