// =============================================================================
// ChapterPanel.qml — Panel lateral de navegacion por capitulos y temas
// =============================================================================
// Panel izquierdo del visor de teoria C++. Muestra una lista jerarquica de
// capitulos (expandibles) con sus temas. Incluye busqueda en tiempo real
// que filtra temas y auto-expande los capitulos con coincidencias.
//
// Arquitectura:
//   - Recibe `chapters` (array de objetos {name, displayName, topics[]})
//     desde el TheoryParser de C++.
//   - Emite signal `topicSelected` cuando el usuario hace clic en un tema.
//   - No carga contenido: solo comunica la seleccion al padre (Main.qml).
//
// Patrones importantes:
//   - ListView con delegate complejo: cada delegate es un Column que contiene
//     un header de capitulo + un Repeater de temas. Esto permite el patron
//     de "accordion" (expandir/colapsar) sin TreeView.
//   - Filtrado reactivo con computed property (filteredTopics): se recalcula
//     automaticamente cuando searchText o modelData.topics cambian.
//   - Placeholder manual con Text: TextInput no tiene placeholderText nativo,
//     asi que se usa un Text superpuesto que se oculta cuando hay texto.
//   - Seleccion visual con Qt.rgba(): extrae componentes RGB del color
//     del tema y aplica transparencia para el highlight de seleccion.
// =============================================================================
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils 1.0

Item {
    id: root

    property var chapters: []
    property string searchText: ""
    property string selectedChapter: ""
    property string selectedTopic: ""

    // -- Signal que comunica la seleccion al componente padre.
    //    Incluye tanto el nombre interno (para cargar archivos) como el
    //    nombre de display (para mostrar al usuario en breadcrumbs).
    signal topicSelected(string chapterName, string chapterDisplay, string topicFile, string topicDisplay)

    Rectangle {
        anchors.fill: parent
        color: "#2C3E50"

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // -- Cabecera del panel con titulo fijo
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(50)
                color: "#1A252F"

                Label {
                    anchors.centerIn: parent
                    text: "Teoria C++"
                    font.pixelSize: Style.resize(18)
                    font.bold: true
                    color: Style.mainColor
                }
            }

            // -- Campo de busqueda manual: TextInput dentro de Rectangle.
            //    Se usa TextInput en vez de TextField para tener control total
            //    del aspecto visual. El placeholder se implementa con un Text
            //    superpuesto que se oculta cuando hay contenido.
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(40)
                Layout.margins: Style.resize(8)
                color: "#3D5166"
                radius: Style.resize(4)

                TextInput {
                    id: searchInput
                    anchors.fill: parent
                    anchors.margins: Style.resize(8)
                    color: "#FFFFFF"
                    font.pixelSize: Style.resize(13)
                    clip: true
                    onTextEdited: root.searchText = text

                    // -- Placeholder manual: visible solo cuando no hay texto
                    Text {
                        anchors.fill: parent
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Buscar tema..."
                        color: "#8899AA"
                        font.pixelSize: Style.resize(13)
                        visible: !searchInput.text
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            // -- Lista de capitulos con scroll
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ListView {
                    id: chaptersListView
                    model: root.chapters
                    spacing: Style.resize(2)

                    // -- Delegate de capitulo: Column con header + lista de temas.
                    //    Cada capitulo es un "accordion" expandible.
                    delegate: Column {
                        id: chapterDelegate
                        width: chaptersListView.width

                        required property var modelData
                        required property int index

                        property bool expanded: false

                        // -- Propiedad computada que filtra los temas segun searchText.
                        //    Se recalcula automaticamente cuando cambia la busqueda.
                        //    Retorna todos los temas si no hay busqueda activa.
                        property var filteredTopics: {
                            let topics = modelData.topics
                            if (root.searchText === "")
                                return topics
                            let result = []
                            let search = root.searchText.toLowerCase()
                            for (let i = 0; i < topics.length; i++) {
                                if (topics[i].displayName.toLowerCase().indexOf(search) >= 0)
                                    result.push(topics[i])
                            }
                            return result
                        }

                        // -- Auto-expand: cuando la busqueda encuentra temas en este
                        //    capitulo, se expande automaticamente para mostrarlos.
                        onFilteredTopicsChanged: {
                            if (root.searchText !== "" && filteredTopics.length > 0)
                                expanded = true
                        }

                        // -- Header del capitulo: flecha de expand + nombre + contador
                        Rectangle {
                            width: parent.width
                            height: Style.resize(36)
                            color: chapterMouse.containsMouse ? "#3D5166" : "transparent"

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Style.resize(12)
                                anchors.rightMargin: Style.resize(12)
                                spacing: Style.resize(8)

                                Label {
                                    text: chapterDelegate.expanded ? "\u25BC" : "\u25B6"
                                    font.pixelSize: Style.resize(10)
                                    color: Style.mainColor
                                }

                                Label {
                                    text: chapterDelegate.modelData.displayName
                                    font.pixelSize: Style.resize(13)
                                    font.bold: true
                                    color: "#FFFFFF"
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                // -- Contador de temas visibles (filtrados)
                                Label {
                                    text: chapterDelegate.filteredTopics.length
                                    font.pixelSize: Style.resize(11)
                                    color: "#8899AA"
                                }
                            }

                            MouseArea {
                                id: chapterMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: chapterDelegate.expanded = !chapterDelegate.expanded
                            }
                        }

                        // -- Lista de temas dentro del capitulo (solo visible si expanded).
                        //    Usa Repeater en vez de ListView porque la cantidad de temas
                        //    por capitulo es pequena y no necesita virtualizacion.
                        Column {
                            width: parent.width
                            visible: chapterDelegate.expanded
                            Repeater {
                                model: chapterDelegate.filteredTopics

                                Rectangle {
                                    required property var modelData
                                    required property int index

                                    width: chaptersListView.width
                                    height: Style.resize(30)

                                    // -- Color de seleccion: mainColor con 20% de opacidad
                                    //    para el tema seleccionado, hover para los demas.
                                    color: {
                                        if (root.selectedChapter === chapterDelegate.modelData.name
                                            && root.selectedTopic === modelData.fileName)
                                            return Qt.rgba(Style.mainColor.r, Style.mainColor.g, Style.mainColor.b, 0.2)
                                        return topicMouse.containsMouse ? "#3D5166" : "transparent"
                                    }

                                    Label {
                                        anchors.left: parent.left
                                        anchors.leftMargin: Style.resize(32)
                                        anchors.right: parent.right
                                        anchors.rightMargin: Style.resize(8)
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData.displayName
                                        font.pixelSize: Style.resize(12)
                                        color: {
                                            if (root.selectedChapter === chapterDelegate.modelData.name
                                                && root.selectedTopic === modelData.fileName)
                                                return Style.mainColor
                                            return "#CCDDEE"
                                        }
                                        elide: Text.ElideRight
                                    }

                                    // -- Al hacer clic: actualizar la seleccion y emitir signal
                                    MouseArea {
                                        id: topicMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            root.selectedChapter = chapterDelegate.modelData.name
                                            root.selectedTopic = modelData.fileName
                                            root.topicSelected(
                                                chapterDelegate.modelData.name,
                                                chapterDelegate.modelData.displayName,
                                                modelData.fileName,
                                                modelData.displayName
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
