qt_add_library(spritestackplugin STATIC)
qt_add_qml_module(spritestackplugin
    URI "spritestack"
    VERSION 1.0
    QML_FILES
        Main.qml
        SpriteStack.qml
)
