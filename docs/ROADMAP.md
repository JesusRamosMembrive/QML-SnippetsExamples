# Roadmap — QML Snippets & Examples

Documento de seguimiento: paginas completadas y pendientes.

---

## Paginas completadas (28)

### Controles basicos
- [x] **Buttons** — Standard, icon, toggle, styled buttons
- [x] **Sliders** — Sliders con styled tracks y custom handles
- [x] **Switches** — Toggle switches y check controls
- [x] **TextInputs** — Text fields, validacion, styled inputs
- [x] **Indicators** — Progress bars, busy indicators, gauges

### Contenedores y layout
- [x] **Layouts** — Row, Column, Grid, Flow layouts
- [x] **Lists** — ListView, delegates, sections, Kanban drag & drop
- [x] **Popups** — Dialogs, drawers, tooltips, menus
- [x] **TableView** — C++ QAbstractTableModel, sort/filter proxy, editable cells
- [x] **TreeView** — C++ QAbstractItemModel, jerarquia, expand/collapse, add/remove

### Visual y grafico
- [x] **Canvas** — 2D drawing, shapes, paths, pie charts
- [x] **Shapes** — Bezier curves, arcs, SVG paths, gradients, morphing
- [x] **Transforms** — Rotation, scale, translate, 3D effects
- [x] **Particles** — Emitters, affectors, trails, interactive
- [x] **Graphs** — Line series, bar charts, real-time plots, heatmap
- [x] **Animations** — Transitions, behaviors, state animations

### Aviacion
- [x] **PFD** — Artificial horizon, speed/altitude tapes, heading
- [x] **ECAM** — Engine gauges, warnings, fuel synoptic
- [x] **HUD** — Head-up display, pitch ladder, flight path vector
- [x] **NavDisplay** — Moving map, compass rose, flight plan
- [x] **AircraftMap** — Interactive blueprint con zoomable markers

### C++ y backend
- [x] **Threads** — QThread pipeline, moveToThread, cross-thread signals
- [x] **Database** — SQLite CRUD con QSqlTableModel, query explorer
- [x] **WebSocket** — C++ class expuesta a QML, live echo server
- [x] **Teoria** — C++ theory: fundamentals through advanced topics

### Utilidades
- [x] **Date** — Tumbler date picker, MonthGrid calendar
- [x] **Maps** — OSM map, compass overlay, animated GPS route
- [x] **PdfReader** — Drag & drop PDF viewer con zoom y navegacion

---

## Pendientes

### Controles basicos que faltan
- [x] **RangeSliders** — RangeSlider con estilos, labels, rangos minimo/maximo, vertical
- [x] **ComboBox** — ComboBox editable, con modelos, searchable, dropdown estilizado
- ~~**SpinBox**~~ — Ya cubierto en TextInputs (ComboSpinCard + FormBuilderCard)
- [x] **TabBar** — TabBar + StackLayout, tabs dinamicas, con iconos, closable tabs
- [x] **SwipeView** — SwipeView paginado, PageIndicator, carrusel de imagenes

### Controles avanzados
- [x] **SplitView** — SplitView horizontal/vertical, paneles redimensionables
- [x] **ToolBar** — ToolBar con acciones, toolbar flotante, toolbar contextual
- [x] **ScrollView** — ScrollBar custom, pull-to-refresh, infinite scroll
- [x] **MenuBar** — Menu de aplicacion, context menus avanzados, keyboard shortcuts

### Patrones QML
- [x] **PathView** — Vista circular/path, coverflow, selector carrusel 3D
- [x] **GridView** — GridView con delegates, photo gallery, masonry layout
- [x] **Flickable** — Flickable custom, pinch-to-zoom, zoom de imagen, snap
- [x] **Shaders** — ShaderEffect, fragmento GLSL, transiciones custom, filtros
- [x] **Loader** — Component/Loader, creacion dinamica, lazy loading, Instantiator
- [x] **Images** — Image, AnimatedImage, BorderImage, image providers
- [x] **States** — States avanzados, transiciones complejas, state machines

### Multimedia y red
- [x] **Multimedia** — Video player, audio waveform, camara (Qt Multimedia)
- [x] **Network** — XMLHttpRequest, REST API, JSON parsing, descarga con progreso
- [x] **FileDialogs** — FileDialog, FolderDialog, guardar/abrir, filtros

### Integracion C++ avanzada
- [x] **CustomItem** — QQuickPaintedItem, rendering custom desde C++
- [ ] **QMLCppBridge** — Q_PROPERTY, Q_INVOKABLE, senales C++ a QML
- [ ] **AsyncCpp** — QFuture, QtConcurrent, async C++ con UI
- [ ] **Settings** — QSettings, preferencias persistentes, tema claro/oscuro

### Showcases (aplicaciones practicas)
- [x] **ChatUI** — Interfaz de chat, burbujas, input, scroll invertido
- [ ] **Dashboard** — Dashboard KPI con cards, sparklines, estadisticas real-time
- [ ] **LoginForm** — Formularios login/registro, validacion, transiciones
- [ ] **MusicPlayer** — Reproductor con controles, barra de progreso, playlist
- [ ] **PhotoGallery** — Galeria con GridView, lightbox, transiciones

---

## Notas

- **Drag & Drop** ya esta cubierto en la pagina PdfReader (drag & drop de archivos) y Lists (Kanban board).
- El orden de implementacion prioriza primero los **controles basicos que faltan**, luego patrones QML, y finalmente showcases.
- Cada pagina nueva sigue el patron documentado en `docs/CREAR_NUEVA_PAGINA.md`.
