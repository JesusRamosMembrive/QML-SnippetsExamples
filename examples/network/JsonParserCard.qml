import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property var parsedData: null
    property string rawJson: ""
    property string parseError: ""

    readonly property string sampleJson: '{\n  "name": "Qt Framework",\n  "version": "6.10",\n  "languages": ["C++", "QML", "JS"],\n  "features": {\n    "cross_platform": true,\n    "modules": 42\n  }\n}'

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

        // Input area
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

        // Parse status
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

        // Formatted output
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
