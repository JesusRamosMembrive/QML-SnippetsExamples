qt_add_library(qmlcppbridgeplugin STATIC)
qt_add_qml_module(qmlcppbridgeplugin
    URI "qmlcppbridge"
    VERSION 1.0
    SOURCES
        propertybridge.h propertybridge.cpp
        methodbridge.h methodbridge.cpp
        signalbridge.h signalbridge.cpp
)
target_link_libraries(qmlcppbridgeplugin PRIVATE Qt6::Qml Qt6::Gui)
