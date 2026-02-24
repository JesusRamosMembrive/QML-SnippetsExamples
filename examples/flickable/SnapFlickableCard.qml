// =============================================================================
// SnapFlickableCard.qml — Flickable con paginacion horizontal (snap)
// =============================================================================
// Implementa un carrusel de paginas horizontal con efecto "snap": al soltar
// el dedo, el contenido se ajusta automaticamente a la pagina mas cercana.
// Este patron es muy comun en onboardings, galerias y tutoriales de apps.
//
// Conceptos clave para el aprendiz:
//   - onMovementEnded: se dispara cuando la inercia del flick termina.
//     Aqui se calcula la pagina mas cercana con Math.round y se asigna
//     contentX para alinear perfectamente a esa pagina.
//   - Behavior on contentX: anima el ajuste final (snap) con OutQuad para
//     que el salto a la pagina sea suave, no abrupto.
//   - flickableDirection: HorizontalFlick restringe el scroll a solo
//     el eje horizontal, ignorando gestos verticales.
//   - currentPage: propiedad calculada que los indicadores (dots) usan
//     para saber que pagina esta activa en todo momento.
//   - ListModel: modelo declarativo con roles personalizados (title, icon,
//     clr) que el Repeater/delegate consume via required properties.
// =============================================================================
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "Snap Flickable"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Flick horizontally \u2014 snaps to pages"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            // ---------------------------------------------------------------
            // Flickable paginado: cada "pagina" tiene el mismo ancho que el
            // viewport. Al terminar el movimiento, contentX se redondea al
            // multiplo mas cercano del ancho para alinearse con una pagina.
            // La combinacion de onMovementEnded + Behavior on contentX
            // crea el efecto snap suave sin necesidad de SnapOneItem ni
            // snapMode de ListView.
            // ---------------------------------------------------------------
            Flickable {
                id: snapFlick
                anchors.fill: parent
                contentWidth: snapRow.width
                contentHeight: height
                flickableDirection: Flickable.HorizontalFlick
                boundsBehavior: Flickable.StopAtBounds

                // Calcula la pagina actual basandose en la posicion del scroll.
                // Math.round asegura que la transicion ocurre en el punto medio
                // entre dos paginas (50% visible de cada una).
                property int currentPage: Math.round(contentX / width)

                onMovementEnded: {
                    var page = Math.round(contentX / width)
                    contentX = page * width
                }
                // Esta animacion hace que el ajuste final sea suave.
                // Sin el Behavior, el snap seria un salto instantaneo.
                Behavior on contentX { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }

                Row {
                    id: snapRow
                    height: snapFlick.height

                    // ListModel con datos de cada pagina. Cada ListElement
                    // define los roles que el delegate consume como required
                    // properties, garantizando type safety en tiempo de compilacion.
                    Repeater {
                        model: ListModel {
                            ListElement { title: "Welcome";  icon: "\u2605"; clr: "#00D1A9" }
                            ListElement { title: "Features"; icon: "\u2699"; clr: "#FEA601" }
                            ListElement { title: "Gallery";  icon: "\u25A3"; clr: "#4FC3F7" }
                            ListElement { title: "Profile";  icon: "\u263A"; clr: "#AB47BC" }
                            ListElement { title: "Settings"; icon: "\u2692"; clr: "#FF7043" }
                        }

                        // Cada delegate tiene el ancho exacto del Flickable
                        // para que una pagina llene completamente el viewport
                        Rectangle {
                            id: snapDelegate
                            required property string title
                            required property string icon
                            required property string clr
                            required property int index
                            width: snapFlick.width
                            height: snapFlick.height
                            color: "transparent"

                            // Fondo semitransparente con borde del color de la pagina
                            // — da identidad visual a cada pagina sin ser invasivo
                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: Style.resize(10)
                                radius: Style.resize(12)
                                color: snapDelegate.clr
                                opacity: 0.15
                                border.color: snapDelegate.clr
                                border.width: Style.resize(2)
                            }

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: Style.resize(10)

                                Label {
                                    text: snapDelegate.icon
                                    font.pixelSize: Style.resize(48)
                                    color: snapDelegate.clr
                                    Layout.alignment: Qt.AlignHCenter
                                }
                                Label {
                                    text: snapDelegate.title
                                    font.pixelSize: Style.resize(20)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                    Layout.alignment: Qt.AlignHCenter
                                }
                                Label {
                                    text: "Page " + (snapDelegate.index + 1) + " of 5"
                                    font.pixelSize: Style.resize(13)
                                    color: Style.fontSecondaryColor
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }
                        }
                    }
                }
            }

            // ---------------------------------------------------------------
            // Indicadores de pagina (dots): patron clasico de navegacion.
            // Cada dot cambia de color segun si coincide con la pagina actual.
            // ColorAnimation da una transicion suave al cambiar de pagina.
            // ---------------------------------------------------------------
            Row {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Style.resize(8)
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Style.resize(8)

                Repeater {
                    model: 5

                    Rectangle {
                        required property int index
                        width: Style.resize(8)
                        height: Style.resize(8)
                        radius: Style.resize(4)
                        color: snapFlick.currentPage === index ? Style.mainColor : Style.inactiveColor

                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                }
            }
        }
    }
}
