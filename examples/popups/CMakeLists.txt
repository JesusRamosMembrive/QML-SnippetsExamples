qt_add_library(popupsplugin STATIC)
qt_add_qml_module(popupsplugin
    URI "popups"
    VERSION 1.0
    QML_FILES
        Main.qml
        DialogCard.qml
        PopupCard.qml
        ToolTipCard.qml
        MenuCard.qml
        ToastNotifications.qml
        AlertCards.qml
        BottomSheet.qml
        Snackbar.qml
        FloatingActionButton.qml
        CommandPalette.qml
)
