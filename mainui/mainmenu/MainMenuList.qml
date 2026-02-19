// =============================================================================
// MainMenuList.qml — Lista de navegación del menú lateral (sidebar)
// =============================================================================
// Implementa el menú lateral usando el patrón Model/View/Delegate de Qt:
//
//   - Model: ListModel (menuModel) con los nombres de todas las páginas
//   - View: ListView (listView) que renderiza los items visibles con scroll
//   - Delegate: ItemDelegate que define cómo se dibuja cada item del menú
//
// ¿Por qué Model/View/Delegate y no simplemente una Column con Repeater?
// ListView tiene scroll nativo, reciclaje de delegates (solo crea los
// visibles en pantalla) y highlight integrado. Con 50+ items, esto es
// mucho más eficiente que un Repeater que instancia todos a la vez.
//
// Comunicación con el exterior:
//   - currentItemName (property): expone el nombre del item seleccionado
//     para que HomePage lo muestre en el Header
//   - menuItemClicked (signal): notifica a HomePage que el usuario hizo
//     clic, para que cambie el estado del Dashboard
// =============================================================================

pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects   // Para ColorOverlay (tintado de iconos)

import utils
import controls

Item {
    id: root
    width: parent.width
    height: parent.height

    // --- API pública del componente ---
    // currentItemName: se lee desde HomePage para mostrar en el Header.
    // Usa menuModel.get(index).name para obtener el nombre del elemento
    // seleccionado actualmente en el ListView.
    //
    // signal menuItemClicked(var name): declara una señal personalizada.
    // Las señales en QML son el mecanismo principal de comunicación
    // hijo → padre. El padre conecta con onMenuItemClicked: function(name) {...}
    // Se usa "var" como tipo del parámetro por flexibilidad, aunque "string"
    // también funcionaría aquí.
    property string currentItemName: menuModel.get(listView.currentIndex).name
    signal menuItemClicked(var name)

    // --- Modelo de datos: ListModel ---
    // ListModel es un modelo QML puro (declarativo, definido en QML).
    // Cada ListElement tiene un rol "name" que coincide exactamente con
    // las claves del pageMap en Dashboard.qml.
    //
    // IMPORTANTE: el orden aquí determina el orden visual del menú.
    // El texto debe coincidir EXACTAMENTE con las claves en Dashboard.pageMap
    // y con los nombres de iconos en imports/assets/icons/<name>.png.
    //
    // Alternativas al ListModel para modelos:
    //   - Array JS: ["a","b","c"] → más simple pero sin roles nombrados
    //   - QAbstractListModel (C++): para datos dinámicos o de base de datos
    //   - QStringList expuesto desde C++: para listas simples de strings
    ListModel {
        id: menuModel
        ListElement { name: "Dashboard" }
        ListElement { name: "Buttons" }
        ListElement { name: "Sliders" }
        ListElement { name: "RangeSliders" }
        ListElement { name: "ComboBox" }
        ListElement { name: "TabBar" }
        ListElement { name: "SwipeView" }
        ListElement { name: "SplitView" }
        ListElement { name: "ToolBar" }
        ListElement { name: "ScrollView" }
        ListElement { name: "MenuBar" }
        ListElement { name: "PathView" }
        ListElement { name: "GridView" }
        ListElement { name: "Flickable" }
        ListElement { name: "Shaders" }
        ListElement { name: "Loader" }
        ListElement { name: "Images" }
        ListElement { name: "States" }
        ListElement { name: "FileDialogs" }
        ListElement { name: "Network" }
        ListElement { name: "ChatUI" }
        ListElement { name: "Switches" }
        ListElement { name: "TextInputs" }
        ListElement { name: "Indicators" }
        ListElement { name: "Animations" }
        ListElement { name: "Popups" }
        ListElement { name: "Lists" }
        ListElement { name: "Canvas" }
        ListElement { name: "Layouts" }
        ListElement { name: "Transforms" }
        ListElement { name: "Particles" }
        ListElement { name: "Graphs" }
        ListElement { name: "PFD" }
        ListElement { name: "HUD" }
        ListElement { name: "WebSocket" }
        ListElement { name: "ECAM" }
        ListElement { name: "NavDisplay" }
        ListElement { name: "Teoria" }
        ListElement { name: "Date" }
        ListElement { name: "AircraftMap" }
        ListElement { name: "Shapes" }
        ListElement { name: "Maps" }
        ListElement { name: "PdfReader" }
        ListElement { name: "Threads" }
        ListElement { name: "TableView" }
        ListElement { name: "TreeView" }
        ListElement { name: "Database" }
        ListElement { name: "Multimedia" }
        ListElement { name: "CustomItem" }
        ListElement { name: "QMLCppBridge" }
        ListElement { name: "AsyncCpp" }
        ListElement { name: "Settings" }
    }

    // --- Vista: ListView ---
    // ListView es la vista más usada en Qt Quick. Renderiza items en una lista
    // vertical (u horizontal con orientation: Qt.Horizontal).
    //
    // clip: true → recorta los delegates que sobresalen del área visible.
    //   Sin clip, los items de arriba/abajo se dibujarían fuera del ListView.
    //   Es obligatorio en casi todos los ListView/Flickable.
    //
    // highlight: define el indicador visual del item seleccionado.
    //   ListView lo posiciona automáticamente sobre el delegate del currentIndex.
    //   Aquí es un fondo semi-transparente + una barra vertical a la izquierda
    //   (patrón típico de sidebar activa, como en VS Code o Discord).
    //
    // spacing: separación entre delegates (no entre highlight y delegate).
    ListView {
        id: listView
        anchors.fill: parent
        clip: true
        highlight: Item {
            width: listView.width
            height: Style.resize(47)
            // Fondo con 12% de opacidad del color principal (efecto "seleccionado")
            Rectangle {
                anchors.fill: parent
                color: Style.mainColor
                opacity: 0.12
            }
            // Barra indicadora a la izquierda (4px de ancho, color sólido)
            Rectangle {
                width: Style.resize(4)
                height: parent.height
                color: Style.mainColor
            }
        }
        spacing: Style.resize(20)
        model: menuModel

        // --- Delegate: cómo se dibuja cada item del menú ---
        // ItemDelegate es un tipo de Qt Quick Controls 2 diseñado para items
        // de lista. Hereda de AbstractButton, así que tiene señal onClicked,
        // estados hover/pressed, y propiedades background/contentItem.
        //
        // required property int index / string name:
        //   Con ComponentBehavior: Bound, debemos declarar explícitamente cada
        //   rol del modelo que usamos. "index" es inyectado automáticamente
        //   por ListView (posición del delegate en la lista). "name" viene
        //   del rol "name" de nuestro ListModel.
        //
        // ¿Por qué menuDelegate.name en vez de simplemente "name"?
        //   Con Bound, se debe calificar completamente el acceso: id.propiedad.
        //   Esto evita ambigüedades (¿"name" es del delegate, del padre, o
        //   del modelo?) y elimina warnings de qmllint.
        delegate: ItemDelegate {
            id: menuDelegate
            required property int index
            required property string name

            width: listView.width
            height: Style.resize(47)
            // background transparente: no queremos el fondo por defecto del estilo,
            // ya que usamos el highlight del ListView para indicar selección.
            background: Rectangle { color: "transparent" }

            // contentItem: define el contenido visual del ItemDelegate.
            // Es una propiedad de Control que reemplaza el contenido por defecto.
            // Aquí ponemos un icono + texto en horizontal.
            contentItem: Item {
                anchors.fill: parent

                // Icono del menú. Style.icon(name) devuelve la ruta al PNG
                // correspondiente (ej: "qrc:/assets/icons/buttons.png").
                // Los iconos originales son teal (#00D1A9) pero se tintan
                // a blanco con ColorOverlay para que encajen con el tema oscuro.
                //
                // layer.enabled + layer.effect: mecanismo de Qt Quick para
                // aplicar efectos gráficos (shaders) sobre un item.
                // layer.enabled: true hace que el item se renderice primero
                // en un framebuffer offscreen, y luego layer.effect aplica
                // el shader (ColorOverlay) sobre ese framebuffer.
                // Sin layer.enabled, el efecto no se aplica.
                //
                // ColorOverlay (de Qt5Compat.GraphicalEffects): reemplaza
                // todos los píxeles no-transparentes por el color indicado,
                // manteniendo la transparencia original. Perfecto para iconos
                // monocromáticos.
                Image {
                    id: iconImage
                    width: Style.resize(sourceSize.width)
                    height: Style.resize(sourceSize.height)
                    anchors.left: parent.left
                    anchors.leftMargin: Style.resize(40)
                    anchors.verticalCenter: parent.verticalCenter
                    source: Style.icon(menuDelegate.name.toLowerCase())
                    layer.enabled: true
                    layer.effect: ColorOverlay {
                        color: "#ffffff"
                    }
                }

                // Nombre del item alineado a la derecha del icono
                Label {
                    anchors.left: iconImage.right
                    anchors.leftMargin: Style.resize(20)
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: Style.resize(3)  // Ajuste fino visual
                    text: menuDelegate.name
                    color: "#ffffff"
                }
            }

            // Al hacer clic:
            //   1. Actualizamos currentIndex del ListView (mueve el highlight)
            //   2. Emitimos la señal menuItemClicked para que HomePage
            //      cambie el estado del Dashboard
            onClicked: {
                listView.currentIndex = menuDelegate.index;
                root.menuItemClicked(menuDelegate.name);
            }
        }
    }
}
