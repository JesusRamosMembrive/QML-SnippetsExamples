qt_add_library(tablemodelplugin STATIC)
qt_add_qml_module(tablemodelplugin
    URI "tablemodel"
    VERSION 1.0
    SOURCES
        employeemodel.h
        employeemodel.cpp
        employeeproxymodel.h
        employeeproxymodel.cpp
)
