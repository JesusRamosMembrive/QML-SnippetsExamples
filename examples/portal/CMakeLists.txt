qt_add_library(portalplugin STATIC)
qt_add_qml_module(portalplugin
    URI "portal"
    VERSION 1.0
    QML_FILES
        Main.qml
        PortalCanvas.qml
        ReflectionCanvas.qml
        PortalControls.qml
    RESOURCES
        portal_draw.js
)

# Compila los shaders GLSL 440 a formato QSB (Qt Shader Bytecode).
# Requiere Qt6::ShaderTools (ya incluido en el find_package raíz).
qt6_add_shaders(portalplugin "portal_shaders"
    GLSL "440"
    PREFIX "/qt/qml/portal"
    FILES
        shaders/portal.vert
        shaders/portal.frag
)
