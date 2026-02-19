qt_add_library(loaderexplugin STATIC)
qt_add_qml_module(loaderexplugin
    URI "loaderex"
    VERSION 1.0
    QML_FILES
        Main.qml
        BasicLoaderCard.qml
        ComponentLoaderCard.qml
        DynamicCreationCard.qml
        InteractiveLoaderCard.qml
)
