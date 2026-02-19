qt_add_library(customitemplugin STATIC)
qt_add_qml_module(customitemplugin
    URI "customitem"
    VERSION 1.0
    SOURCES
        analogclock.h analogclock.cpp
        waveformitem.h waveformitem.cpp
        gaugeitem.h gaugeitem.cpp
        drawcanvas.h drawcanvas.cpp
)
target_link_libraries(customitemplugin PRIVATE Qt6::Quick)
