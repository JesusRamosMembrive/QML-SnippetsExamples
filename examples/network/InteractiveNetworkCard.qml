// =============================================================================
// InteractiveNetworkCard.qml — Constructor de peticiones HTTP interactivo
// =============================================================================
// Mini-cliente REST tipo Postman que permite al usuario seleccionar metodo
// HTTP (GET/POST/PUT/DELETE), escribir la URL, enviar la peticion y ver
// la respuesta con codigo de estado y tiempo de respuesta.
//
// CONCEPTOS CLAVE:
//
// 1. XMLHttpRequest con multiples metodos HTTP:
//    - xhr.open(method, url) acepta cualquier metodo HTTP como string.
//    - Para POST/PUT, se envia un body JSON con xhr.send(bodyText) y se
//      agrega el header "Content-Type: application/json".
//    - Para GET/DELETE, xhr.send() se llama sin argumentos.
//
// 2. ComboBox para seleccion de metodo:
//    - ComboBox con model: ["GET", "POST", "PUT", "DELETE"] permite al
//      usuario elegir el metodo. currentText devuelve la seleccion actual.
//    - El campo de body solo es visible para POST/PUT (visible: binding).
//
// 3. Medicion de tiempo de respuesta:
//    - Date.now() antes y despues de la peticion calcula el responseTime.
//    - Esto da feedback al usuario sobre la latencia de la API.
//
// 4. Quick endpoints con Repeater:
//    - Botones de acceso rapido que pre-cargan URLs de ejemplo.
//    - Parecido al sistema de "saved requests" de Postman.
//
// 5. Barra de estado con colores semanticos:
//    - Verde (200-299): exito. Rojo (400+): error. Amarillo: otros.
//    - Las expresiones ternarias encadenadas manejan los rangos de status.
// =============================================================================
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // --- Propiedades de estado ---
    // Controlan la UI reactivamente: loading deshabilita el boton y muestra
    // BusyIndicator, statusCode colorea la barra de estado, etc.
    property bool loading: false
    property string response: ""
    property int statusCode: 0
    property int responseTime: 0

    // Envia la peticion HTTP segun el metodo y URL seleccionados.
    // Para POST/PUT incluye body JSON con el header correspondiente.
    function sendRequest() {
        root.loading = true
        root.response = ""
        root.statusCode = 0
        var startTime = Date.now()

        var method = methodCombo.currentText
        var url = urlField.text.trim()
        if (!url) return

        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                root.loading = false
                root.statusCode = xhr.status
                root.responseTime = Date.now() - startTime

                try {
                    var obj = JSON.parse(xhr.responseText)
                    root.response = JSON.stringify(obj, null, 2)
                } catch(e) {
                    root.response = xhr.responseText
                }
            }
        }
        xhr.onerror = function() {
            root.loading = false
            root.response = "Network error"
            root.responseTime = Date.now() - startTime
        }
        xhr.open(method, url)
        if (method === "POST" && bodyField.text.trim()) {
            xhr.setRequestHeader("Content-Type", "application/json")
            xhr.send(bodyField.text.trim())
        } else {
            xhr.send()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Request Builder"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Fila de metodo + URL: ComboBox para seleccion de metodo HTTP
        // y TextField para la URL destino. El layout se adapta al ancho.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            ComboBox {
                id: methodCombo
                model: ["GET", "POST", "PUT", "DELETE"]
                Layout.preferredWidth: Style.resize(85)
                font.pixelSize: Style.resize(11)
            }

            TextField {
                id: urlField
                Layout.fillWidth: true
                text: "https://jsonplaceholder.typicode.com/posts/1"
                font.pixelSize: Style.resize(11)
                placeholderText: "Enter URL..."
            }
        }

        // Campo de body: solo visible para POST/PUT.
        // El binding en "visible" oculta automaticamente este campo para GET/DELETE.
        TextField {
            id: bodyField
            Layout.fillWidth: true
            visible: methodCombo.currentText === "POST" || methodCombo.currentText === "PUT"
            placeholderText: '{"title": "test", "body": "hello"}'
            font.pixelSize: Style.resize(11)
            text: '{"title": "test", "body": "hello", "userId": 1}'
        }

        // Endpoints rapidos: botones que pre-cargan URLs de ejemplo.
        // Cada objeto del modelo tiene un label corto y la URL completa.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(4)

            Label {
                text: "Quick:"
                font.pixelSize: Style.resize(10)
                color: Style.fontSecondaryColor
            }

            Repeater {
                model: [
                    { lbl: "Post", url: "https://jsonplaceholder.typicode.com/posts/1" },
                    { lbl: "User", url: "https://jsonplaceholder.typicode.com/users/1" },
                    { lbl: "Todo", url: "https://jsonplaceholder.typicode.com/todos/1" }
                ]

                Button {
                    required property var modelData
                    text: modelData.lbl
                    font.pixelSize: Style.resize(9)
                    onClicked: urlField.text = modelData.url
                }
            }
        }

        Button {
            text: root.loading ? "Loading..." : "Send Request"
            Layout.fillWidth: true
            enabled: !root.loading && urlField.text.trim()
            onClicked: root.sendRequest()
        }

        // Barra de estado: muestra codigo HTTP, tiempo y tamano de respuesta.
        // Solo visible cuando se ha recibido una respuesta (statusCode > 0).
        // Los colores indican exito (verde), error (rojo) o redireccion (amarillo).
        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(28)
            radius: Style.resize(4)
            color: Style.surfaceColor
            visible: root.statusCode > 0

            RowLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(6)

                Rectangle {
                    width: Style.resize(40)
                    height: Style.resize(18)
                    radius: Style.resize(3)
                    color: root.statusCode >= 200 && root.statusCode < 300 ? "#00D1A9"
                         : root.statusCode >= 400 ? "#FF7043"
                         : "#FEA601"
                    opacity: 0.2

                    Label {
                        anchors.centerIn: parent
                        text: root.statusCode.toString()
                        font.pixelSize: Style.resize(10)
                        font.bold: true
                        color: root.statusCode >= 200 && root.statusCode < 300 ? "#00D1A9"
                             : root.statusCode >= 400 ? "#FF7043"
                             : "#FEA601"
                    }
                }

                Label {
                    text: root.responseTime + "ms"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.fillWidth: true
                }

                Label {
                    text: root.response.length + " bytes"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }
            }
        }

        // Area de respuesta: muestra el body de la respuesta HTTP formateado.
        // Flickable permite scroll vertical para respuestas largas.
        // BusyIndicator se superpone mientras la peticion esta en curso.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(6)

            Flickable {
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                clip: true
                contentHeight: respLabel.height

                Label {
                    id: respLabel
                    width: parent.width
                    text: root.response || "Response will appear here"
                    font.pixelSize: Style.resize(10)
                    font.family: "Consolas"
                    color: root.response ? Style.fontPrimaryColor : Style.inactiveColor
                    wrapMode: Text.WrapAnywhere
                }
            }

            BusyIndicator {
                anchors.centerIn: parent
                running: root.loading
                visible: root.loading
            }
        }
    }
}
