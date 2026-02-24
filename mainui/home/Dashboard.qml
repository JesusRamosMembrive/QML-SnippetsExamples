// =============================================================================
// Dashboard.qml — Contenedor de páginas con carga dinámica (Lazy Loading)
// =============================================================================
// Este componente gestiona qué página de ejemplo se muestra en el área de
// contenido principal. Tiene dos vistas:
//
//   1. Vista "Dashboard" (home): información del proyecto y lista de ejemplos
//   2. Vista de ejemplo: la página de ejemplo cargada dinámicamente con Loader
//
// Patrón de navegación por estados:
// La propiedad "state" (heredada de Item) actúa como router. Cuando HomePage
// asigna mainContent.state = "Buttons", el Loader busca en pageMap la URI
// correspondiente y carga ese archivo QML.
//
// ¿Por qué Loader con URIs en vez de import + instancia directa?
// Versión anterior: se importaban TODOS los módulos y se instanciaban 50+
// páginas con opacity/visible bindings. Esto consumía mucha memoria ya que
// todas las páginas existían en el árbol de objetos aunque estuvieran ocultas.
//
// Versión actual (Lazy Loading): solo la página activa existe en memoria.
// El Loader crea la página al entrar y la destruye al salir. Las URIs
// "qrc:/qt/qml/<modulo>/Main.qml" apuntan a los recursos compilados de
// cada módulo QML estático.
// =============================================================================

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore

import utils
import qmlsnippetsstyle   // Necesario para que los controles usen nuestro estilo

Item {
    id: root
    state: "Dashboard"          // Estado inicial: la vista home
    objectName: "Dashboard"     // objectName permite encontrar este item desde C++
                                // con findChild<QObject*>("Dashboard") si fuera necesario

    // --- Mapa de navegación: estado → URI del recurso QML ---
    // readonly: no cambia en ejecución. var: tipo genérico (es un objeto JS).
    // La sintaxis ({...}) con paréntesis es necesaria porque sin ellos QML
    // interpreta las llaves como un bloque de código, no como un objeto literal.
    //
    // Las URIs siguen el patrón: qrc:/qt/qml/<uri_del_modulo>/Main.qml
    // donde <uri_del_modulo> es el URI definido en qt_add_qml_module() de cada
    // ejemplo. "qrc:" indica que es un recurso compilado dentro del ejecutable.
    // "/qt/qml/" es el prefijo estándar que Qt usa para módulos QML compilados.
    //
    // IMPORTANTE: Las claves de este mapa deben coincidir EXACTAMENTE con los
    // nombres en el ListModel del MainMenuList. Si no coinciden, el Loader
    // recibirá "" y no cargará nada (sin error visible, solo pantalla vacía).
    readonly property var pageMap: ({
        "Buttons":      "qrc:/qt/qml/buttons/Main.qml",
        "Sliders":      "qrc:/qt/qml/sliders/Main.qml",
        "RangeSliders": "qrc:/qt/qml/rangesliders/Main.qml",
        "ComboBox":     "qrc:/qt/qml/combobox/Main.qml",
        "TabBar":       "qrc:/qt/qml/tabbar/Main.qml",
        "SwipeView":    "qrc:/qt/qml/swipeview/Main.qml",
        "SplitView":    "qrc:/qt/qml/splitview/Main.qml",
        "ToolBar":      "qrc:/qt/qml/toolbar/Main.qml",
        "ScrollView":   "qrc:/qt/qml/scrollview/Main.qml",
        "MenuBar":      "qrc:/qt/qml/menubar/Main.qml",
        "PathView":     "qrc:/qt/qml/pathview/Main.qml",
        "GridView":     "qrc:/qt/qml/gridview/Main.qml",
        "Flickable":    "qrc:/qt/qml/flickable/Main.qml",
        "Shaders":      "qrc:/qt/qml/shaders/Main.qml",
        "Loader":       "qrc:/qt/qml/loaderex/Main.qml",
        "Images":       "qrc:/qt/qml/images/Main.qml",
        "States":       "qrc:/qt/qml/states/Main.qml",
        "FileDialogs":  "qrc:/qt/qml/filedialogs/Main.qml",
        "Network":      "qrc:/qt/qml/network/Main.qml",
        "ChatUI":       "qrc:/qt/qml/chatui/Main.qml",
        "Switches":     "qrc:/qt/qml/switches/Main.qml",
        "TextInputs":   "qrc:/qt/qml/textinputs/Main.qml",
        "Indicators":   "qrc:/qt/qml/indicators/Main.qml",
        "Animations":   "qrc:/qt/qml/animations/Main.qml",
        "Popups":       "qrc:/qt/qml/popups/Main.qml",
        "Lists":        "qrc:/qt/qml/lists/Main.qml",
        "Canvas":       "qrc:/qt/qml/canvas/Main.qml",
        "Layouts":      "qrc:/qt/qml/layouts/Main.qml",
        "Transforms":   "qrc:/qt/qml/transforms/Main.qml",
        "Particles":    "qrc:/qt/qml/particles/Main.qml",
        "Graphs":       "qrc:/qt/qml/graphs/Main.qml",
        "PFD":          "qrc:/qt/qml/pfd/Main.qml",
        "HUD":          "qrc:/qt/qml/hud/Main.qml",
        "WebSocket":    "qrc:/qt/qml/websocketex/Main.qml",
        "ECAM":         "qrc:/qt/qml/ecam/Main.qml",
        "NavDisplay":   "qrc:/qt/qml/navdisplay/Main.qml",
        "Teoria":       "qrc:/qt/qml/theorycpp/Main.qml",
        "Date":         "qrc:/qt/qml/date/Main.qml",
        "AircraftMap":  "qrc:/qt/qml/aircraftmap/Main.qml",
        "Shapes":       "qrc:/qt/qml/shapes/Main.qml",
        "Maps":         "qrc:/qt/qml/maps/Main.qml",
        "PdfReader":    "qrc:/qt/qml/pdfreader/Main.qml",
        "Threads":      "qrc:/qt/qml/threadsex/Main.qml",
        "TableView":    "qrc:/qt/qml/tableview/Main.qml",
        "TreeView":     "qrc:/qt/qml/treeview/Main.qml",
        "Database":     "qrc:/qt/qml/databaseex/Main.qml",
        "Multimedia":   "qrc:/qt/qml/multimedia/Main.qml",
        "CustomItem":   "qrc:/qt/qml/customitemex/Main.qml",
        "QMLCppBridge": "qrc:/qt/qml/qmlcppbridgeex/Main.qml",
        "AsyncCpp":     "qrc:/qt/qml/asynccppex/Main.qml",
        "Settings":     "qrc:/qt/qml/settingsex/Main.qml"
    })

    // --- Workaround para repintar Canvas tras cambio de página ---
    // Algunos ejemplos usan Canvas (dibujo 2D). Cuando se carga una página
    // con Canvas vía Loader, a veces el Canvas no se pinta en el primer frame
    // porque aún no tiene dimensiones finales. Este Timer espera 250ms
    // (suficiente para que el layout se estabilice) y luego fuerza un repaint.
    Timer {
        id: repaintTimer
        interval: 250
        onTriggered: forceRepaintCanvases(root)
    }

    // Función recursiva que recorre todo el árbol de hijos buscando objetos
    // que tengan el método requestPaint() (es decir, Canvas). Cuando lo
    // encuentra, fuerza un repintado.
    // typeof child.requestPaint === "function" es una forma dinámica de
    // detectar si el hijo es un Canvas sin necesidad de importar el tipo.
    function forceRepaintCanvases(item) {
        for (var i = 0; i < item.children.length; i++) {
            var child = item.children[i]
            if (typeof child.requestPaint === "function")
                child.requestPaint()
            forceRepaintCanvases(child)
        }
    }

    // =========================================================================
    // Vista "Dashboard" (home) — Se muestra cuando state === "Dashboard"
    // =========================================================================
    // Patrón de visibilidad con animación:
    //   opacity: binding ternario que vale 1.0 o 0.0 según el estado
    //   visible: se desactiva cuando opacity llega a 0 (optimización: un
    //            item con visible:false no se renderiza ni recibe eventos)
    //   Behavior on opacity: anima cualquier cambio de opacity en 200ms
    //
    // ¿Por qué opacity + visible y no solo visible?
    // Porque visible es binario (true/false), no se puede animar. La opacidad
    // sí se puede animar suavemente. visible: opacity > 0.0 asegura que
    // cuando la animación llega a 0, el item deje de procesarse.
    Item {
        anchors.fill: parent
        opacity: (root.state === "Dashboard") ? 1.0 : 0.0
        visible: opacity > 0.0
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor

            // ScrollView envuelve el contenido para permitir scroll vertical.
            // contentWidth: availableWidth evita scroll horizontal (el contenido
            // se ajusta al ancho disponible).
            // clip: true recorta el contenido que sobresale (necesario para scroll).
            ScrollView {
                id: homeScrollView
                anchors.fill: parent
                anchors.margins: Style.resize(40)
                clip: true
                contentWidth: availableWidth

                // ColumnLayout distribuye los hijos verticalmente con spacing.
                // A diferencia de Column, ColumnLayout permite usar propiedades
                // Layout.* (fillWidth, preferredHeight, etc.) para control fino.
                ColumnLayout {
                    width: homeScrollView.availableWidth
                    spacing: Style.resize(20)

                    // --- Sección de título ---
                    Label {
                        text: "QML Snippets & Examples"
                        font.pixelSize: Style.resize(36)
                        font.bold: true
                        color: Style.mainColor
                        Layout.fillWidth: true
                    }

                    Label {
                        text: "A collection of QML / Qt Quick patterns and components for learning and reference."
                        font.pixelSize: Style.resize(16)
                        color: Style.fontSecondaryColor
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }

                    // Item vacío como espaciador. Es una técnica común en Layouts
                    // cuando necesitas más espacio del que da el spacing uniforme.
                    Item { Layout.preferredHeight: Style.resize(10) }

                    // --- Sección "Built with" ---
                    Label {
                        text: "Built with"
                        font.pixelSize: Style.resize(20)
                        font.bold: true
                        color: Style.fontPrimaryColor
                    }

                    // Repeater con modelo de array de strings.
                    // Cuando el modelo es un array JS (no ListModel), cada
                    // elemento se accede con "modelData" (la propiedad especial
                    // que Qt inyecta para modelos simples sin roles nombrados).
                    // required property string modelData: necesario con
                    // ComponentBehavior Bound (heredado del módulo).
                    // "\u2022" es el carácter Unicode de viñeta (bullet point).
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.leftMargin: Style.resize(10)
                        spacing: Style.resize(6)

                        Repeater {
                            model: [
                                "Qt 6.10 / Qt Quick / QML",
                                "C++ backend with CMake build system",
                                "Qt Quick Controls, Shapes, Particles, Graphs"
                            ]
                            Label {
                                required property string modelData
                                text: "\u2022  " + modelData
                                font.pixelSize: Style.resize(14)
                                color: Style.fontSecondaryColor
                                Layout.fillWidth: true
                            }
                        }
                    }

                    Item { Layout.preferredHeight: Style.resize(10) }

                    // --- Sección "Examples" con contador ---
                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: "Examples"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.fontPrimaryColor
                            Layout.fillWidth: true
                        }

                        Label {
                            text: "51 pages"
                            font.pixelSize: Style.resize(14)
                            color: Style.inactiveColor
                        }
                    }

                    // --- Lista de ejemplos en tarjeta ---
                    // Un Rectangle con radius actúa como tarjeta (card) visual.
                    // implicitHeight se calcula dinámicamente a partir del contenido
                    // interior + padding. Esto permite que el ScrollView sepa cuánto
                    // mide la tarjeta sin necesidad de hardcodear una altura.
                    Rectangle {
                        Layout.fillWidth: true
                        color: Style.cardColor
                        radius: Style.resize(8)
                        implicitHeight: examplesList.implicitHeight + Style.resize(20)

                        // ListModel con dos roles: name y desc.
                        // Un "rol" en Qt es una propiedad nombrada del modelo.
                        // En el delegate se acceden como model.name y model.desc.
                        // ListModel es adecuado aquí porque los datos son estáticos
                        // y se definen en QML. Para datos dinámicos o de C++, se
                        // usaría QAbstractListModel.
                        ListModel {
                            id: examplesModel
                            ListElement { name: "Buttons";    desc: "Standard, icon, toggle, and styled buttons" }
                            ListElement { name: "Sliders";    desc: "Range sliders, styled tracks, custom handles" }
                            ListElement { name: "RangeSliders"; desc: "RangeSlider with formatted labels, vertical, interactive" }
                            ListElement { name: "ComboBox";   desc: "Editable, ListModel roles, validators, interactive demo" }
                            ListElement { name: "TabBar";     desc: "StackLayout, icons, dynamic closable tabs, interactive" }
                            ListElement { name: "SwipeView";  desc: "PageIndicator, card carousel, onboarding wizard" }
                            ListElement { name: "SplitView";  desc: "Horizontal, vertical, nested IDE layout, color mixer" }
                            ListElement { name: "ToolBar";    desc: "ToolButtons, actions, contextual toolbar, text editor" }
                            ListElement { name: "ScrollView"; desc: "Custom ScrollBar, 2D Flickable, infinite scroll" }
                            ListElement { name: "MenuBar";    desc: "MenuBar, context menus, checkable items, submenus" }
                            ListElement { name: "PathView";   desc: "Circular path, arc carousel, coverflow, configurable path" }
                            ListElement { name: "GridView";   desc: "Photo gallery, dynamic items, filterable grid, cell sizing" }
                            ListElement { name: "Flickable";  desc: "Scroll, pinch-to-zoom, snap pages, configurable physics" }
                            ListElement { name: "Shaders";    desc: "GaussianBlur, Glow, DropShadow, ColorOverlay, effect combiner" }
                            ListElement { name: "Loader";     desc: "Component switching, load/unload, dynamic creation, view switcher" }
                            ListElement { name: "Images";    desc: "FillMode, BorderImage 9-patch, OpacityMask shapes, transform properties" }
                            ListElement { name: "States";    desc: "PropertyChanges, easing transitions, traffic light, when conditions" }
                            ListElement { name: "FileDialogs"; desc: "FileDialog open/save, FolderDialog, multi-select, action log" }
                            ListElement { name: "Network";    desc: "XMLHttpRequest, REST API, JSON parser, request builder" }
                            ListElement { name: "ChatUI";    desc: "Chat bubbles, typing indicators, emoji picker, interactive bot" }
                            ListElement { name: "Switches";   desc: "Toggle switches and check controls" }
                            ListElement { name: "TextInputs"; desc: "Text fields, validation, styled inputs" }
                            ListElement { name: "Indicators"; desc: "Progress bars, busy indicators, gauges" }
                            ListElement { name: "Animations"; desc: "Transitions, behaviors, state animations" }
                            ListElement { name: "Popups";     desc: "Dialogs, drawers, tooltips, menus" }
                            ListElement { name: "Lists";      desc: "ListView, delegates, sections" }
                            ListElement { name: "Canvas";     desc: "2D drawing, shapes, paths, pie charts" }
                            ListElement { name: "Layouts";    desc: "Row, Column, Grid, Flow layouts" }
                            ListElement { name: "Transforms"; desc: "Rotation, scale, translate, 3D effects" }
                            ListElement { name: "Particles";  desc: "Emitters, affectors, trails, interactive" }
                            ListElement { name: "Graphs";     desc: "Line series, bar charts, real-time plots" }
                            ListElement { name: "PFD";        desc: "Artificial horizon, speed/altitude tapes, heading" }
                            ListElement { name: "ECAM";       desc: "Engine gauges, warnings, fuel synoptic" }
                            ListElement { name: "HUD";        desc: "Head-up display, pitch ladder, flight path vector" }
                            ListElement { name: "WebSocket"; desc: "C++ class exposed to QML, live echo server" }
                            ListElement { name: "NavDisplay"; desc: "Moving map, compass rose, flight plan" }
                            ListElement { name: "Teoria";     desc: "C++ theory: fundamentals through advanced topics" }
                            ListElement { name: "Date";       desc: "Tumbler date picker, MonthGrid calendar" }
                            ListElement { name: "AircraftMap"; desc: "Interactive blueprint with zoomable markers" }
                            ListElement { name: "Shapes";      desc: "Bezier curves, arcs, SVG paths, gradients, morphing" }
                            ListElement { name: "Maps";        desc: "OSM map, compass overlay, animated GPS route" }
                            ListElement { name: "PdfReader";   desc: "Drag & drop PDF viewer with zoom and navigation" }
                            ListElement { name: "Threads";     desc: "C++ pipeline: QThread, moveToThread, cross-thread signals" }
                            ListElement { name: "TableView";   desc: "C++ QAbstractTableModel, sort/filter proxy, editable cells" }
                            ListElement { name: "TreeView";    desc: "C++ QAbstractItemModel, tree hierarchy, expand/collapse, add/remove" }
                            ListElement { name: "Database";    desc: "SQLite CRUD with QSqlTableModel, query explorer, data dashboard" }
                            ListElement { name: "Multimedia";  desc: "Video player, audio spectrum, camera capture, playback controls" }
                            ListElement { name: "CustomItem";  desc: "QQuickPaintedItem: clock, waveform, gauge, drawing canvas" }
                            ListElement { name: "QMLCppBridge"; desc: "Q_PROPERTY, Q_INVOKABLE, Q_ENUM, C++ signals to QML" }
                            ListElement { name: "AsyncCpp";     desc: "QtConcurrent, QFuture, QPromise, progress and cancellation" }
                            ListElement { name: "Settings";     desc: "QSettings persistent preferences, key-value store, groups" }
                        }

                        // ColumnLayout con spacing 0: las filas van pegadas,
                        // separadas solo por el Rectangle de 1px (separador visual).
                        ColumnLayout {
                            id: examplesList
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: Style.resize(10)
                            spacing: 0

                            Repeater {
                                model: examplesModel

                                // Cada fila: nombre del ejemplo + descripción.
                                // required property: declara explícitamente qué roles
                                // del modelo usa el delegate (necesario con
                                // ComponentBehavior Bound). Qt inyecta los valores
                                // automáticamente al instanciar cada delegate.
                                Item {
                                    id: exampleDelegate
                                    required property string name
                                    required property string desc
                                    required property int index
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(36)

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: Style.resize(10)
                                        anchors.rightMargin: Style.resize(10)
                                        spacing: Style.resize(15)

                                        Label {
                                            text: exampleDelegate.name
                                            font.pixelSize: Style.resize(14)
                                            font.bold: true
                                            color: Style.mainColor
                                            Layout.preferredWidth: Style.resize(110)
                                        }

                                        // elide: Text.ElideRight trunca el texto con "..."
                                        // si no cabe en el ancho disponible, evitando
                                        // desbordamiento horizontal.
                                        Label {
                                            text: exampleDelegate.desc
                                            font.pixelSize: Style.resize(13)
                                            color: Style.fontSecondaryColor
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }
                                    }

                                    // Línea separadora entre filas. Se oculta en el último
                                    // elemento (index < count - 1) para no tener línea suelta
                                    // al final de la lista.
                                    Rectangle {
                                        anchors.bottom: parent.bottom
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.leftMargin: Style.resize(10)
                                        anchors.rightMargin: Style.resize(10)
                                        height: 1
                                        color: "#3A3D45"
                                        visible: exampleDelegate.index < examplesModel.count - 1
                                    }
                                }
                            }
                        }
                    }

                    Item { Layout.preferredHeight: Style.resize(5) }

                    Label {
                        text: "Select a page from the menu to explore examples."
                        font.pixelSize: Style.resize(14)
                        font.italic: true
                        color: Style.inactiveColor
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Item { Layout.preferredHeight: Style.resize(20) }
                }
            }
        }
    }

    // =========================================================================
    // Loader dinámico — Carga lazy de páginas de ejemplo
    // =========================================================================
    // Este es el corazón de la navegación. A diferencia del Item "Dashboard"
    // de arriba (que siempre existe), el Loader crea/destruye páginas según
    // el estado actual.
    //
    // source: binding reactivo. Cada vez que root.state cambia:
    //   1. pageMap[root.state] busca la URI correspondiente
    //   2. El operador ?? "" devuelve string vacío si el estado no está
    //      en el mapa (ej: "Dashboard"), lo que hace que el Loader descargue
    //      cualquier página previa y quede vacío
    //   3. Si la URI es válida, el Loader carga el archivo QML, instancia
    //      el componente y lo asigna a la propiedad "item"
    //
    // onLoaded: se ejecuta cuando el Loader termina de instanciar el componente.
    //   - item.fullSize = true activa la animación de entrada de la página
    //     (cada Main.qml de ejemplo tiene el patrón opacity: fullSize ? 1 : 0)
    //   - repaintTimer.restart() fuerza el repaint de Canvas tras 250ms
    //
    // Ventaja sobre import directo: con 50+ páginas, el Loader mantiene solo
    // 1 página en memoria. Sin Loader, las 50 estarían instanciadas siempre.
    Loader {
        id: pageLoader
        anchors.fill: parent
        source: root.pageMap[root.state] ?? ""
        onLoaded: {
            if (item) {
                item.fullSize = true
            }
            repaintTimer.restart()
        }
    }
}
