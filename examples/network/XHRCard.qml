// ============================================================================
// XHRCard - Peticion HTTP con XMLHttpRequest nativo de QML
// ============================================================================
//
// CONCEPTOS CLAVE:
//
// 1. XMLHttpRequest en QML:
//    - QML incluye una implementacion nativa de XMLHttpRequest (similar a la
//      del navegador web) que permite hacer peticiones HTTP sin C++.
//    - Es ideal para prototipos rapidos y APIs sencillas, pero para
//      aplicaciones complejas se recomienda usar QNetworkAccessManager en C++.
//    - La API es asincrona: se configura un callback en onreadystatechange
//      que se ejecuta cuando cambia el estado de la peticion.
//
// 2. Ciclo de vida de XMLHttpRequest:
//    - new XMLHttpRequest() -> crea el objeto
//    - xhr.open("GET", url)  -> configura metodo y URL (no envia aun)
//    - xhr.send()            -> envia la peticion
//    - onreadystatechange    -> callback que monitorea los estados:
//      * UNSENT (0), OPENED (1), HEADERS_RECEIVED (2), LOADING (3), DONE (4)
//    - Solo cuando readyState === DONE se puede leer status y responseText.
//
// 3. Manejo de errores:
//    - xhr.status contiene el codigo HTTP (200, 404, 500, etc.)
//    - xhr.onerror captura errores de red (sin conexion, timeout, CORS).
//    - Es buena practica manejar ambos: errores HTTP y errores de red.
//
// 4. Patron de estado para UI:
//    - Se usan propiedades reactivas (loading, responseText, statusCode,
//      errorMsg) que controlan la UI automaticamente.
//    - Cuando loading=true, se muestra BusyIndicator y se deshabilita el boton.
//    - Las expresiones ternarias encadenadas en text/color permiten mostrar
//      diferentes estados sin logica imperativa.
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

    // --- Propiedades de estado ---
    // Estas propiedades reactivas controlan toda la UI de la card.
    // Al cambiar cualquiera, los bindings de QML actualizan la vista.
    property bool loading: false
    property string responseText: ""
    property int statusCode: 0
    property string errorMsg: ""

    // --- Funcion de peticion HTTP ---
    // Demuestra el flujo completo de XMLHttpRequest:
    // 1. Resetear estado previo
    // 2. Crear XHR y configurar callbacks
    // 3. Abrir conexion y enviar
    function fetchData() {
        root.loading = true
        root.responseText = ""
        root.errorMsg = ""
        root.statusCode = 0

        var xhr = new XMLHttpRequest()

        // Callback principal: se ejecuta cada vez que cambia readyState.
        // Solo nos interesa DONE (4) = peticion completada.
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                root.loading = false
                root.statusCode = xhr.status
                if (xhr.status === 200) {
                    root.responseText = xhr.responseText
                } else {
                    root.errorMsg = "HTTP " + xhr.status + " " + xhr.statusText
                }
            }
        }

        // Callback de error de red (sin conexion, DNS, etc.)
        // Distinto de errores HTTP como 404 o 500.
        xhr.onerror = function() {
            root.loading = false
            root.errorMsg = "Network error"
        }

        // open() configura el metodo y la URL pero NO envia la peticion.
        // send() envia efectivamente la peticion al servidor.
        xhr.open("GET", "https://jsonplaceholder.typicode.com/posts/1")
        xhr.send()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "XMLHttpRequest"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "GET request to REST API"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        // Barra visual que muestra el metodo HTTP y la URL destino,
        // simulando la barra de un cliente REST como Postman.
        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(32)
            radius: Style.resize(4)
            color: Style.surfaceColor

            RowLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(6)
                spacing: Style.resize(6)

                Rectangle {
                    width: Style.resize(36)
                    height: Style.resize(20)
                    radius: Style.resize(3)
                    color: "#00D1A9"
                    opacity: 0.2
                    Label {
                        anchors.centerIn: parent
                        text: "GET"
                        font.pixelSize: Style.resize(9)
                        font.bold: true
                        color: "#00D1A9"
                    }
                }
                Label {
                    text: "jsonplaceholder.typicode.com/posts/1"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }
        }

        // Area de respuesta con Flickable para contenido largo.
        // Muestra diferentes textos y colores segun el estado actual,
        // usando expresiones ternarias encadenadas (patron comun en QML).
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(8)

            Flickable {
                anchors.fill: parent
                anchors.margins: Style.resize(10)
                clip: true
                contentHeight: responseLabel.height

                Label {
                    id: responseLabel
                    width: parent.width
                    text: root.loading ? "Loading..."
                        : root.errorMsg ? root.errorMsg
                        : root.responseText ? root.responseText
                        : "Press Fetch to make a request"
                    font.pixelSize: Style.resize(11)
                    font.family: "Consolas"
                    color: root.errorMsg ? "#FF7043"
                         : root.loading ? Style.inactiveColor
                         : root.responseText ? Style.fontPrimaryColor
                         : Style.inactiveColor
                    wrapMode: Text.WrapAnywhere
                }
            }

            // BusyIndicator: indicador de carga nativo de Qt Quick Controls.
            // Se superpone al contenido durante la peticion.
            BusyIndicator {
                anchors.centerIn: parent
                running: root.loading
                visible: root.loading
            }
        }

        // Barra inferior: codigo de estado HTTP + boton de accion.
        // El boton se deshabilita durante la carga para evitar peticiones duplicadas.
        RowLayout {
            Layout.fillWidth: true

            Label {
                text: root.statusCode > 0 ? "Status: " + root.statusCode : ""
                font.pixelSize: Style.resize(12)
                color: root.statusCode === 200 ? "#00D1A9" : "#FF7043"
                Layout.fillWidth: true
            }

            Button {
                text: "Fetch"
                enabled: !root.loading
                onClicked: root.fetchData()
            }
        }
    }
}
