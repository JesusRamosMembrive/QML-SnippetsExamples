qt_add_library(lenstabsplugin STATIC)

qt_add_qml_module(lenstabsplugin
    URI "lenstabs"
    VERSION 1.0
    QML_FILES
        Main.qml
        LensTabStrip.qml
        LensEffectRect.qml
        LensCircleEffect.qml
)

# Compila los shaders GLSL 440 a formato QSB (Qt Shader Bytecode).
# Requiere Qt6::ShaderTools (añadido al find_package raíz).
qt6_add_shaders(lenstabsplugin "lenstabs_shaders"
    GLSL "440"
    PREFIX "/qt/qml/lenstabs"
    FILES
        shaders/lens_rect.vert
        shaders/lens_rect.frag
        shaders/lens_circle.vert
        shaders/lens_circle.frag
)
