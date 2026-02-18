qt_add_library(threadsexplugin STATIC)
qt_add_qml_module(threadsexplugin
    URI "threadsex"
    VERSION 1.0
    QML_FILES
        Main.qml
        PipelineControlCard.qml
        PipelineFlowCard.qml
        RecordsCard.qml
        ThreadInfoCard.qml
)
