qt_add_library(canvasplugin STATIC)
qt_add_qml_module(canvasplugin
    URI "canvas"
    VERSION 1.0
    QML_FILES
        Main.qml
        Canvas2DCard.qml
        ShapePathsCard.qml
        GradientsPieCard.qml
        DrawingPadCard.qml
        AnalogClock.qml
        SpirographGenerator.qml
        AudioVisualizer.qml
        RadarSweep.qml
        FractalTree.qml
        Kaleidoscope.qml
)
