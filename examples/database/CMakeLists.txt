qt_add_library(databaseexplugin STATIC)
qt_add_qml_module(databaseexplugin
    URI "databaseex"
    VERSION 1.0
    QML_FILES
        Main.qml
        CrudTableCard.qml
        QueryExplorerCard.qml
        DataDashboardCard.qml
)
