import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property bool loading: false
    property string responseText: ""
    property int statusCode: 0
    property string errorMsg: ""

    function fetchData() {
        root.loading = true
        root.responseText = ""
        root.errorMsg = ""
        root.statusCode = 0

        var xhr = new XMLHttpRequest()
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
        xhr.onerror = function() {
            root.loading = false
            root.errorMsg = "Network error"
        }
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

        // URL display
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

        // Response area
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

            // Loading indicator
            BusyIndicator {
                anchors.centerIn: parent
                running: root.loading
                visible: root.loading
            }
        }

        // Status + button
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
