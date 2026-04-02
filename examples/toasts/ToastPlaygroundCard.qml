pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(10)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(16)

        Label {
            text: "1. Playground"
            font.pixelSize: Style.resize(18)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Dispara toasts tipicos de producto: guardado, error de red, warning de cuota y accion tipo undo."
            wrapMode: Text.WordWrap
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        Rectangle {
            id: stage
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.resize(14)
            color: "#1D2330"
            border.color: "#303746"
            border.width: Style.resize(1)
            clip: true

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#243149" }
                GradientStop { position: 1.0; color: "#171B24" }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(18)
                spacing: Style.resize(12)

                RowLayout {
                    Layout.fillWidth: true

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: Style.resize(2)

                        Label {
                            text: "Deploy Preview"
                            font.pixelSize: Style.resize(18)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }

                        Label {
                            text: "Simula una tarjeta de producto donde el host vive dentro de una vista concreta."
                            wrapMode: Text.WordWrap
                            font.pixelSize: Style.resize(12)
                            color: Style.fontSecondaryColor
                            Layout.fillWidth: true
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: Style.resize(76)
                        Layout.preferredHeight: Style.resize(28)
                        radius: Style.resize(14)
                        color: Qt.rgba(0, 209, 169, 0.12)
                        border.color: Style.mainColor

                        Label {
                            anchors.centerIn: parent
                            text: "staging"
                            font.pixelSize: Style.resize(11)
                            color: Style.mainColor
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(1)
                    color: "#2A3240"
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.resize(72)
                    spacing: Style.resize(12)

                    Repeater {
                        model: [
                            { label: "Checks", value: "18/18" },
                            { label: "Perf", value: "96" },
                            { label: "Latency", value: "184ms" }
                        ]

                        Rectangle {
                            required property var modelData
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: Style.resize(12)
                            color: Qt.rgba(1, 1, 1, 0.05)

                            Column {
                                anchors.centerIn: parent
                                spacing: Style.resize(4)

                                Label {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: modelData.value
                                    font.pixelSize: Style.resize(17)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                }

                                Label {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: modelData.label
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
                id: playgroundHost
                anchors.fill: parent
                placement: "top-right"
                maxVisible: 4
                onActionInvoked: function(toast) {
                    if (toast.actionLabel === "Undo") {
                        playgroundHost.info("Deploy restored", "The archived preview was recovered.")
                    } else if (toast.actionLabel === "Retry") {
                        playgroundHost.success("Retry scheduled", "A fresh deployment started in the background.")
                    }
                }
            }
        }

        GridLayout {
            columns: 2
            columnSpacing: Style.resize(10)
            rowSpacing: Style.resize(10)
            Layout.fillWidth: true

            Button {
                text: "Success"
                Layout.fillWidth: true
                onClicked: playgroundHost.show({
                    kind: "success",
                    title: "Build published",
                    message: "The preview link is ready to share with the team."
                })
            }

            Button {
                text: "Error"
                Layout.fillWidth: true
                onClicked: playgroundHost.show({
                    kind: "error",
                    title: "Upload failed",
                    message: "The artifact server returned 502 for chunk 7.",
                    actionLabel: "Retry"
                })
            }

            Button {
                text: "Warning"
                Layout.fillWidth: true
                onClicked: playgroundHost.show({
                    kind: "warning",
                    title: "Quota almost full",
                    message: "You have used 92% of the monthly build minutes."
                })
            }

            Button {
                text: "Undo action"
                Layout.fillWidth: true
                onClicked: playgroundHost.show({
                    kind: "info",
                    title: "Preview archived",
                    message: "The temporary environment will disappear in 30 minutes.",
                    actionLabel: "Undo"
                })
            }
        }
    }
}
