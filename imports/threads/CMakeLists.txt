qt_add_library(threadsplugin STATIC)
qt_add_qml_module(threadsplugin
    URI "threads"
    VERSION 1.0
    SOURCES
        threadpipeline.h
        threadpipeline.cpp
        pipelineworkers.h
        pipelineworkers.cpp
)
