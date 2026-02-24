// =============================================================================
// CircularProgressRings.qml — Anillos de progreso circular animados
// =============================================================================
// Cuatro anillos de progreso estilo Apple Watch / fitness tracker. Cada anillo
// se anima desde 0 hasta su valor objetivo cuando la pagina se hace visible.
//
// Patrones clave:
//   - NumberAnimation on animatedValue: animacion declarativa que arranca
//     cuando root.active cambia a true (la pagina es visible). Cada anillo
//     tiene una duracion ligeramente diferente (1200 + index*200 ms) para
//     un efecto de entrada escalonado.
//   - Canvas reactivo a propiedad: el Canvas define una propiedad "val"
//     vinculada a animatedValue. onValChanged llama a requestPaint(),
//     logrando que el arco crezca fluidamente durante la animacion.
//   - Arco desde las 12h: start = -PI/2 (las 12 en punto) y el end se
//     calcula como start + fraccion * 2PI, dibujando en sentido horario.
//   - Easing.OutCubic: desaceleracion suave al final, efecto profesional.
//   - Superposicion Canvas + Column: el icono y porcentaje se colocan
//     como hijos del mismo Item que el Canvas, centrados con anchors.
// =============================================================================
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: Style.resize(8)

    // La propiedad active controla cuando inician las animaciones de entrada.
    // Se vincula a root.fullSize desde Main.qml para que los anillos solo
    // se animen cuando la pagina esta visible.
    property bool active: false

    Label {
        text: "Circular Progress Rings"
        font.pixelSize: Style.resize(16)
        font.bold: true
        color: Style.fontPrimaryColor
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.resize(25)
        Layout.alignment: Qt.AlignHCenter

        // ── Repeater con modelo de objetos JS ──
        // Cada objeto define: etiqueta, valor objetivo (0-1), color e icono.
        // El Repeater crea 4 delegates identicos con datos diferentes.
        Repeater {
            model: [
                { label: "Downloads", value: 0.73, clr: "#00D1A9", icon: "\u2193" },
                { label: "Storage", value: 0.58, clr: "#5B8DEF", icon: "\u25C9" },
                { label: "Battery", value: 0.91, clr: "#34C759", icon: "\u26A1" },
                { label: "Upload", value: 0.35, clr: "#FF9500", icon: "\u2191" }
            ]

            delegate: ColumnLayout {
                id: ringDelegate
                spacing: Style.resize(8)

                required property var modelData
                required property int index

                // ── Animacion de entrada escalonada ──
                // animatedValue crece de 0 al valor objetivo. La duracion
                // aumenta con el indice para que cada anillo termine en un
                // momento ligeramente diferente (efecto "cascade").
                property real animatedValue: 0
                NumberAnimation on animatedValue {
                    from: 0; to: ringDelegate.modelData.value
                    duration: 1200 + ringDelegate.index * 200
                    easing.type: Easing.OutCubic
                    running: root.active
                }

                Item {
                    Layout.preferredWidth: Style.resize(110)
                    Layout.preferredHeight: Style.resize(110)
                    Layout.alignment: Qt.AlignHCenter

                    Canvas {
                        id: ringCanvas
                        anchors.fill: parent

                        // Propiedad puente: cuando animatedValue cambia,
                        // val cambia, onValChanged solicita repintado.
                        property real val: ringDelegate.animatedValue
                        onValChanged: requestPaint()

                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.reset()
                            var cx = width / 2, cy = height / 2
                            var r = cx - Style.resize(10)
                            var lw = Style.resize(8)

                            // Anillo de fondo (circulo completo, muy tenue)
                            ctx.beginPath()
                            ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                            ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.06)
                            ctx.lineWidth = lw
                            ctx.stroke()

                            // Anillo de progreso (desde las 12h en sentido horario)
                            var start = -Math.PI / 2
                            var end = start + ringDelegate.animatedValue * 2 * Math.PI
                            ctx.beginPath()
                            ctx.arc(cx, cy, r, start, end, false)
                            ctx.strokeStyle = ringDelegate.modelData.clr
                            ctx.lineWidth = lw
                            ctx.lineCap = "round"
                            ctx.stroke()
                        }

                        Component.onCompleted: requestPaint()
                    }

                    // ── Icono y porcentaje centrados sobre el Canvas ──
                    Column {
                        anchors.centerIn: parent
                        spacing: Style.resize(1)

                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: ringDelegate.modelData.icon
                            font.pixelSize: Style.resize(18)
                            color: ringDelegate.modelData.clr
                        }
                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: Math.round(ringDelegate.animatedValue * 100) + "%"
                            font.pixelSize: Style.resize(14)
                            font.bold: true
                            color: Style.fontPrimaryColor
                        }
                    }
                }

                Label {
                    text: ringDelegate.modelData.label
                    font.pixelSize: Style.resize(12)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
