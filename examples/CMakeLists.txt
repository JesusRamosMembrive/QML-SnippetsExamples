# =============================================================================
# examples/CMakeLists.txt — Registro de todas las páginas de ejemplo
# =============================================================================
# Cada add_subdirectory incluye una página de ejemplo independiente.
# Cada subdirectorio es un módulo QML autónomo con su propio CMakeLists.txt,
# qmldir y Main.qml. Son cargados bajo demanda por el Loader de Dashboard.qml.
#
# Para añadir un nuevo ejemplo:
#   1. Crear el directorio examples/<nombre>/ con CMakeLists.txt, qmldir, Main.qml
#   2. Añadir add_subdirectory(<nombre>) aquí
#   3. Añadir el target de enlace en /qmlmodules
#   4. Registrar en Dashboard.qml (pageMap) y MainMenuList.qml (menuModel)
#   Guía completa: docs/CREAR_NUEVA_PAGINA.md
# =============================================================================
add_subdirectory(buttons)
add_subdirectory(sliders)
add_subdirectory(rangesliders)
add_subdirectory(combobox)
add_subdirectory(tabbar)
add_subdirectory(swipeview)
add_subdirectory(splitview)
add_subdirectory(toolbar)
add_subdirectory(scrollview)
add_subdirectory(menubar)
add_subdirectory(switches)
add_subdirectory(textinputs)
add_subdirectory(indicators)
add_subdirectory(animations)
add_subdirectory(popups)
add_subdirectory(lists)
add_subdirectory(canvas)
add_subdirectory(layouts)
add_subdirectory(transforms)
add_subdirectory(particles)
add_subdirectory(graphs)
add_subdirectory(pfd)
add_subdirectory(hud)
add_subdirectory(websocket)
add_subdirectory(ecam)
add_subdirectory(navdisplay)
add_subdirectory(theorycpp)
add_subdirectory(date)
add_subdirectory(aircraftmap)
add_subdirectory(shapes)
add_subdirectory(maps)
add_subdirectory(pdfreader)
add_subdirectory(threads)
add_subdirectory(tableview)
add_subdirectory(treeview)
add_subdirectory(database)
add_subdirectory(pathview)
add_subdirectory(gridview)
add_subdirectory(flickable)
add_subdirectory(shaders)
add_subdirectory(loaderex)
add_subdirectory(images)
add_subdirectory(states)
add_subdirectory(filedialogs)
add_subdirectory(network)
add_subdirectory(chatui)
add_subdirectory(multimedia)
add_subdirectory(customitem)
add_subdirectory(qmlcppbridge)
add_subdirectory(asynccpp)
add_subdirectory(settings)
