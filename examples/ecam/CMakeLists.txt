qt_add_library(ecamplugin STATIC)
qt_add_qml_module(ecamplugin
    URI "ecam"
    VERSION 1.0
    QML_FILES
        Main.qml
        EngineGaugesCard.qml
        WarningPanelCard.qml
        FuelSynopticCard.qml
        SystemStatusCard.qml
)
