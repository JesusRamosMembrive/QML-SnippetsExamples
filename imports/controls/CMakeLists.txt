# =============================================================================
# imports/controls/CMakeLists.txt — Modulo de controles reutilizables
# =============================================================================
#
# Controles personalizados que se usan en toda la aplicacion:
#   - BaseCard   → Tarjeta base con fondo, sombra y bordes redondeados.
#                  Utilizada en las sobrecargas de estilo (style overrides)
#                  y como contenedor visual en las paginas de ejemplo.
#   - Separator  → Linea divisoria horizontal usada en las paginas de ejemplo
#                  para separar secciones visualmente.
#
# Biblioteca: "controls" (STATIC) → target de enlace: "controlsplugin"
# =============================================================================

qt_add_library(controls STATIC)
qt_add_qml_module(controls
    URI "controls"
    VERSION 1.0
    QML_FILES
        BaseCard.qml
        Separator.qml
)
