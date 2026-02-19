qt_add_library(qmlcppbridgeexplugin STATIC)
qt_add_qml_module(qmlcppbridgeexplugin
    URI "qmlcppbridgeex"
    VERSION 1.0
    QML_FILES
        Main.qml
        PropertyBindCard.qml
        MethodCard.qml
        SignalCard.qml
        InteractiveBridgeCard.qml
    DEPENDENCIES
        qmlcppbridge
)
target_link_libraries(qmlcppbridgeexplugin PRIVATE qmlcppbridgeplugin)
