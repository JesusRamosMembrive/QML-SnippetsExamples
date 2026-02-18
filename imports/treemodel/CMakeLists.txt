qt_add_library(treemodelplugin STATIC)
qt_add_qml_module(treemodelplugin
    URI "treemodel"
    VERSION 1.0
    SOURCES
        treeitem.h
        treeitem.cpp
        filesystemtreemodel.h
        filesystemtreemodel.cpp
        organizationtreemodel.h
        organizationtreemodel.cpp
)
