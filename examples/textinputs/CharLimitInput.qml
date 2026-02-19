// =============================================================================
// CharLimitInput.qml — Campo de texto con limite de caracteres y anillo de progreso
// =============================================================================
// Implementa un campo de entrada estilo Twitter/X con limite de 140 caracteres
// y un indicador visual circular (progress ring) que muestra cuanto espacio
// queda. El anillo cambia de color conforme se acerca al limite.
//
// Patrones educativos:
//   - Canvas para graficos personalizados: QML Canvas funciona exactamente
//     como HTML5 Canvas (misma API 2D context). Se usa aqui para dibujar
//     un arco de progreso que seria imposible con Rectangles simples.
//     `onProgChanged: requestPaint()` fuerza el repintado cada vez que
//     cambia el progreso — Canvas NO es reactivo automaticamente como
//     otros elementos de QML.
//   - Progreso normalizado (0.0 a 1.0): `text.length / 140` normaliza
//     el conteo a un rango de 0 a 1, facilitando los calculos del arco
//     y los umbrales de color.
//   - Umbrales de color progresivos: verde (mainColor) hasta 70%, naranja
//     de 70% a 90%, rojo despues de 90%. Tanto el borde del campo como
//     el anillo usan la misma logica de color, manteniendo consistencia.
//   - Geometria del arco: startAngle = -PI/2 para que el arco empiece
//     desde las 12 en punto (arriba) en vez de las 3 (derecha), que es
//     el angulo 0 por defecto en Canvas. El arco final es
//     startAngle + 2*PI*progreso.
//   - `maximumLength: 140` en TextInput hace que Qt rechace caracteres
//     mas alla del limite, eliminando la necesidad de validacion manual.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.resize(8)

    Label {
        text: "Character Limit with Progress Ring"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
        Layout.topMargin: Style.resize(5)
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(15)

        // -----------------------------------------------------------------
        // Campo de texto con borde reactivo: el color del borde cambia
        // segun el foco Y el nivel de progreso (verde/naranja/rojo).
        // La propiedad `progress` se calcula como ratio del largo actual
        // sobre el maximo (140). `progressColor` usa umbrales escalonados.
        // -----------------------------------------------------------------
        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(46)
            radius: Style.resize(8)
            color: Style.surfaceColor
            border.color: limitInput.activeFocus ? progressColor : "#3A3D45"
            border.width: limitInput.activeFocus ? 2 : 1

            property real progress: limitInput.text.length / 140
            property string progressColor: {
                if (progress > 0.9) return "#EF5350"
                if (progress > 0.7) return "#FFA726"
                return Style.mainColor
            }

            Behavior on border.color { ColorAnimation { duration: 200 } }

            TextInput {
                id: limitInput
                anchors.fill: parent
                anchors.margins: Style.resize(12)
                font.pixelSize: Style.resize(14)
                color: Style.fontPrimaryColor
                clip: true
                maximumLength: 140
                selectByMouse: true
                selectionColor: Style.mainColor
                verticalAlignment: TextInput.AlignVCenter

                // Placeholder manual (patron recurrente en controles personalizados)
                Text {
                    anchors.fill: parent
                    text: "Tweet something (140 chars max)..."
                    font: parent.font
                    color: Style.inactiveColor
                    visible: !parent.text && !parent.activeFocus
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        // -----------------------------------------------------------------
        // Anillo de progreso: dibujado con Canvas. A diferencia de los
        // elementos declarativos de QML, Canvas requiere repintado manual
        // (requestPaint). Las propiedades `prog` y `rColor` existen como
        // propiedades del Canvas para que onProgChanged pueda llamar a
        // requestPaint() — si usaramos directamente parent.progress, el
        // Canvas no sabria cuando repintarse.
        // -----------------------------------------------------------------
        Item {
            width: Style.resize(44)
            height: Style.resize(44)

            property real progress: limitInput.text.length / 140
            property string ringColor: {
                if (progress > 0.9) return "#EF5350"
                if (progress > 0.7) return "#FFA726"
                return Style.mainColor
            }

            Canvas {
                id: progressRing
                onAvailableChanged: if (available) requestPaint()
                anchors.fill: parent

                property real prog: parent.progress
                property string rColor: parent.ringColor

                onProgChanged: requestPaint()

                onPaint: {
                    var ctx = getContext("2d")
                    var w = width
                    var h = height
                    var cx = w / 2
                    var cy = h / 2
                    var r = Math.min(cx, cy) - 4
                    var startAngle = -Math.PI / 2

                    ctx.clearRect(0, 0, w, h)

                    // Anillo de fondo (siempre visible, color oscuro)
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                    ctx.strokeStyle = "#3A3D45"
                    ctx.lineWidth = 3
                    ctx.stroke()

                    // Arco de progreso: desde -PI/2 (12 en punto) hasta
                    // -PI/2 + 2*PI*progreso. Math.min(prog, 1) evita
                    // que el arco exceda un circulo completo.
                    if (prog > 0) {
                        ctx.beginPath()
                        ctx.arc(cx, cy, r, startAngle,
                                startAngle + 2 * Math.PI * Math.min(prog, 1))
                        ctx.strokeStyle = rColor
                        ctx.lineWidth = 3
                        ctx.lineCap = "round"
                        ctx.stroke()
                    }
                }
            }

            // Contador de caracteres restantes, centrado en el anillo
            Label {
                anchors.centerIn: parent
                text: 140 - limitInput.text.length
                font.pixelSize: Style.resize(11)
                font.bold: true
                color: parent.ringColor
            }
        }
    }
}
