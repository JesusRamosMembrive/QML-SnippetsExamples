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
#   - icons/    → PNGs de 25x26px en color teal (#00D1A9), uno por pagina
#                 de ejemplo. Se usan en el menu lateral y se tiñen de blanco
#                 con ColorOverlay cuando estan seleccionados.
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
