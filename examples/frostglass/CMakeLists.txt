qt_add_library(frostglassplugin STATIC)

qt_add_qml_module(frostglassplugin
    URI "frostglass"
    VERSION 1.0
    QML_FILES
        Main.qml
        GlassCard.qml
)
