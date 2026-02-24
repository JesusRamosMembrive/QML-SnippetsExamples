# =============================================================================
# imports/CMakeLists.txt — Punto de entrada para todos los modulos compartidos
# =============================================================================
#
# Este directorio es la puerta de entrada de toda la infraestructura compartida
# del proyecto: utilidades de UI y backends C++. Se organiza en dos grupos:
#
# ─── GRUPO 1: Modulos solo-QML (utilidades compartidas de UI) ───
#   - utils     → Singleton Style (tema global) y herramienta Tracer
#   - controls  → Controles reutilizables (BaseCard, Separator)
#   - assets    → Recursos binarios embebidos (iconos, imagenes, fuentes, meshes)
#
# ─── GRUPO 2: Modulos con backend C++ ───
#   - websocket       → Cliente WebSocket (QWebSocket registrado como tipo QML)
#   - theoryparser    → Parser de contenido teorico
#   - theroryCPlusPlus→ Conceptos de C++ expuestos a QML
#   - threads         → Ejemplo de hilos con QThread
#   - tablemodel      → Modelo C++ para TableView (QAbstractTableModel)
#   - treemodel       → Modelo C++ para TreeView (QAbstractItemModel)
#   - database        → Acceso a SQLite via C++ (QSqlDatabase)
#   - customitem      → Item personalizado pintado con QQuickPaintedItem
#   - qmlcppbridge    → Puente bidireccional QML ↔ C++ (senales/propiedades)
#   - asynccpp        → Operaciones asincronas con QFuture/QtConcurrent
#   - settingsmgr     → Gestor de configuracion persistente (QSettings)
#
# Los backends C++ viven aqui (y no en examples/) porque son infraestructura
# reutilizable. Las paginas de ejemplo en examples/ solo contienen codigo QML
# de UI que consume estos backends.
#
# Cada subdirectorio tiene su propio CMakeLists.txt que crea una biblioteca
# estatica + modulo QML (qt_add_library + qt_add_qml_module).
# =============================================================================

add_subdirectory(utils)
add_subdirectory(controls)
add_subdirectory(assets)
add_subdirectory(websocket)
add_subdirectory(theoryparser)
add_subdirectory(theroryCPlusPlus)
add_subdirectory(threads)
add_subdirectory(tablemodel)
add_subdirectory(treemodel)
add_subdirectory(database)
add_subdirectory(customitem)
add_subdirectory(qmlcppbridge)
add_subdirectory(asynccpp)
add_subdirectory(settingsmgr)
add_subdirectory(ethernet)
