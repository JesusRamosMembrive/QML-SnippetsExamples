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
            text: "3. Imperative API"
            font.pixelSize: Style.resize(18)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "La gracia del patron es que cualquier zona de la app puede disparar un toast sin acoplarse a la UI del mensaje. En QML lo resolvemos con un host y funciones publicas."
            wrapMode: Text.WordWrap
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        GridLayout {
            columns: root.width > Style.resize(980) ? 2 : 1
            columnSpacing: Style.resize(20)
            rowSpacing: Style.resize(16)
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: Style.resize(14)
                color: "#141922"
                border.color: "#2C3444"
                border.width: Style.resize(1)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(18)
                    spacing: Style.resize(14)

                    Label {
                        text: "Pseudo API"
                        font.pixelSize: Style.resize(14)
                        font.bold: true
                        color: Style.fontPrimaryColor
                    }

                    Label {
                        text: "toast.success(\"Draft saved\")\n" +
                              "toast.error(\"Upload failed\")\n" +
                              "toast.show({ title: \"Sync queued\", actionLabel: \"Undo\" })\n" +
                              "toast.clearAll()"
                        font.family: "monospace"
                        wrapMode: Text.WordWrap
                        font.pixelSize: Style.resize(13)
                        color: "#D7E3FF"
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Style.resize(1)
                        color: "#2C3444"
                    }

                    Label {
                        text: "Consejos:"
                        font.pixelSize: Style.resize(13)
                        font.bold: true
                        color: Style.fontPrimaryColor
                    }

                    Label {
                        text: "- usa un solo host por pantalla o por shell\n- expone helpers semanticos: success, error, warning\n- limita la cola visible para evitar ruido visual"
                        wrapMode: Text.WordWrap
                        font.pixelSize: Style.resize(12)
                        color: Style.fontSecondaryColor
                        Layout.fillWidth: true
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }

            Rectangle {
                id: stage
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: Style.resize(14)
                color: "#181F2D"
                border.color: "#2F3748"
                border.width: Style.resize(1)
                clip: true

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(18)
                    spacing: Style.resize(12)

                    Label {
                        text: "Live demo"
                        font.pixelSize: Style.resize(16)
                        font.bold: true
                        color: Style.fontPrimaryColor
                    }

                    Label {
                        text: "Aqui el host queda abajo al centro, como en muchas apps de escritorio y dashboards."
                        wrapMode: Text.WordWrap
                        font.pixelSize: Style.resize(12)
                        color: Style.fontSecondaryColor
                        Layout.fillWidth: true
                    }

                    GridLayout {
                        columns: 2
                        columnSpacing: Style.resize(10)
                        rowSpacing: Style.resize(10)
                        Layout.fillWidth: true

                        Button {
                            text: "Draft saved"
                            Layout.fillWidth: true
                            onClicked: apiHost.success("Draft saved", "Autosave ran 2 seconds ago.")
                        }

                        Button {
                            text: "Upload failed"
                            Layout.fillWidth: true
                            onClicked: apiHost.error("Upload failed", "S3 rejected the final chunk.")
                        }

                        Button {
                            text: "Queued"
                            Layout.fillWidth: true
                            onClicked: apiHost.show({
                                kind: "info",
                                title: "Sync queued",
                                message: "Your changes will be retried when the device reconnects."
                            })
                        }

                        Button {
                            text: "Archive with Undo"
                            Layout.fillWidth: true
                            onClicked: apiHost.show({
                                kind: "warning",
                                title: "Report archived",
                                message: "The item moved to cold storage.",
                                actionLabel: "Undo"
                            })
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }

                ToastHost {
                    id: apiHost
                    anchors.fill: parent
                    placement: "bottom-center"
                    newestOnTop: false
                    onActionInvoked: function(toast) {
                        if (toast.actionLabel === "Undo")
                            apiHost.success("Archive reverted", "The report is back in the active list.")
                    }
                }
            }
        }
    }
}
