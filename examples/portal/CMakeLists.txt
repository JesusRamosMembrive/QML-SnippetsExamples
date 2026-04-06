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
