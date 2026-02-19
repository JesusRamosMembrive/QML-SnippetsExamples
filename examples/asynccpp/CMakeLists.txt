qt_add_library(asynccppexplugin STATIC)
qt_add_qml_module(asynccppexplugin
    URI "asynccppex"
    VERSION 1.0
    QML_FILES
        Main.qml
        ConcurrentRunCard.qml
        ProgressTaskCard.qml
        CancelTaskCard.qml
        ParallelMapCard.qml
    DEPENDENCIES
        asynccpp
)
target_link_libraries(asynccppexplugin PRIVATE asynccppplugin)
