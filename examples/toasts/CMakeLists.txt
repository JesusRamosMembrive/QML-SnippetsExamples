qt_add_library(toastsplugin STATIC)
qt_add_qml_module(toastsplugin
    URI "toasts"
    VERSION 1.0
    QML_FILES
        Main.qml
        ToastHost.qml
        ToastPlaygroundCard.qml
        ToastQueueCard.qml
        ToastApiCard.qml
)
