import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Pdf
import QtQuick.Dialogs
import utils

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    PdfDocument {
        id: pdfDoc
    }

    FileDialog {
        id: fileDialog
        title: "Open PDF"
        nameFilters: ["PDF files (*.pdf)"]
        onAccepted: pdfDoc.source = selectedFile
    }

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // Toolbar
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(60)
                color: Style.cardColor

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Style.resize(20)
                    anchors.rightMargin: Style.resize(20)
                    spacing: Style.resize(12)

                    Label {
                        text: "PDF Reader"
                        font.pixelSize: Style.resize(24)
                        font.bold: true
                        color: Style.mainColor
                    }

                    Item { Layout.fillWidth: true }

                    // Zoom controls
                    Button {
                        text: "\u2212"
                        enabled: pdfDoc.status === PdfDocument.Ready
                        Layout.preferredWidth: Style.resize(36)
                        Layout.preferredHeight: Style.resize(36)
                        onClicked: {
                            pdfView.renderScale = Math.max(0.25, pdfView.renderScale - 0.25)
                        }
                    }

                    Label {
                        text: Math.round(pdfView.renderScale * 100) + "%"
                        font.pixelSize: Style.resize(13)
                        color: Style.fontPrimaryColor
                        Layout.preferredWidth: Style.resize(45)
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Button {
                        text: "+"
                        enabled: pdfDoc.status === PdfDocument.Ready
                        Layout.preferredWidth: Style.resize(36)
                        Layout.preferredHeight: Style.resize(36)
                        onClicked: {
                            pdfView.renderScale = Math.min(4.0, pdfView.renderScale + 0.25)
                        }
                    }

                    Button {
                        text: "Fit"
                        enabled: pdfDoc.status === PdfDocument.Ready
                        Layout.preferredHeight: Style.resize(36)
                        onClicked: pdfView.scaleToWidth(pdfView.width, pdfView.height)
                    }

                    // Separator
                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(30)
                        color: Style.inactiveColor
                        opacity: 0.3
                    }

                    // Page indicator
                    Label {
                        text: pdfDoc.status === PdfDocument.Ready
                              ? (pdfView.currentPage + 1) + " / " + pdfDoc.pageCount
                              : "- / -"
                        font.pixelSize: Style.resize(13)
                        color: Style.fontSecondaryColor
                    }

                    // Separator
                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(30)
                        color: Style.inactiveColor
                        opacity: 0.3
                    }

                    Button {
                        text: "Open"
                        Layout.preferredHeight: Style.resize(36)
                        onClicked: fileDialog.open()
                    }

                    // Filename
                    Label {
                        text: {
                            if (pdfDoc.status !== PdfDocument.Ready)
                                return ""
                            var path = pdfDoc.source.toString()
                            return path.substring(path.lastIndexOf("/") + 1)
                        }
                        font.pixelSize: Style.resize(12)
                        color: Style.fontSecondaryColor
                        elide: Text.ElideMiddle
                        Layout.maximumWidth: Style.resize(200)
                    }
                }
            }

            // Separator line
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Style.inactiveColor
                opacity: 0.3
            }

            // Content area
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // PDF viewer
                PdfMultiPageView {
                    id: pdfView
                    anchors.fill: parent
                    document: pdfDoc
                    visible: pdfDoc.status === PdfDocument.Ready
                }

                // Drop zone (empty state)
                DropArea {
                    id: dropArea
                    anchors.fill: parent
                    visible: pdfDoc.status !== PdfDocument.Ready

                    property bool hovering: false

                    onEntered: hovering = true
                    onExited: hovering = false
                    onDropped: (drop) => {
                        hovering = false
                        if (drop.hasUrls) {
                            for (var i = 0; i < drop.urls.length; i++) {
                                if (drop.urls[i].toString().toLowerCase().endsWith(".pdf")) {
                                    pdfDoc.source = drop.urls[i]
                                    return
                                }
                            }
                        }
                    }

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: Style.resize(40)
                        color: "transparent"
                        border.color: dropArea.hovering ? Style.mainColor : Style.inactiveColor
                        border.width: Style.resize(2)
                        radius: Style.resize(16)

                        property string dashPattern: dropArea.hovering ? "" : "dashed"

                        Column {
                            anchors.centerIn: parent
                            spacing: Style.resize(20)

                            // PDF icon
                            Label {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "\uD83D\uDCC4"
                                font.pixelSize: Style.resize(64)
                                opacity: 0.6
                            }

                            Label {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: dropArea.hovering
                                      ? "Release to open PDF"
                                      : "Drop a PDF file here"
                                font.pixelSize: Style.resize(22)
                                font.bold: true
                                color: dropArea.hovering ? Style.mainColor : Style.fontPrimaryColor
                            }

                            Label {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "or click Open in the toolbar"
                                font.pixelSize: Style.resize(14)
                                color: Style.fontSecondaryColor
                            }
                        }
                    }
                }

                // Drop overlay when viewing PDF (to allow replacing)
                DropArea {
                    anchors.fill: parent
                    visible: pdfDoc.status === PdfDocument.Ready

                    onDropped: (drop) => {
                        if (drop.hasUrls) {
                            for (var i = 0; i < drop.urls.length; i++) {
                                if (drop.urls[i].toString().toLowerCase().endsWith(".pdf")) {
                                    pdfDoc.source = drop.urls[i]
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
