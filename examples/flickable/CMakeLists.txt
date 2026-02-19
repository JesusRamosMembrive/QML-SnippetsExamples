qt_add_library(flickableplugin STATIC)
qt_add_qml_module(flickableplugin
    URI "flickable"
    VERSION 1.0
    QML_FILES
        Main.qml
        BasicFlickableCard.qml
        PinchZoomCard.qml
        SnapFlickableCard.qml
        InteractiveFlickableCard.qml
)
