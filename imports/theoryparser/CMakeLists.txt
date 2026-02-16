qt_add_library(theoryparserplugin STATIC)
qt_add_qml_module(theoryparserplugin
    URI "theoryparser"
    VERSION 1.0
    SOURCES
        theoryparser.h
        theoryparser.cpp
)
