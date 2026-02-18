qt_add_library(transformsplugin STATIC)
qt_add_qml_module(transformsplugin
    URI "transforms"
    VERSION 1.0
    QML_FILES
        Main.qml
        Transforms2DCard.qml
        Rotation3DCard.qml
        GraphicalEffectsCard.qml
        CardFlipCard.qml
        Carousel3D.qml
        ParallaxDepth.qml
        ElasticSpring.qml
        NeonGlow.qml
        MatrixShear.qml
        WaveGrid.qml
)
