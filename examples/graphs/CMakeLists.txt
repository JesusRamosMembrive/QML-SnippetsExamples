qt_add_library(graphsplugin STATIC)
qt_add_qml_module(graphsplugin
    URI "graphs"
    VERSION 1.0
    QML_FILES
        Main.qml
)
target_link_libraries(graphsplugin PRIVATE Qt6::Graphs)
