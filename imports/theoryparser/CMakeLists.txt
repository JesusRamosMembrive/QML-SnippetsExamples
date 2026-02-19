# ==============================================================================
# theoryparser - Modulo QML para parsear contenido teorico desde recursos Qt
# ==============================================================================
#
# Este modulo proporciona una clase C++ que lee y parsea archivos de teoria
# almacenados en el sistema de recursos de Qt (:/theory/...).
#
# Proposito:
#   La aplicacion incluye una seccion de "teoria" con capitulos y temas.
#   Cada tema es un archivo .txt o .cpp con un formato de marcadores propio
#   (<---EXPLANATION--->, <---FILES--->, etc.). TheoryParser lee estos archivos,
#   extrae las secciones, y las expone a QML de forma estructurada.
#
# Sistema de recursos Qt (qrc):
#   Los archivos embebidos en el binario se acceden con el prefijo ":/".
#   Ventaja: no dependen del sistema de archivos del usuario, siempre estan
#   disponibles y no se pueden perder.
#
# No necesita linkear librerias adicionales ya que solo usa Qt6::Core y Qt6::Qml
# (que vienen del target padre via dependencias transitivas).
# ==============================================================================

qt_add_library(theoryparserplugin STATIC)
qt_add_qml_module(theoryparserplugin
    URI "theoryparser"
    VERSION 1.0
    SOURCES
        theoryparser.h
        theoryparser.cpp
)
