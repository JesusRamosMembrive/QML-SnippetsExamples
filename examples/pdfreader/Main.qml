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

    // PDF library model
    ListModel {
        id: libraryModel
        ListElement {
            title: "Qt 6 Book"
            author: "Johan Thelin et al."
            filename: "qt6book-with-frontpage.pdf"
        }
        ListElement {
            title: "C++ for Engineers"
            author: "Gary J. Bronson"
            filename: "bronson-c++.pdf"
        }
    }

    function pdfFilePath(filename) {
        return "file:///" + appDirPath + "/pdf_files/" + filename
    }

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

                    // Search
                    TextField {
                        id: searchField
                        placeholderText: "Search..."
                        font.pixelSize: Style.resize(13)
                        enabled: pdfDoc.status === PdfDocument.Ready
                        Layout.preferredWidth: Style.resize(180)
                        Layout.preferredHeight: Style.resize(36)
                        selectByMouse: true
                        onAccepted: {
                            pdfView.searchString = text
                            pdfView.searchForward()
                        }
                    }

                    Button {
                        text: "\u25B2"
                        enabled: searchField.text.length > 0
                        Layout.preferredWidth: Style.resize(30)
                        Layout.preferredHeight: Style.resize(36)
                        onClicked: {
                            pdfView.searchString = searchField.text
                            pdfView.searchBack()
                        }
                    }

                    Button {
                        text: "\u25BC"
                        enabled: searchField.text.length > 0
                        Layout.preferredWidth: Style.resize(30)
                        Layout.preferredHeight: Style.resize(36)
                        onClicked: {
                            pdfView.searchString = searchField.text
                            pdfView.searchForward()
                        }
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
                clip: true

                // PDF viewer
                PdfMultiPageView {
                    id: pdfView
                    anchors.fill: parent
                    document: pdfDoc
                    visible: pdfDoc.status === PdfDocument.Ready
                }

                // Empty state: drop zone + library
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

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: Style.resize(40)
                        spacing: Style.resize(30)

                        // Drop zone
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(200)
                            color: "transparent"
                            border.color: dropArea.hovering ? Style.mainColor : Style.inactiveColor
                            border.width: Style.resize(2)
                            radius: Style.resize(16)

                            Column {
                                anchors.centerIn: parent
                                spacing: Style.resize(12)

                                Label {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: "\uD83D\uDCC4"
                                    font.pixelSize: Style.resize(48)
                                    opacity: 0.6
                                }

                                Label {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: dropArea.hovering
                                          ? "Release to open PDF"
                                          : "Drop a PDF file here"
                                    font.pixelSize: Style.resize(20)
                                    font.bold: true
                                    color: dropArea.hovering ? Style.mainColor : Style.fontPrimaryColor
                                }

                                Label {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: "or click Open in the toolbar"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontSecondaryColor
                                }
                            }
                        }

                        // Library section
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: Style.resize(15)

                            Label {
                                text: "Library"
                                font.pixelSize: Style.resize(20)
                                font.bold: true
                                color: Style.mainColor
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(15)

                                Repeater {
                                    model: libraryModel

                                    Rectangle {
                                        Layout.preferredWidth: Style.resize(280)
                                        Layout.preferredHeight: Style.resize(120)
                                        color: bookMouse.hovered ? Style.surfaceColor : Style.cardColor
                                        radius: Style.resize(8)

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.margins: Style.resize(15)
                                            spacing: Style.resize(15)

                                            // Book icon
                                            Rectangle {
                                                Layout.preferredWidth: Style.resize(60)
                                                Layout.preferredHeight: Style.resize(80)
                                                color: Style.mainColor
                                                radius: Style.resize(4)
                                                opacity: 0.15

                                                Label {
                                                    anchors.centerIn: parent
                                                    text: "PDF"
                                                    font.pixelSize: Style.resize(16)
                                                    font.bold: true
                                                    color: Style.mainColor
                                                }
                                            }

                                            ColumnLayout {
                                                Layout.fillWidth: true
                                                spacing: Style.resize(4)

                                                Label {
                                                    text: model.title
                                                    font.pixelSize: Style.resize(15)
                                                    font.bold: true
                                                    color: Style.fontPrimaryColor
                                                    elide: Text.ElideRight
                                                    Layout.fillWidth: true
                                                }

                                                Label {
                                                    text: model.author
                                                    font.pixelSize: Style.resize(12)
                                                    color: Style.fontSecondaryColor
                                                    elide: Text.ElideRight
                                                    Layout.fillWidth: true
                                                }

                                                Item { Layout.fillHeight: true }

                                                Label {
                                                    text: "Click to open"
                                                    font.pixelSize: Style.resize(11)
                                                    color: Style.mainColor
                                                }
                                            }
                                        }

                                        HoverHandler {
                                            id: bookMouse
                                        }

                                        TapHandler {
                                            onTapped: pdfDoc.source = root.pdfFilePath(model.filename)
                                        }
                                    }
                                }

                                Item { Layout.fillWidth: true }
                            }

                            Item { Layout.fillHeight: true }
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
