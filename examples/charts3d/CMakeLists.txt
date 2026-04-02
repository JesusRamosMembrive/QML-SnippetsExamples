qt_add_library(charts3dplugin STATIC)
qt_add_qml_module(charts3dplugin
    URI "charts3d"
    VERSION 1.0
    QML_FILES
        Main.qml
        Bars3DCard.qml
        Scatter3DCard.qml
        Surface3DCard.qml
)
target_link_libraries(charts3dplugin PRIVATE Qt6::Graphs)
