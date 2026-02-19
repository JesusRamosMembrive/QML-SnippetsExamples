qt_add_library(networkplugin STATIC)
qt_add_qml_module(networkplugin
    URI "network"
    VERSION 1.0
    QML_FILES
        Main.qml
        XHRCard.qml
        RestApiCard.qml
        JsonParserCard.qml
        InteractiveNetworkCard.qml
)
