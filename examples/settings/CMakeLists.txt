qt_add_library(settingsexplugin STATIC)
qt_add_qml_module(settingsexplugin
    URI "settingsex"
    VERSION 1.0
    QML_FILES
        Main.qml
        KeyValueCard.qml
        PreferencesCard.qml
        RecentFilesCard.qml
        SettingsInfoCard.qml
    DEPENDENCIES
        settingsmgr
)
target_link_libraries(settingsexplugin PRIVATE settingsmgrplugin)
