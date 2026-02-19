qt_add_library(asynccppplugin STATIC)
qt_add_qml_module(asynccppplugin
    URI "asynccpp"
    VERSION 1.0
    SOURCES
        asynccomputer.h asynccomputer.cpp
        asynctask.h asynctask.cpp
)
target_link_libraries(asynccppplugin PRIVATE Qt6::Concurrent)
