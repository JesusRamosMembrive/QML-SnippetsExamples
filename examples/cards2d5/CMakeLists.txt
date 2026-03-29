qt_add_library(cards2d5plugin STATIC)
qt_add_qml_module(cards2d5plugin
    URI "cards2d5"
    VERSION 1.0
    QML_FILES
        Main.qml
        DepthCard.qml
)
