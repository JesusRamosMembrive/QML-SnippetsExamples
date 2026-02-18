qt_add_library(tableviewplugin STATIC)
qt_add_qml_module(tableviewplugin
    URI "tableview"
    VERSION 1.0
    QML_FILES
        Main.qml
        BasicTableCard.qml
        SortFilterTableCard.qml
        EditableTableCard.qml
)
