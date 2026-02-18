qt_add_library(navdisplayplugin STATIC)
qt_add_qml_module(navdisplayplugin
    URI "navdisplay"
    VERSION 1.0
    QML_FILES
        Main.qml
        MovingMapCard.qml
        FlightPlanCard.qml
        CompassRoseCard.qml
        ModeRangeCard.qml
)
