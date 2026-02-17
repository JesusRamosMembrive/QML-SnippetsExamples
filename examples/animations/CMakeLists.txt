qt_add_library(animationsplugin STATIC)
qt_add_qml_module(animationsplugin
    URI "animations"
    VERSION 1.0
    QML_FILES
        Main.qml
        EasingCurvesCard.qml
        SequentialParallelCard.qml
        BehaviorSpringCard.qml
        StatesTransitionsCard.qml
        ParticleFountain.qml
        OrbitalSystem.qml
        SineWaveBars.qml
        LissajousCurve.qml
        NewtonsCradle.qml
        FlipCards3D.qml
        StaggeredList.qml
        BreathingCircles.qml
        MatrixRain.qml
)
