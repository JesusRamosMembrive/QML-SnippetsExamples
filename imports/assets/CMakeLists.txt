# =============================================================================
# imports/assets/CMakeLists.txt — Recursos binarios embebidos en el ejecutable
# =============================================================================
#
# Este archivo NO crea un modulo QML. En su lugar, usa qt_add_resources para
# embeber recursos binarios (iconos, imagenes, fuentes, meshes 3D) directamente
# dentro del ejecutable.
#
# ─── Funcionamiento del sistema de recursos Qt ───
# PREFIX "/assets" significa que todos los archivos son accesibles bajo la
# ruta "qrc:/assets/" en QML. Por ejemplo:
#   icons/buttons.png → "qrc:/assets/icons/buttons.png"
#   fonts/Quicksand_Bold.otf → "qrc:/assets/fonts/Quicksand_Bold.otf"
#
# ─── Tipos de recursos incluidos ───
#   - icons/    → PNGs legados + SVGs de reemplazo. Style.icon() usa .svg.
#                 Los iconos se tiñen de blanco con ColorOverlay cuando estan seleccionados.
#   - images/   → Graficos de UI (fondo de tarjeta, dropdown, textura de
#                 particulas, logos, blueprint del avion, etc.)
#   - fonts/    → Quicksand Book y Bold, cargadas por el singleton Style
#   - mesh/     → Archivos de objetos 3D (.obj, .mesh) para Qt Quick 3D
#
# ─── Diferencia con modulos QML ───
# A diferencia de los modulos QML, los recursos no necesitan qmldir — se
# acceden por ruta (qrc:/assets/...), no por nombre de tipo.
#
# ─── Target ───
# qt_add_resources agrega los recursos al target EXISTENTE
# "QMLSnippetsExamples" (el ejecutable), no crea una biblioteca separada.
# =============================================================================

file(GLOB ASSET_SVG_ICONS RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "icons/*.svg")

qt_add_resources(QMLSnippetsExamples "assets"
    PREFIX "/assets"
    FILES
        icons/left.png
        icons/right.png
        icons/close.png
        icons/onoff.png
        icons/settings.png
        icons/expand.png
        icons/reply.png
        icons/calendar.png
        icons/dashboard.png
        icons/latest\ news.png
        icons/web\ radio.png
        icons/courses.png
        icons/inbox.png
        icons/location.png
        icons/status.png
        icons/username.png
        icons/music_note_green.png
        icons/next.png
        icons/play.png
        icons/speaker.png
        icons/music_note_orange.png
        icons/pause.png
        icons/previous.png
        icons/stop.png
        icons/buttons.png
        icons/sliders.png
        icons/rangesliders.png
        icons/combobox.png
        icons/tabbar.png
        icons/lenstabs.png
        icons/swipeview.png
        icons/splitview.png
        icons/toolbar.png
        icons/scrollview.png
        icons/menubar.png
        icons/switches.png
        icons/textinputs.png
        icons/indicators.png
        icons/animations.png
        icons/popups.png
        icons/lists.png
        icons/canvas.png
        icons/layouts.png
        icons/transforms.png
        icons/particles.png
        icons/graphs.png
        icons/pfd.png
        icons/hud.png
        icons/websocket.png
        icons/ecam.png
        icons/navdisplay.png
        icons/teoria.png
        icons/date.png
        icons/aircraftmap.png
        images/planeBluePrint.png
        icons/shapes.png
        icons/maps.png
        icons/pdfreader.png
        icons/threads.png
        icons/tableview.png
        icons/treeview.png
        icons/database.png
        icons/pathview.png
        icons/gridview.png
        icons/flickable.png
        icons/shaders.png
        icons/loader.png
        icons/images.png
        icons/states.png
        icons/filedialogs.png
        icons/network.png
        icons/chatui.png
        icons/multimedia.png
        icons/customitem.png
        icons/qmlcppbridge.png
        icons/asynccpp.png
        icons/ethernet.png
        icons/multiplane.png
        icons/cards2d5.png
        icons/lensphoto.png
        icons/frostglass.png
        icons/spritestack.png
        icons/diorama.png
        ${ASSET_SVG_ICONS}
        images/piedad.jpg
        images/particle.png
        images/Qt_logo_2016.svg
        images/ninepatch.png
        images/card.png
        images/dark-texture-background.png
        images/dropdown.png
        images/graph.png
        images/outercircle.png
        images/user.png
        images/radio_stations/station_logo.png
        images/radio_stations/BBC\ Radio\ 1.png
        images/radio_stations/BBC\ Radio\ 2.png
        images/radio_stations/Capital\ FM.png
        images/radio_stations/KISS.png
        images/radio_stations/Heart\ Radio\ UK.png
        images/radio_stations/Magic\ 105.4.png
        images/radio_stations/BBC\ Radio\ 3.png
        images/radio_stations/Classic\ FM.png
        images/radio_stations/Smooth.png
        images/radio_stations/Kerrang.png
        images/radio_stations/BBCUK\ Radio\ 5\ live.png
        images/radio_stations/KCRW.png
        images/radio_stations/Brooklyn\ Radio.png
        images/radio_stations/KEXP.png
        mesh/note.obj
        mesh/note_mesh.mesh
        fonts/Quicksand_Bold.otf
        fonts/Quicksand_Book.otf
)

# =============================================================================
# Iconos SVG del menú lateral
# =============================================================================
# Style.icon(name) devuelve "qrc:/assets/icons/<name>.svg"
# Para añadir un icono nuevo: ver docs/ICONOS_SVG.md
#
# INSTRUCCIONES:
# 1. Cuando tengas el primer SVG, descomenta el bloque qt_add_resources de abajo.
# 2. Descomenta solo las líneas de los iconos que ya hayas añadido a icons/.
# =============================================================================

# qt_add_resources(QMLSnippetsExamples "icons_svg"
#     PREFIX "/assets"
#     FILES
#         # --- Controles Qt ---
#         # icons/buttons.svg
#         # icons/sliders.svg
#         # icons/rangesliders.svg
#         # icons/combobox.svg
#         # icons/tabbar.svg
#         # icons/lenstabs.svg
#         # icons/swipeview.svg
#         # icons/splitview.svg
#         # icons/toolbar.svg
#         # icons/scrollview.svg
#         # icons/menubar.svg
#         # icons/switches.svg
#         # icons/textinputs.svg
#         # icons/indicators.svg
#         # icons/pathview.svg
#         # icons/gridview.svg
#         # icons/flickable.svg
#         # icons/loader.svg
#         # icons/states.svg
#         # icons/filedialogs.svg
#         # icons/tableview.svg
#         # icons/treeview.svg
#
#         # --- Vistas y Layout ---
#         # icons/animations.svg
#         # icons/popups.svg
#         # icons/lists.svg
#         # icons/canvas.svg
#         # icons/layouts.svg
#         # icons/transforms.svg
#         # icons/particles.svg
#         # icons/shapes.svg
#
#         # --- Gráficos y Efectos ---
#         # icons/shaders.svg
#         # icons/images.svg
#         # icons/graphs.svg
#
#         # --- Aviónica / Proyectos propios ---
#         # icons/pfd.svg
#         # icons/hud.svg
#         # icons/ecam.svg
#         # icons/navdisplay.svg
#         # icons/aircraftmap.svg
#         # icons/multiplane.svg
#         # icons/cards2d5.svg
#         # icons/lensphoto.svg
#         # icons/frostglass.svg
#         # icons/spritestack.svg
#         # icons/diorama.svg
#
#         # --- Red y Sistema ---
#         # icons/websocket.svg
#         # icons/network.svg
#         # icons/ethernet.svg
#         # icons/database.svg
#         # icons/threads.svg
#         # icons/multimedia.svg
#
#         # --- C++ / Integración ---
#         # icons/qmlcppbridge.svg
#         # icons/asynccpp.svg
#         # icons/customitem.svg
#
#         # --- Otros ---
#         # icons/chatui.svg
#         # icons/maps.svg
#         # icons/pdfreader.svg
#         # icons/teoria.svg
#         # icons/date.svg
#         # icons/dashboard.svg
#         # icons/settings.svg
# )
