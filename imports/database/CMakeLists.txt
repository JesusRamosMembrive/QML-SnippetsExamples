qt_add_library(databaseplugin STATIC)
qt_add_qml_module(databaseplugin
    URI "database"
    VERSION 1.0
    SOURCES
        databasemanager.h databasemanager.cpp
        sqltablemodel.h sqltablemodel.cpp
        sqlquerymodel.h sqlquerymodel.cpp
)
target_link_libraries(databaseplugin PRIVATE Qt6::Sql)
