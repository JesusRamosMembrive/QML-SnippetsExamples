qt_add_library(toolbarplugin STATIC)
qt_add_qml_module(toolbarplugin
    URI "toolbar"
    VERSION 1.0
    QML_FILES
        Main.qml
        BasicToolBarCard.qml
        ActionToolBarCard.qml
        ContextToolBarCard.qml
        InteractiveToolBarCard.qml
)
