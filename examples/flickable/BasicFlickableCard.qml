// =============================================================================
// BasicFlickableCard.qml — Scroll vertical basico con Flickable
// =============================================================================
// Demuestra el uso mas simple de Flickable: una lista vertical de elementos
// que exceden el area visible, permitiendo al usuario desplazarse con el dedo
// o la rueda del raton.
//
// Conceptos clave para el aprendiz:
//   - contentWidth/contentHeight: le dicen al Flickable el tamano total del
//     contenido, no solo lo que se ve. El scroll aparece automaticamente
//     cuando el contenido es mayor que el viewport.
//   - boundsBehavior: StopAtBounds evita el efecto "rebote" al llegar
//     al final del contenido.
//   - visibleArea: propiedad de solo lectura que expone yPosition y
//     heightRatio, utiles para crear indicadores de scroll personalizados.
//   - Qt.hsla(): genera colores distribuyendo el hue uniformemente,
//     creando un efecto arcoiris en las filas.
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

        // Encabezado de la tarjeta: titulo y subtitulo descriptivo
        Label {
            text: "Basic Flickable"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Scroll to explore the content"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        // Item contenedor con clip: true para recortar el contenido que
        // sobresale del area visible. Sin clip, los elementos del Flickable
        // se dibujan fuera de los bordes de la tarjeta.
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            // ---------------------------------------------------------------
            // Flickable basico: el contenido es un Column con 20 filas.
            // contentHeight se enlaza al alto real del Column, asi el
            // Flickable sabe automaticamente cuanto scroll hay disponible.
            // ---------------------------------------------------------------
            Flickable {
                id: basicFlick
                anchors.fill: parent
                contentWidth: contentCol.width
                contentHeight: contentCol.height
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: contentCol
                    width: basicFlick.width
                    spacing: Style.resize(6)

                    Repeater {
                        model: 20

                        // Cada fila tiene un color unico generado con Qt.hsla.
                        // Se divide index/20 para recorrer todo el espectro de
                        // hue (0.0 a 1.0) de forma uniforme.
                        Rectangle {
                            required property int index
                            width: contentCol.width
                            height: Style.resize(40)
                            radius: Style.resize(4)
                            color: Qt.hsla(index / 20.0, 0.5, 0.4, 1.0)

                            Label {
                                anchors.centerIn: parent
                                text: "Row " + (index + 1)
                                font.pixelSize: Style.resize(13)
                                font.bold: true
                                color: "#FFFFFF"
                            }
                        }
                    }
                }
            }

            // ---------------------------------------------------------------
            // Indicador de scroll personalizado. En lugar de usar ScrollBar
            // nativo, se crea un Rectangle cuya posicion (y) y tamano (height)
            // se calculan a partir de visibleArea:
            //   - yPosition: posicion relativa del viewport (0.0 a 1.0)
            //   - heightRatio: proporcion del contenido visible (0.0 a 1.0)
            // La opacidad cambia cuando el Flickable esta en movimiento
            // para dar feedback visual al usuario.
            // ---------------------------------------------------------------
            Rectangle {
                anchors.right: parent.right
                y: basicFlick.visibleArea.yPosition * parent.height
                width: Style.resize(4)
                height: basicFlick.visibleArea.heightRatio * parent.height
                radius: Style.resize(2)
                color: Style.mainColor
                opacity: basicFlick.moving ? 0.8 : 0.3

                Behavior on opacity { NumberAnimation { duration: 200 } }
            }
        }

        // Muestra la posicion actual vs. el maximo para que el aprendiz
        // entienda la relacion entre contentY y el rango de scroll
        Label {
            text: "Position: " + (basicFlick.contentY).toFixed(0) + " / " + (basicFlick.contentHeight - basicFlick.height).toFixed(0)
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
