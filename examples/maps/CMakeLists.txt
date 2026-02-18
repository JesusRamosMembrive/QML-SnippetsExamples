qt_add_library(mapsplugin STATIC)
qt_add_qml_module(mapsplugin
    URI "maps"
    VERSION 1.0
    QML_FILES
        Main.qml
        MapCompassOverlay.qml
        MapInfoPanel.qml
        MapControlsBar.qml
)
target_link_libraries(mapsplugin PRIVATE Qt6::Location Qt6::Positioning)
