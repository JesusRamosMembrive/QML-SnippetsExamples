// ============================================================================
// RestApiCard - Multiples endpoints REST con seleccion dinamica
// ============================================================================
//
// CONCEPTOS CLAVE:
//
// 1. Consumo de API REST desde QML:
//    - Usa XMLHttpRequest (built-in en QML) para hacer peticiones GET
//      a diferentes endpoints de una API REST (JSONPlaceholder).
//    - JSON.parse() convierte la respuesta JSON en un array de objetos JS
//      que se puede usar directamente como modelo de un Repeater.
//
// 2. Patron de configuracion con array de objetos:
//    - "endpoints" es un array readonly de objetos JS que define cada
//      endpoint disponible (nombre, URL, icono, categoria).
//    - selectedEndpoint es un indice que selecciona el endpoint activo.
//    - Este patron permite agregar nuevos endpoints sin tocar la logica,
//      solo se agrega un nuevo objeto al array.
//
// 3. property var items: [] (array JS reactivo):
//    - QML puede usar arrays de JS como modelo de Repeater.
//    - Al reasignar root.items = JSON.parse(...), QML recrea todos los
//      delegates del Repeater automaticamente.
//    - IMPORTANTE: modificar elementos individuales del array (push, splice)
//      NO dispara notificaciones. Se debe reasignar el array completo.
//
// 4. Repeater con required properties:
//    - "required property var modelData" y "required property int index"
//      son la forma moderna (Qt 6) de acceder a datos del modelo.
//    - modelData contiene el objeto JS completo del item actual.
//    - Reemplaza el antiguo patron de acceder via "modelData.xxx" implicito.
//
// 5. Acceso flexible a campos JSON:
//    - modelData.title || modelData.name || modelData.body || ""
//    - Usa el operador || de JS para mostrar el primer campo disponible.
//    - Esto permite que un mismo delegate muestre datos de endpoints con
//      estructuras JSON diferentes (posts, users, todos, comments).
//
// ============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property bool loading: false
    property var items: []
    property int selectedEndpoint: 0

    // Definicion declarativa de endpoints disponibles.
    // readonly evita modificaciones accidentales desde QML.
    // Cada objeto tiene: nombre para el boton, URL completa, icono Unicode, categoria.
    readonly property var endpoints: [
        { name: "Posts",   url: "https://jsonplaceholder.typicode.com/posts?_limit=5",   icon: "\u2759" },
        { name: "Users",   url: "https://jsonplaceholder.typicode.com/users?_limit=5",   icon: "\u263A" },
        { name: "Todos",   url: "https://jsonplaceholder.typicode.com/todos?_limit=5",   icon: "\u2713" },
        { name: "Comments", url: "https://jsonplaceholder.typicode.com/comments?_limit=5", icon: "\u2709" }
    ]

    // Peticion al endpoint seleccionado.
    // JSON.parse() convierte el string JSON en un array JS que se asigna
    // directamente a items, lo que dispara la recreacion del Repeater.
    function fetchEndpoint() {
        root.loading = true
        root.items = []
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                root.loading = false
                if (xhr.status === 200) {
                    root.items = JSON.parse(xhr.responseText)
                }
            }
        }
        xhr.open("GET", root.endpoints[root.selectedEndpoint].url)
        xhr.send()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "REST API"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Pestanas de endpoints: Repeater genera un boton por cada endpoint.
        // "highlighted" resalta visualmente el endpoint seleccionado.
        // Al hacer clic se actualiza el indice y se dispara la peticion.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Repeater {
                model: root.endpoints

                Button {
                    required property var modelData
                    required property int index
                    text: modelData.icon + " " + modelData.name
                    font.pixelSize: Style.resize(10)
                    highlighted: root.selectedEndpoint === index
                    Layout.fillWidth: true
                    onClicked: {
                        root.selectedEndpoint = index
                        root.fetchEndpoint()
                    }
                }
            }
        }

        // Area de resultados: Flickable + Repeater para lista scrollable.
        // Cada item del array JSON se renderiza como una fila con
        // ID, titulo/nombre, detalle secundario y badge opcional.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(8)

            Flickable {
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                clip: true
                contentHeight: resultsCol.height

                ColumnLayout {
                    id: resultsCol
                    width: parent.width
                    spacing: Style.resize(4)

                    Repeater {
                        model: root.items

                        Rectangle {
                            required property var modelData
                            required property int index
                            Layout.fillWidth: true
                            height: Style.resize(44)
                            radius: Style.resize(4)
                            // Filas alternas con color de fondo para legibilidad
                            color: index % 2 === 0 ? "#2A2D35" : "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: Style.resize(6)
                                spacing: Style.resize(8)

                                Label {
                                    text: (modelData.id !== undefined) ? modelData.id.toString() : (index + 1).toString()
                                    font.pixelSize: Style.resize(12)
                                    font.bold: true
                                    color: Style.mainColor
                                    Layout.preferredWidth: Style.resize(24)
                                    horizontalAlignment: Text.AlignCenter
                                }

                                // Columna de texto con acceso flexible a campos.
                                // El operador || (OR logico de JS) selecciona el
                                // primer valor truthy, adaptandose a la estructura
                                // del endpoint actual.
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 0
                                    Label {
                                        text: modelData.title || modelData.name || modelData.body || ""
                                        font.pixelSize: Style.resize(11)
                                        color: Style.fontPrimaryColor
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }
                                    Label {
                                        text: modelData.email || modelData.body || ""
                                        font.pixelSize: Style.resize(9)
                                        color: Style.fontSecondaryColor
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                        visible: text !== ""
                                    }
                                }

                                // Badge de estado para el endpoint "todos":
                                // Visible solo cuando el campo "completed" existe.
                                // Demuestra renderizado condicional segun la estructura
                                // de datos del endpoint.
                                Rectangle {
                                    width: Style.resize(16)
                                    height: Style.resize(16)
                                    radius: Style.resize(8)
                                    color: modelData.completed ? "#00D1A9" : "#FF7043"
                                    visible: modelData.completed !== undefined
                                    Label {
                                        anchors.centerIn: parent
                                        text: modelData.completed ? "\u2713" : "\u2715"
                                        font.pixelSize: Style.resize(9)
                                        color: "#FFFFFF"
                                    }
                                }
                            }
                        }
                    }
                }
            }

            BusyIndicator {
                anchors.centerIn: parent
                running: root.loading
                visible: root.loading
            }

            // Placeholder cuando no hay datos: guia al usuario
            Label {
                anchors.centerIn: parent
                text: "Select an endpoint above"
                font.pixelSize: Style.resize(13)
                color: Style.inactiveColor
                visible: root.items.length === 0 && !root.loading
            }
        }

        Label {
            text: root.items.length > 0 ? root.items.length + " items loaded" : ""
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
