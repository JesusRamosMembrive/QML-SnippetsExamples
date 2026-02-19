// =============================================================================
// CarouselCard.qml — Carrusel de tarjetas con SwipeView y datos de modelo
// =============================================================================
// Demuestra como usar SwipeView como carrusel de contenido rico, alimentado
// por un array JavaScript de objetos. Cada "tarjeta" del carrusel muestra
// un icono, titulo, descripcion y una linea decorativa de color.
//
// Este patron es muy comun en apps moviles: pantallas de onboarding,
// galerias de productos, o cualquier presentacion secuencial de contenido.
// A diferencia de BasicSwipeCard, aqui el contenido se genera dinamicamente
// desde un modelo de datos usando Repeater.
//
// Los indicadores de puntos en la parte inferior usan el color especifico
// de cada tarjeta (tomado del modelo) para el punto activo, creando una
// experiencia visual mas cohesiva.
//
// Aprendizaje clave: Repeater dentro de SwipeView + modelData para acceder
// a objetos JS. Los indicadores personalizados con color por tarjeta.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // -------------------------------------------------------------------------
    // Modelo de datos como array JS de objetos.
    // Usar un array en lugar de ListModel es mas conciso para datos estaticos.
    // Cada objeto tiene las propiedades que usa el delegate del Repeater.
    // Al ser readonly, se optimiza la memoria (no hay señales de cambio).
    // -------------------------------------------------------------------------
    readonly property var cards: [
        { title: "Buttons",    icon: "\u25A3", clr: "#00D1A9", desc: "Standard, icon and styled buttons" },
        { title: "Sliders",    icon: "\u2501", clr: "#FEA601", desc: "Range sliders, custom handles" },
        { title: "Animations", icon: "\u25B7", clr: "#4FC3F7", desc: "Transitions and behaviors" },
        { title: "Particles",  icon: "\u2726", clr: "#FF7043", desc: "Emitters, affectors, trails" },
        { title: "Canvas",     icon: "\u25CB", clr: "#AB47BC", desc: "2D drawing and paths" },
        { title: "Graphs",     icon: "\u2581\u2583\u2585\u2587", clr: "#EC407A", desc: "Charts and real-time plots" }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Card Carousel"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // ---------------------------------------------------------------------
        // SwipeView alimentado por Repeater con un array JS.
        // Cuando el model es un array JS, cada delegate recibe modelData
        // (el objeto completo) e index (la posicion). Esto permite acceder
        // a modelData.title, modelData.icon, etc.
        // ---------------------------------------------------------------------
        SwipeView {
            id: carouselSwipe
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Repeater {
                model: root.cards

                Rectangle {
                    required property var modelData
                    required property int index
                    color: Style.bgColor
                    radius: Style.resize(8)

                    // Contenido de cada tarjeta: icono, titulo, descripcion
                    // y una linea decorativa con el color de la tarjeta
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Style.resize(12)

                        Label {
                            text: modelData.icon
                            font.pixelSize: Style.resize(48)
                            color: modelData.clr
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: modelData.title
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.fontPrimaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Label {
                            text: modelData.desc
                            font.pixelSize: Style.resize(14)
                            color: Style.fontSecondaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }

                        // Linea decorativa coloreada como separador visual
                        Rectangle {
                            Layout.preferredWidth: Style.resize(50)
                            Layout.preferredHeight: Style.resize(4)
                            radius: Style.resize(2)
                            color: modelData.clr
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }

        // ---------------------------------------------------------------------
        // Indicadores de puntos con color dinamico por tarjeta.
        // A diferencia de un PageIndicator estandar donde el punto activo
        // siempre tiene el mismo color, aqui cada punto activo toma el color
        // de su tarjeta correspondiente (root.cards[index].clr). Esto crea
        // una retroalimentacion visual mas rica.
        // Los MouseArea permiten navegacion directa al hacer clic.
        // ---------------------------------------------------------------------
        Row {
            Layout.alignment: Qt.AlignHCenter
            spacing: Style.resize(8)

            Repeater {
                model: carouselSwipe.count
                Rectangle {
                    required property int index
                    width: Style.resize(10)
                    height: Style.resize(10)
                    radius: width / 2
                    color: index === carouselSwipe.currentIndex
                           ? root.cards[index].clr
                           : Style.inactiveColor
                    opacity: index === carouselSwipe.currentIndex ? 1.0 : 0.3

                    Behavior on color { ColorAnimation { duration: 200 } }
                    Behavior on opacity { NumberAnimation { duration: 200 } }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: carouselSwipe.currentIndex = index
                    }
                }
            }
        }
    }
}
