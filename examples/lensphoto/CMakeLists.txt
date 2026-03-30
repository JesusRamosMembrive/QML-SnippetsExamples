qt_add_library(lensphotoplugin STATIC)

qt_add_qml_module(lensphotoplugin
    URI "lensphoto"
    VERSION 1.0
    QML_FILES
        Main.qml
        LensEffect.qml
)

qt6_add_shaders(lensphotoplugin "lensphoto_shaders"
    GLSL "440"
    PREFIX "/qt/qml/lensphoto"
    FILES
        shaders/lens.vert
        shaders/lens.frag
)
