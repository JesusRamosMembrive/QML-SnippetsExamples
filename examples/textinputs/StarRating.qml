// =============================================================================
// StarRating.qml — Control de calificacion con estrellas (1-5)
// =============================================================================
// Implementa un selector de calificacion con estrellas, un patron de UI
// ubicuo en tiendas de apps, reviews de productos, etc. Demuestra como
// crear un control interactivo rico usando solo Labels + MouseAreas.
//
// Patrones educativos:
//   - Doble estado (rating + hoverRating): `rating` es la calificacion
//     confirmada (persiste), `hoverRating` es la calificacion temporal al
//     pasar el mouse (se resetea a -1 al salir). La propiedad `filled`
//     prioriza hoverRating si es >= 0, permitiendo el efecto de "preview"
//     antes de hacer clic.
//   - Caracteres Unicode como iconos: \u2605 (estrella llena) y \u2606
//     (estrella vacia) evitan la necesidad de imagenes o fuentes de iconos.
//     Es una tecnica rapida para prototipos, aunque en produccion se
//     prefieren iconos SVG por consistencia visual entre plataformas.
//   - Hover interactivo: scale se agranda con Behavior al pasar el cursor,
//     dando feedback inmediato. `cursorShape: Qt.PointingHandCursor`
//     refuerza la affordance de clickeabilidad.
//   - Repeater con comparacion de indices: cada estrella compara su `index`
//     con el rating/hoverRating actual para decidir si esta llena o vacia.
//     Es un patron comun en controles discretos (rating, stepper, etc.).
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Star Rating"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    Item {
        id: ratingItem
        Layout.fillWidth: true
        Layout.preferredHeight: Style.resize(50)

        // rating: valor confirmado por el usuario (clic)
        // hoverRating: valor temporal de preview (hover), -1 cuando no hay hover
        property int rating: 3
        property int hoverRating: -1

        RowLayout {
            anchors.centerIn: parent
            spacing: Style.resize(8)

            Repeater {
                model: 5

                Label {
                    id: starLabel
                    required property int index

                    // `filled` determina si la estrella se muestra llena o vacia.
                    // Si hay un hoverRating activo (>= 0), se usa ese; si no,
                    // se usa el rating confirmado. Asi el usuario ve una
                    // "preview" al pasar el cursor antes de hacer clic.
                    property bool filled: {
                        var r = ratingItem.hoverRating >= 0
                                ? ratingItem.hoverRating : ratingItem.rating
                        return index < r
                    }

                    text: filled ? "\u2605" : "\u2606"
                    font.pixelSize: Style.resize(36)
                    color: filled ? "#FFD54F" : Style.inactiveColor

                    // Animaciones de feedback: escala al hover, color al cambiar estado
                    scale: starMa.containsMouse ? 1.2 : 1.0
                    Behavior on scale { NumberAnimation { duration: 100 } }
                    Behavior on color { ColorAnimation { duration: 150 } }

                    MouseArea {
                        id: starMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: ratingItem.rating = starLabel.index + 1
                        onEntered: ratingItem.hoverRating = starLabel.index + 1
                        onExited: ratingItem.hoverRating = -1
                    }
                }
            }

            // Indicador numerico de la calificacion
            Label {
                text: ratingItem.rating + " / 5"
                font.pixelSize: Style.resize(16)
                font.bold: true
                color: "#FFD54F"
                Layout.leftMargin: Style.resize(15)
            }
        }
    }
}
