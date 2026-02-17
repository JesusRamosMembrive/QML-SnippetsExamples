qt_add_library(indicatorsplugin STATIC)
qt_add_qml_module(indicatorsplugin
    URI "indicators"
    VERSION 1.0
    QML_FILES
        Main.qml
        DialCard.qml
        ProgressBarCard.qml
        BusyIndicatorCard.qml
        SystemMonitorCard.qml
        SpeedometerGauge.qml
        CircularProgressRings.qml
        BatteryIndicator.qml
        SignalStrength.qml
        Thermometer.qml
        VuLevelMeter.qml
        RpmTachometer.qml
        StepProgress.qml
)
