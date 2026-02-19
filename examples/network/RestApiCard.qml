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

    readonly property var endpoints: [
        { name: "Posts",   url: "https://jsonplaceholder.typicode.com/posts?_limit=5",   icon: "\u2759" },
        { name: "Users",   url: "https://jsonplaceholder.typicode.com/users?_limit=5",   icon: "\u263A" },
        { name: "Todos",   url: "https://jsonplaceholder.typicode.com/todos?_limit=5",   icon: "\u2713" },
        { name: "Comments", url: "https://jsonplaceholder.typicode.com/comments?_limit=5", icon: "\u2709" }
    ]

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

        // Endpoint tabs
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

        // Results
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

                                // Completed badge for todos
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
