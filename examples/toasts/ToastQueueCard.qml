pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(10)

    readonly property var placementOptions: [
        { label: "Top right", value: "top-right" },
        { label: "Top center", value: "top-center" },
        { label: "Bottom right", value: "bottom-right" },
        { label: "Bottom center", value: "bottom-center" }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(16)

        Label {
            text: "2. Queue and Placement"
            font.pixelSize: Style.resize(18)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Cambia la posicion del stack y el limite visible. Cuando hay overflow, el host descarta el mas antiguo como hacen muchas librerias web."
            wrapMode: Text.WordWrap
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(12)

            ComboBox {
                id: placementCombo
                Layout.fillWidth: true
                model: root.placementOptions
                textRole: "label"
            }

            SpinBox {
                id: limitSpin
                from: 2
                to: 6
                value: 3
                editable: false
            }
        }

        Rectangle {
            id: stage
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.resize(14)
            color: "#171D28"
            border.color: "#31394B"
            border.width: Style.resize(1)
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(18)
                spacing: Style.resize(10)

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        text: "Visible now: " + queueHost.toasts.length + " / " + queueHost.maxVisible
                        font.pixelSize: Style.resize(12)
                        color: Style.fontSecondaryColor
                        Layout.fillWidth: true
                    }

                    Label {
                        text: queueHost.placement
                        font.pixelSize: Style.resize(12)
                        color: Style.mainColor
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(1)
                    color: "#293243"
                }

                GridLayout {
                    columns: 3
                    columnSpacing: Style.resize(10)
                    rowSpacing: Style.resize(10)
                    Layout.fillWidth: true

                    Repeater {
                        model: [
                            { name: "Queue A", state: "idle" },
                            { name: "Queue B", state: "syncing" },
                            { name: "Queue C", state: "blocked" },
                            { name: "Queue D", state: "idle" },
                            { name: "Queue E", state: "syncing" },
                            { name: "Queue F", state: "idle" }
                        ]

                        Rectangle {
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(64)
                            radius: Style.resize(12)
                            color: Qt.rgba(1, 1, 1, 0.05)

                            Column {
                                anchors.centerIn: parent
                                spacing: Style.resize(4)

                                Label {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: modelData.name
                                    font.pixelSize: Style.resize(12)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }

                                Label {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: modelData.state
                                    font.pixelSize: Style.resize(11)
                                    color: Style.fontSecondaryColor
                                }
                            }
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                }
            }

            ToastHost {
                id: queueHost
                anchors.fill: parent
                placement: root.placementOptions[placementCombo.currentIndex].value
                maxVisible: limitSpin.value
                newestOnTop: queueHost.placement.indexOf("bottom") !== 0
                onActionInvoked: function(toast) {
                    if (toast.actionLabel === "Resume") {
                        queueHost.success("Queue resumed", "Workers are processing events again.")
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            Button {
                text: "Burst 5"
                Layout.fillWidth: true
                onClicked: {
                    var names = ["Orders", "Invoices", "Users", "Billing", "Search"]
                    for (var i = 0; i < names.length; ++i) {
                        queueHost.show({
                            kind: (i % 2 === 0) ? "info" : "success",
                            title: names[i] + " synced",
                            message: "Batch #" + (104 + i) + " finished correctly."
                        })
                    }
                }
            }

            Button {
                text: "Sticky"
                Layout.fillWidth: true
                onClicked: queueHost.show({
                    kind: "warning",
                    title: "Pipeline paused",
                    message: "A worker is waiting for manual approval.",
                    sticky: true,
                    actionLabel: "Resume"
                })
            }

            Button {
                text: "Clear"
                Layout.fillWidth: true
                onClicked: queueHost.clearAll()
            }
        }
    }
}
