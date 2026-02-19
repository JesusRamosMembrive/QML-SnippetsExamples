qt_add_library(multimediaplugin STATIC)
qt_add_qml_module(multimediaplugin
    URI "multimedia"
    VERSION 1.0
    QML_FILES
        Main.qml
        VideoPlayerCard.qml
        AudioPlayerCard.qml
        CameraCard.qml
        InteractiveMediaCard.qml
)
