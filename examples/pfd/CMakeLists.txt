qt_add_library(pfdplugin STATIC)
qt_add_qml_module(pfdplugin
    URI "pfd"
    VERSION 1.0
    QML_FILES
        Main.qml
        ArtificialHorizonCard.qml
        SpeedAltTapesCard.qml
        HeadingIndicatorCard.qml
        VsiTurnCard.qml
)
