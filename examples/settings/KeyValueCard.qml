pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import settingsmgr
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property var keysList: []

    SettingsManager {
        id: settings
        onKeysChanged: root.refreshKeys()
    }

    Component.onCompleted: refreshKeys()

    function refreshKeys() {
        var all = settings.allKeys()
        var arr = []
        for (var i = 0; i < all.length; i++) {
            arr.push({
                key: all[i],
                val: settings.getValue(all[i], "").toString()
            })
        }
        keysList = arr
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Key-Value Store"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Generic QSettings setValue / value / remove"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // Input
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            TextField {
                id: keyField
                Layout.fillWidth: true
                placeholderText: "Key (e.g. Custom/myKey)"
                font.pixelSize: Style.resize(11)
            }

            TextField {
                id: valueField
                Layout.fillWidth: true
                placeholderText: "Value"
                font.pixelSize: Style.resize(11)
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Button {
                text: "Save"
                Layout.fillWidth: true
                implicitHeight: Style.resize(32)
                enabled: keyField.text !== ""
                onClicked: {
                    settings.setValue(keyField.text, valueField.text)
                    root.refreshKeys()
                }
            }

            Button {
                text: "Load"
                Layout.fillWidth: true
                implicitHeight: Style.resize(32)
                enabled: keyField.text !== ""
                onClicked: {
                    valueField.text = settings.getValue(keyField.text, "").toString()
                }
            }

            Button {
                text: "Remove"
                Layout.fillWidth: true
                implicitHeight: Style.resize(32)
                enabled: keyField.text !== ""
                onClicked: {
                    settings.removeKey(keyField.text)
                    root.refreshKeys()
                }
            }
        }

        // Keys list
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.resize(6)
            color: Style.surfaceColor
            clip: true

            ListView {
                id: keyList
                anchors.fill: parent
                anchors.margins: Style.resize(6)
                model: root.keysList
                spacing: Style.resize(2)

                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    width: keyList.width
                    height: Style.resize(26)
                    radius: Style.resize(3)
                    color: index % 2 === 0 ? "#0AFFFFFF" : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(8)
                        anchors.rightMargin: Style.resize(8)
                        spacing: Style.resize(8)

                        Label {
                            text: modelData.key
                            font.pixelSize: Style.resize(10)
                            color: Style.mainColor
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }

                        Label {
                            text: modelData.val
                            font.pixelSize: Style.resize(10)
                            color: Style.fontSecondaryColor
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignRight
                        }
                    }
                }
            }

            Label {
                anchors.centerIn: parent
                text: "No settings stored yet"
                font.pixelSize: Style.resize(12)
                color: "#FFFFFF30"
                visible: root.keysList.length === 0
            }
        }

        Label {
            text: root.keysList.length + " keys stored"
            font.pixelSize: Style.resize(10)
            color: Style.fontSecondaryColor
        }
    }
}
