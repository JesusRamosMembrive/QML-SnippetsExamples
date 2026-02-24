// =============================================================================
// Main.qml — Lector de PDF integrado con biblioteca y drag-and-drop
// =============================================================================
// Pagina completa que funciona como un lector de PDF. Usa el modulo QtQuick.Pdf
// para renderizar documentos y QtQuick.Dialogs para el dialogo de apertura.
//
// Funcionalidades:
//   - Abrir PDFs desde una biblioteca predefinida, dialogo de archivos o
//     arrastrando un archivo (drag-and-drop).
//   - Controles de zoom (+, -, Fit), busqueda de texto dentro del PDF,
//     e indicador de pagina actual.
//   - Estado vacio con zona de drop y tarjetas de biblioteca.
//   - Drop overlay incluso mientras se visualiza un PDF (para reemplazarlo).
//
// Modulos Qt usados:
//   - QtQuick.Pdf: PdfDocument (modelo de datos del PDF) y PdfMultiPageView
//     (visor multipagina con scroll y zoom).
//   - QtQuick.Dialogs: FileDialog nativo del sistema operativo.
//
// Patrones importantes:
//   - PdfDocument como modelo + PdfMultiPageView como vista: separacion
//     modelo-vista del framework Qt Pdf.
//   - DropArea para drag-and-drop: detecta cuando un archivo se arrastra
//     sobre la ventana. drop.hasUrls + filtrado por extension .pdf.
//   - HoverHandler + TapHandler: alternativa moderna a MouseArea.
//     HoverHandler solo detecta hover, TapHandler solo detecta taps.
//     Mas composable que MouseArea cuando solo se necesita una funcion.
//   - appDirPath: propiedad expuesta desde C++ (main.cpp) que contiene
//     la ruta del ejecutable, usada para construir rutas a archivos PDF.
//   - Dos DropAreas: una para el estado vacio (con UI visual) y otra
//     invisible sobre el visor PDF (para permitir reemplazar el documento).
// =============================================================================

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Pdf
import QtQuick.Dialogs
import utils

Item {
    id: root

    // -- Patron de visibilidad animada estandar del proyecto
    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    // -- Modelo de biblioteca: PDFs predefinidos que se incluyen con la app.
    //    ListModel permite acceder a las propiedades con model.title, etc.
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

    // -- Helper para construir rutas file:// a los PDFs de la biblioteca.
    //    appDirPath es una propiedad de contexto expuesta desde C++ (main.cpp).
    function pdfFilePath(filename) {
        return "file:///" + appDirPath + "/pdf_files/" + filename
    }

    // -- PdfDocument: modelo que carga y parsea el PDF.
    //    El status cambia a PdfDocument.Ready cuando el documento esta listo.
    //    Se asigna source para cargar un archivo.
    PdfDocument {
        id: pdfDoc
    }

    // -- FileDialog nativo del SO para seleccionar un PDF.
    //    nameFilters restringe a archivos .pdf.
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

            // -- Barra de herramientas con controles de zoom, busqueda,
            //    indicador de pagina y boton de apertura.
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

                    // -- Controles de zoom: limitan el rango entre 25% y 400%.
                    //    Math.max/Math.min evitan valores fuera de rango.
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

                    // -- Separadores visuales entre grupos de controles
                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(30)
                        color: Style.inactiveColor
                        opacity: 0.3
                    }

                    // -- Busqueda de texto dentro del PDF.
                    //    onAccepted (Enter) inicia la busqueda hacia adelante.
                    //    Los botones de flecha permiten navegar entre resultados.
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

                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.preferredHeight: Style.resize(30)
                        color: Style.inactiveColor
                        opacity: 0.3
                    }

                    // -- Indicador de pagina: currentPage es 0-indexed, se suma 1
                    Label {
                        text: pdfDoc.status === PdfDocument.Ready
                              ? (pdfView.currentPage + 1) + " / " + pdfDoc.pageCount
                              : "- / -"
                        font.pixelSize: Style.resize(13)
                        color: Style.fontSecondaryColor
                    }

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

                    // -- Nombre del archivo actual, extraido de la URL con substring
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

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Style.inactiveColor
                opacity: 0.3
            }

            // -- Area de contenido: muestra el visor PDF o el estado vacio.
            //    clip: true evita que el PDF se dibuje fuera del area.
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                // -- PdfMultiPageView: visor de PDF multipagina con scroll.
                //    renderScale controla el zoom, searchString activa busqueda.
                //    Solo visible cuando hay un documento cargado.
                PdfMultiPageView {
                    id: pdfView
                    anchors.fill: parent
                    document: pdfDoc
                    visible: pdfDoc.status === PdfDocument.Ready
                }

                // -- Estado vacio con zona de drop y biblioteca.
                //    DropArea detecta archivos arrastrados sobre la ventana.
                //    La propiedad hovering controla el feedback visual.
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

                        // -- Zona de drop visual: rectangulo con borde punteado
                        //    que cambia de color al arrastrar un archivo encima.
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

                        // -- Seccion de biblioteca: tarjetas clickeables de PDFs
                        //    incluidos con la aplicacion.
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

                                    // -- Tarjeta de libro: icono + info + click to open.
                                    //    HoverHandler + TapHandler son la alternativa
                                    //    moderna a MouseArea cuando solo se necesita
                                    //    hover y tap por separado.
                                    Rectangle {
                                        id: bookDelegate
                                        Layout.preferredWidth: Style.resize(280)
                                        Layout.preferredHeight: Style.resize(120)
                                        color: bookMouse.hovered ? Style.surfaceColor : Style.cardColor
                                        radius: Style.resize(8)

                                        required property string title
                                        required property string author
                                        required property string filename

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.margins: Style.resize(15)
                                            spacing: Style.resize(15)

                                            // -- Icono de libro simulado con Rectangle
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
                                                    text: bookDelegate.title
                                                    font.pixelSize: Style.resize(15)
                                                    font.bold: true
                                                    color: Style.fontPrimaryColor
                                                    elide: Text.ElideRight
                                                    Layout.fillWidth: true
                                                }

                                                Label {
                                                    text: bookDelegate.author
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
                                            onTapped: pdfDoc.source = root.pdfFilePath(bookDelegate.filename)
                                        }
                                    }
                                }

                                Item { Layout.fillWidth: true }
                            }

                            Item { Layout.fillHeight: true }
                        }
                    }
                }

                // -- DropArea secundaria: invisible, activa cuando ya hay un PDF
                //    abierto. Permite reemplazar el documento arrastrando otro PDF.
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
