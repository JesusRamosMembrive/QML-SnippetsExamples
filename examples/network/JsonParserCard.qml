// =============================================================================
// JsonParserCard.qml — Parser y formateador de JSON en tiempo real
// =============================================================================
// Herramienta interactiva que parsea JSON introducido por el usuario y lo
// muestra formateado con indentacion. Incluye validacion en tiempo real
// con indicador de estado (valido/error).
//
// CONCEPTOS CLAVE:
//
// 1. JSON.parse() y JSON.stringify() en QML:
//    - QML incluye el motor de JavaScript completo, por lo que JSON.parse()
//      y JSON.stringify() estan disponibles sin dependencias externas.
//    - JSON.parse() convierte string a objeto JS. Si el JSON es invalido,
//      lanza una excepcion que se captura con try/catch.
//
// 2. Renderizado recursivo de valores:
//    - renderValue() es una funcion recursiva que formatea cualquier tipo
//      JS (string, number, boolean, array, object) con indentacion.
//    - Los arrays y objetos se recorren recursivamente, acumulando niveles
//      de indentacion. Esto genera la salida "pretty-printed".
//
// 3. Validacion reactiva con onTextChanged:
//    - Cada cambio en el TextArea dispara onTextChanged -> parseInput().
//    - parseInput() actualiza parsedData o parseError, lo que actualiza
//      automaticamente la barra de estado y el output formateado.
//    - Component.onCompleted hace el parseo inicial con el JSON de ejemplo.
//
// 4. TextArea vs TextField:
//    - TextArea soporta multiples lineas (ideal para editar JSON).
//    - wrapMode: TextEdit.Wrap evita scroll horizontal.
//    - font.family: "Consolas" usa fuente monoespaciada para alineacion.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // --- Estado del parser ---
    // parsedData contiene el objeto JS parseado (o null si hay error).
    // rawJson guarda el texto original. parseError contiene el mensaje
    // de error de JSON.parse() si el input es invalido.
    property var parsedData: null
    property string rawJson: ""
    property string parseError: ""

    // JSON de ejemplo: demuestra strings, numeros, arrays y objetos anidados.
    readonly property string sampleJson: '{\n  "name": "Qt Framework",\n  "version": "6.10",\n  "languages": ["C++", "QML", "JS"],\n  "features": {\n    "cross_platform": true,\n    "modules": 42\n  }\n}'

    // Parsea el texto y actualiza el estado. try/catch maneja JSON invalido.
    function parseInput(text) {
        root.parseError = ""
        root.parsedData = null
        root.rawJson = text
        try {
            root.parsedData = JSON.parse(text)
        } catch(e) {
            root.parseError = e.message
        }
    }

    // Funcion recursiva que formatea un valor JS con indentacion.
    // Maneja todos los tipos: null, boolean, number, string, array, object.
    function renderValue(val, indent) {
        if (val === null) return "null"
        if (val === undefined) return "undefined"
        if (typeof val === "boolean") return val.toString()
        if (typeof val === "number") return val.toString()
        if (typeof val === "string") return '"' + val + '"'
        if (Array.isArray(val)) {
            var items = []
            for (var i = 0; i < val.length; i++)
                items.push(indent + "  " + renderValue(val[i], indent + "  "))
            return "[\n" + items.join(",\n") + "\n" + indent + "]"
        }
        if (typeof val === "object") {
            var parts = []
            var keys = Object.keys(val)
            for (var k = 0; k < keys.length; k++)
                parts.push(indent + '  "' + keys[k] + '": ' + renderValue(val[keys[k]], indent + "  "))
            return "{\n" + parts.join(",\n") + "\n" + indent + "}"
        }
        return String(val)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(12)

        Label {
            text: "JSON Parser"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // Area de entrada: TextArea multilinea con fuente monoespaciada.
        // Cada cambio en el texto dispara parseInput() via onTextChanged.
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(120)
            color: Style.surfaceColor
            radius: Style.resize(6)

            ScrollView {
                anchors.fill: parent
                anchors.margins: Style.resize(6)

                TextArea {
                    id: jsonInput
                    text: root.sampleJson
                    font.pixelSize: Style.resize(11)
                    font.family: "Consolas"
                    color: Style.fontPrimaryColor
                    wrapMode: TextEdit.Wrap
                    onTextChanged: root.parseInput(text)
                    Component.onCompleted: root.parseInput(text)
                }
            }
        }

        // Barra de estado: verde si el JSON es valido, rojo si hay error.
        // El texto muestra el mensaje de error o "Valid JSON" + el tipo del dato.
        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(28)
            radius: Style.resize(4)
            color: root.parseError ? "#3A1A17" : "#1A3A35"

            RowLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(6)

                Label {
                    text: root.parseError ? "\u2715 " + root.parseError : "\u2713 Valid JSON"
                    font.pixelSize: Style.resize(11)
                    color: root.parseError ? "#FF7043" : "#00D1A9"
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Label {
                    text: root.parsedData ? typeof root.parsedData : ""
                    font.pixelSize: Style.resize(10)
                    color: Style.fontSecondaryColor
                    visible: !root.parseError
                }
            }
        }

        // Salida formateada: muestra el JSON parseado con indentacion visual.
        // Flickable permite scroll vertical para outputs largos.
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(6)

            Flickable {
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                clip: true
                contentHeight: outputLabel.height

                Label {
                    id: outputLabel
                    width: parent.width
                    text: root.parsedData ? root.renderValue(root.parsedData, "") : "Enter valid JSON above"
                    font.pixelSize: Style.resize(11)
                    font.family: "Consolas"
                    color: root.parsedData ? "#4FC3F7" : Style.inactiveColor
                    wrapMode: Text.WrapAnywhere
                }
            }
        }

        Button {
            text: "Load Sample"
            Layout.fillWidth: true
            font.pixelSize: Style.resize(11)
            onClicked: jsonInput.text = root.sampleJson
        }
    }
}
