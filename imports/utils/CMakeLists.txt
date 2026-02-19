# =============================================================================
# imports/utils/CMakeLists.txt — Modulo de utilidades globales
# =============================================================================
#
# Este modulo proporciona el singleton Style (tema global de la app) y la
# herramienta de depuracion Tracer.
#
# ─── SINGLETON EN QML: Las 3 piezas obligatorias ───
# Para que un singleton QML funcione correctamente se necesitan TRES
# declaraciones en tres archivos distintos. Si falta cualquiera, hay errores:
#
#   1. CMakeLists.txt → QT_QML_SINGLETON_TYPE true  (aqui abajo)
#   2. qmldir         → "singleton Style 1.0 Style.qml"
#   3. Style.qml      → "pragma Singleton" en la primera linea
#
# Sin la propiedad QT_QML_SINGLETON_TYPE, CMake no genera el codigo de
# registro correcto y el motor QML crea multiples instancias en vez de una.
#
# ─── Nombre de biblioteca y target de enlace ───
# Biblioteca: "utils" (STATIC) → qt_add_qml_module genera automaticamente
# el target de enlace "utilsplugin" (nombre + "plugin").
# En el CMakeLists.txt raiz se enlaza con: target_link_libraries(... utilsplugin)
# =============================================================================

set_source_files_properties(Style.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE true
)

qt_add_library(utils STATIC)
qt_add_qml_module(utils
    URI "utils"
    VERSION 1.0
    QML_FILES
        Style.qml
        Tracer.qml
)
