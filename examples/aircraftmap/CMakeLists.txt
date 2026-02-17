qt_add_library(aircraftmapplugin STATIC)
qt_add_qml_module(aircraftmapplugin
    URI "aircraftmap"
    VERSION 1.0
    QML_FILES
        Main.qml
)
