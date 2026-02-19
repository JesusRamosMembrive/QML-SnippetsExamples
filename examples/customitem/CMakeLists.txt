qt_add_library(customitemexplugin STATIC)
qt_add_qml_module(customitemexplugin
    URI "customitemex"
    VERSION 1.0
    QML_FILES
        Main.qml
        PaintedClockCard.qml
        WaveformCard.qml
        GaugeCard.qml
        InteractiveDrawCard.qml
    DEPENDENCIES
        customitem
)
target_link_libraries(customitemexplugin PRIVATE customitemplugin)
