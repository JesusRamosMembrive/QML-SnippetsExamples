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

    property var groupsList: []

    SettingsManager {
        id: settings
        onKeysChanged: root.refreshGroups()
    }

    Component.onCompleted: refreshGroups()

    function refreshGroups() {
        var groups = settings.childGroups()
        var arr = []
        for (var i = 0; i < groups.length; i++) {
            var keys = settings.keysInGroup(groups[i])
            var items = []
            for (var j = 0; j < keys.length; j++) {
                var fullKey = groups[i] + "/" + keys[j]
                items.push({
                    key: keys[j],
                    val: settings.getValue(fullKey, "").toString()
                })
            }
            arr.push({ group: groups[i], items: items })
        }
        groupsList = arr
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Settings Inspector"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Browse groups, keys, and storage location"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // Storage path
        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(32)
            radius: Style.resize(4)
            color: Style.surfaceColor

            Label {
                anchors.fill: parent
                anchors.margins: Style.resize(6)
                text: settings.settingsPath()
                font.pixelSize: Style.resize(9)
                color: Style.fontSecondaryColor
                elide: Text.ElideMiddle
                verticalAlignment: Text.AlignVCenter
            }
        }

        // Groups browser
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.resize(6)
            color: Style.surfaceColor
            clip: true

            Flickable {
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                contentHeight: groupsCol.implicitHeight
                clip: true

                ColumnLayout {
                    id: groupsCol
                    width: parent.width
                    spacing: Style.resize(8)

                    Repeater {
                        model: root.groupsList

                        ColumnLayout {
                            required property var modelData
                            required property int index
                            Layout.fillWidth: true
                            spacing: Style.resize(2)

                            // Group header
                            Label {
                                text: "[" + modelData.group + "]"
                                font.pixelSize: Style.resize(12)
                                font.bold: true
                                color: "#4FC3F7"
                            }

                            // Keys in group
                            Repeater {
                                model: modelData.items

                                RowLayout {
                                    required property var modelData
                                    Layout.fillWidth: true
                                    Layout.leftMargin: Style.resize(12)
                                    spacing: Style.resize(8)

                                    Label {
                                        text: modelData.key + ":"
                                        font.pixelSize: Style.resize(10)
                                        color: Style.fontSecondaryColor
                                        Layout.preferredWidth: Style.resize(90)
                                    }

                                    Label {
                                        text: modelData.val
                                        font.pixelSize: Style.resize(10)
                                        color: Style.mainColor
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }
                    }

                    Label {
                        text: "No settings groups found"
                        font.pixelSize: Style.resize(12)
                        color: "#FFFFFF30"
                        visible: root.groupsList.length === 0
                    }
                }
            }
        }

        // Actions
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: "Refresh"
                implicitHeight: Style.resize(32)
                onClicked: root.refreshGroups()
            }

            Item { Layout.fillWidth: true }

            Label {
                text: settings.allKeys().length + " total keys"
                font.pixelSize: Style.resize(10)
                color: Style.fontSecondaryColor
            }

            Button {
                text: "Clear All Settings"
                implicitHeight: Style.resize(32)
                onClicked: {
                    settings.clearAll()
                    root.refreshGroups()
                }
            }
        }
    }
}
