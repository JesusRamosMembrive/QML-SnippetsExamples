# ============================================================================
# Modulo QML con backend C++ puro (sin archivos QML)
# ============================================================================
#
# Este CMakeLists.txt muestra el patron para modulos que SOLO contienen
# logica C++ expuesta a QML. A diferencia de los modulos de componentes
# visuales (que usan QML_FILES), aqui usamos SOURCES para registrar
# archivos .h y .cpp.
#
# Diferencia clave:
#   - QML_FILES: registra archivos .qml como componentes del modulo
#   - SOURCES:   compila clases C++ y las hace disponibles en QML
#                via QML_ELEMENT / QML_NAMED_ELEMENT
#
# Las clases C++ con Q_OBJECT + QML_ELEMENT se registran automaticamente
# en el modulo gracias a qt_add_qml_module(). QML puede luego hacer:
#
#   import threads
#   ThreadPipeline { id: pipeline }
#
# Sin necesidad de qmlRegisterType() manual (eso era Qt 5).
# ============================================================================

qt_add_library(threadsplugin STATIC)
qt_add_qml_module(threadsplugin
    URI "threads"
    VERSION 1.0
    SOURCES
        threadpipeline.h
        threadpipeline.cpp
        pipelineworkers.h
        pipelineworkers.cpp
)
