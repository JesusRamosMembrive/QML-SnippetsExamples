qt_add_library(shadersplugin STATIC)
qt_add_qml_module(shadersplugin
    URI "shaders"
    VERSION 1.0
    QML_FILES
        Main.qml
        BlurEffectCard.qml
        GlowShadowCard.qml
        ColorEffectCard.qml
        InteractiveEffectsCard.qml
)
