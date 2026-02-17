import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root

    Label {
        text: "Staggered List Entrance"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    Item {
        id: staggerSection
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(320)

        property bool animating: false
        property int animStep: -1

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor
            radius: Style.resize(8)
        }

        Timer {
            id: staggerTimer
            interval: 80
            repeat: true
            running: false
            onTriggered: {
                staggerSection.animStep++
                if (staggerSection.animStep >= staggerRepeater.count) {
                    staggerTimer.stop()
                    staggerSection.animating = false
                }
            }
        }

        Column {
            anchors.fill: parent
            anchors.margins: Style.resize(10)
            spacing: Style.resize(6)

            Repeater {
                id: staggerRepeater
                model: [
                    { icon: "\u2709", title: "New message from Alex", sub: "Hey, are you free tomorrow?", clr: "#5B8DEF" },
                    { icon: "\uD83D\uDCC5", title: "Meeting at 3 PM", sub: "Conference Room B \u2014 Project Review", clr: "#00D1A9" },
                    { icon: "\u26A1", title: "Build succeeded", sub: "All 47 tests passed", clr: "#34C759" },
                    { icon: "\uD83D\uDD14", title: "System update available", sub: "Version 2.4.1 \u2014 Security patch", clr: "#FF9500" },
                    { icon: "\u2764", title: "Your post was liked", sub: "12 people liked your photo", clr: "#FF3B30" },
                    { icon: "\uD83D\uDCE6", title: "Package delivered", sub: "Your order #4821 has arrived", clr: "#AF52DE" },
                    { icon: "\uD83C\uDFAF", title: "Goal reached!", sub: "You completed 100% of daily tasks", clr: "#FEA601" }
                ]

                delegate: Rectangle {
                    id: staggerItem
                    required property var modelData
                    required property int index

                    width: parent.width
                    height: Style.resize(38)
                    radius: Style.resize(8)
                    color: staggerItemMa.containsMouse
                           ? Qt.rgba(1, 1, 1, 0.06) : "transparent"

                    property bool shown: staggerItem.index <= staggerSection.animStep

                    opacity: shown ? 1 : 0
                    x: shown ? 0 : Style.resize(60)

                    Behavior on opacity {
                        NumberAnimation { duration: 350; easing.type: Easing.OutCubic }
                    }
                    Behavior on x {
                        NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
                    }

                    MouseArea {
                        id: staggerItemMa
                        anchors.fill: parent
                        hoverEnabled: true
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Style.resize(12)
                        anchors.rightMargin: Style.resize(12)
                        spacing: Style.resize(12)

                        Rectangle {
                            Layout.preferredWidth: Style.resize(28)
                            Layout.preferredHeight: Style.resize(28)
                            radius: Style.resize(6)
                            color: Qt.rgba(
                                Qt.color(staggerItem.modelData.clr).r,
                                Qt.color(staggerItem.modelData.clr).g,
                                Qt.color(staggerItem.modelData.clr).b, 0.15)

                            Label {
                                anchors.centerIn: parent
                                text: staggerItem.modelData.icon
                                font.pixelSize: Style.resize(14)
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(1)

                            Label {
                                text: staggerItem.modelData.title
                                font.pixelSize: Style.resize(13)
                                font.bold: true
                                color: Style.fontPrimaryColor
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            Label {
                                text: staggerItem.modelData.sub
                                font.pixelSize: Style.resize(11)
                                color: Style.fontSecondaryColor
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: Style.resize(8)
                            Layout.preferredHeight: Style.resize(8)
                            radius: width / 2
                            color: staggerItem.modelData.clr
                        }
                    }
                }
            }
        }

        // Play button
        Button {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: Style.resize(8)
            text: staggerSection.animating ? "Animating..." : "\u25B6 Play Entrance"
            flat: true
            enabled: !staggerSection.animating
            onClicked: {
                staggerSection.animStep = -1
                staggerSection.animating = true
                staggerTimer.start()
            }
        }
    }
}
