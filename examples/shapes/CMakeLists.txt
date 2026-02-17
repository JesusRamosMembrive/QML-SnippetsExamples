qt_add_library(shapesplugin STATIC)
qt_add_qml_module(shapesplugin
    URI "shapes"
    VERSION 1.0
    QML_FILES
        Main.qml
        BezierCurvesCard.qml
        ArcsAnglesCard.qml
        SvgPathsCard.qml
        FillRulesCard.qml
        GradientTypesCard.qml
        AnimatedShapesCard.qml
        GearTrain.qml
        RoseCurve.qml
        DnaDoubleHelix.qml
        Oscilloscope.qml
        GeometricMandala.qml
        LiquidBlob.qml
)
