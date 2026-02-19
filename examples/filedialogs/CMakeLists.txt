qt_add_library(filedialogsplugin STATIC)
qt_add_qml_module(filedialogsplugin
    URI "filedialogs"
    VERSION 1.0
    QML_FILES
        Main.qml
        FileDialogCard.qml
        FolderDialogCard.qml
        SaveDialogCard.qml
        InteractiveDialogCard.qml
)
